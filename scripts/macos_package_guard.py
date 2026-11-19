import json
from pathlib import Path
import re
import struct
import subprocess
import zlib


CORE = Path("submodules/ansible-ios/submodules/TelegramCore")
API = CORE.parent / "TelegramApi"
WIDGET = Path("third-party/widget-sandbox")
GIFT_EXPORT_METHODS = {"getStarGiftWithdrawalUrl", "withdrawStarGift", "depositStarGift"}
CHAIN_NAMES = {"ton", "toncoin", "tonlib", "tonlibjson", "tonconnect", "gram", "grams", "gramlib"}


def check_names(names, location):
    for name in names:
        words = re.sub(r"([A-Z])([A-Z][a-z])", r"\1 \2", name)
        words = re.sub(r"([a-z0-9])([A-Z])", r"\1 \2", words).lower()
        if ("wallet" in words or CHAIN_NAMES.intersection(re.findall(r"[a-z]+", words)) or
                name.split(".")[-1] in GIFT_EXPORT_METHODS):
            raise RuntimeError(f"{location}: forbidden wallet dependency or RPC: {name}")


def check_packages(root, environment=None):
    project = root / "Ansible.xcodeproj/project.pbxproj"
    pending = set((root / "packages").glob("*/Package.swift"))
    if not pending:
        raise RuntimeError(f"{root}/packages: no macOS package manifests found")
    required = (CORE, CORE.parent / "PasscodeCore", WIDGET, "third-party/twidget", "submodules/tgcalls")
    pending.update(root / path / "Package.swift" for path in required)
    projects = [project, *(root / "core-xprojects").glob("*/*.xcodeproj/project.pbxproj")]
    configs = (root / "configurations").rglob("*.xcconfig")
    workspaces = (root / "Ansible-Mac.xcworkspace", project.parent / "project.xcworkspace")
    locks = [path for workspace in workspaces for path in workspace.rglob("Package.resolved")]
    for path in [*projects, *configs, *locks]:
        check_names([str(path.relative_to(root))], path)
        source = path.read_text(encoding="utf-8")
        check_names(re.findall(r"[\w./+:-]+", source), path)
        if path == project:
            for relative in re.findall(r'\b(?:relativePath|path) = "?((?:submodules|packages|third-party)/[^";]+)"?;', source):
                manifest = root / relative / "Package.swift"
                if manifest.is_file():
                    pending.add(manifest)
    visited = set()
    missing = set()
    while pending:
        path = pending.pop().resolve()
        if path in visited:
            continue
        visited.add(path)
        check_names([path.parent.name], path)
        source = re.sub(r"(?m)^\s*//[^\n]*", "", path.read_text(encoding="utf-8"))
        declarations = re.sub(r"\bexclude\s*:\s*\[[^\]]*\]", "", source)
        check_names(re.findall(r'"([^"\n]+)"', declarations), path)
        relatives = re.findall(r'\.package\s*\([^)]*?\bpath\s*:\s*"([^"]+)"', source)
        relatives += re.findall(r'\(\s*"[^"]+"\s*,\s*"(\.[^"]+)"\s*\)', source)
        for relative in relatives:
            dependency = path.parent / relative / "Package.swift"
            if dependency.is_file():
                pending.add(dependency)
            else:
                missing.add(dependency)
    identities = {path.parent.name.lower() for path in visited}
    for dependency in sorted(missing):
        if dependency.parent.name.lower() not in identities:
            raise RuntimeError(f"could not inspect local package: {dependency}")
    description = json.loads(subprocess.check_output(
        ["swift", "package", "--package-path", str(root / CORE), "describe", "--type", "json"],
        text=True, env=environment))
    target = next((t for t in description["targets"] if t["name"] == "TelegramCore"), None)
    if not target or not target.get("sources"):
        raise RuntimeError("SwiftPM returned no TelegramCore sources")
    for target in description["targets"]:
        if target["type"] != "test":
            check_names((p for p in target.get("sources", []) if
                         p != "SyncCore/SyncCore_PendingWalletTransferMessageAttribute.swift"),
                        f"TelegramCore/{target['name']}")


def check_rpcs(names, path):
    if "payments.getStarsStatus" not in names:
        raise RuntimeError(f"{path}: could not identify the payments RPC table")
    check_names(sorted(names), path)


def check_schema(api):
    path = api / "swift_scheme.tl"
    section = path.read_text(encoding="utf-8").partition("---functions---")[2]
    check_rpcs(set(re.findall(r"^\s*([\w.]+)#", section, re.M)), path)


def check_generated(api):
    swift = api / "Sources/SwiftPMGenerated"
    names = set()
    for path in swift.glob("*.swift"):
        source = path.read_text(encoding="utf-8")
        for namespace, body in re.findall(
                r"extension\s+Api\.functions(?:\.(\w+))?\s*\{(.*?)^\}", source, re.M | re.S):
            check_names([namespace], path)
            for method in re.findall(r"\bfunc\s+`?(\w+)`?\s*\(", body):
                names.add(f"{namespace}.{method}".lstrip("."))
    check_rpcs(names, swift)

    path = api / "ObjC/SwiftPMGenerated/TLApiSchemaData.m"
    array = re.search(r"TLApiSchemaCompressed\[\]\s*=\s*\{([^}]*)\}", path.read_text())
    if not array:
        raise RuntimeError(f"{path}: missing compressed RPC table")
    try:
        blob = zlib.decompress(bytes.fromhex("".join(re.findall(r"0x([\da-fA-F]{2})", array[1]))))
        magic, version, _, size, _, _, count, _, _, pool, pool_size, _, _, _, _, table, _ = (
            struct.unpack_from("<4sIQ14I", blob))
        if ((magic, version, size) != (b"TLS1", 3, len(blob)) or
                table + count * 28 != pool or pool + pool_size != size):
            raise ValueError("unexpected TLS1 function table layout")
        names = set()
        for offset in range(table, pool, 28):
            start = pool + struct.unpack_from("<I", blob, offset)[0]
            names.add(blob[start:blob.index(b"\0", start)].decode("ascii"))
    except (ValueError, struct.error, zlib.error) as error:
        raise RuntimeError(f"{path}: invalid generated RPC table: {error}") from error
    check_rpcs(names, path)


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1])
    root = parser.parse_args().root.resolve()
    try:
        check_packages(root)
        check_schema(root / API)
        check_generated(root / API)
    except (OSError, RuntimeError, subprocess.CalledProcessError) as error:
        parser.exit(1, f"error: {error}\n")
    print("Wallet guard passed for macOS packages, Xcode targets and generated RPCs.")
