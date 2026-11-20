from pathlib import Path
import json
import subprocess
import tempfile

root = Path(__file__).resolve().parents[3]
api = root / "submodules/ansible-ios/submodules/TelegramApi"
source = (api / "swift_scheme.tl").read_text()
declarations = {line.split("#", 1)[0]: " ".join(line.split()) for line in source.splitlines() if "#" in line and not line.startswith("//")}
expected = json.loads(Path(__file__).with_name("schema.json").read_text())
for name, line in expected.items():
    assert declarations.get(name) == " ".join(line.split()), "Layer 233 declaration mismatch: " + name
print(f"Layer 233: {len(expected)} non-TON declarations match the official schema", flush=True)
with tempfile.TemporaryDirectory(prefix="layer233-wire-") as directory:
    directory = Path(directory)
    manifest = """// swift-tools-version:5.9
import PackageDescription
let package = Package(name: "Layer233Wire", platforms: [.macOS(.v10_13)], dependencies: [.package(path: __API__)], targets: [.executableTarget(name: "Layer233Wire", dependencies: [.product(name: "TelegramApi", package: "TelegramApi")], path: "Sources")])
""".replace("__API__", json.dumps(str(api)))
    (directory / "Package.swift").write_text(manifest)
    (directory / "Sources").mkdir()
    (directory / "Sources/main.swift").write_text(Path(__file__).with_name("WireTests.swift").read_text())
    subprocess.run(["swift", "run", "--package-path", str(directory), "--disable-sandbox", "--jobs", "4", "Layer233Wire", str(Path(__file__).with_name("vectors.json"))], check=True)
