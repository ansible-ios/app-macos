from pathlib import Path
import hashlib
import json
import re
import shutil
import subprocess
import sys

lab = Path(__file__).resolve().parent
root = lab.parents[2]
variant, destination = sys.argv[1:]
assert variant in ("baseline", "candidate")
destination = Path(destination)
kit = root / "packages/AnsibleUIKit"
baseline = "ee780ff8b"
changed = ["ImageButton.swift", "SelectingControl.swift"]

for name in ("Sources", "Tests"):
    target = destination / "AnsibleUIKit" / name
    if target.exists():
        shutil.rmtree(target)
    shutil.copytree(kit / name, target)
manifest = (kit / "Package.swift").read_text()
manifest = re.sub(r'(\.package\(name: "[^"]+", path: ")([^"]+)', lambda m: m[1] + str((kit / m[2]).resolve()), manifest)
(destination / "AnsibleUIKit/Package.swift").write_text(manifest)
if variant == "baseline":
    for name in changed:
        source = subprocess.check_output(["git", "show", f"{baseline}:packages/TGUIKit/Sources/{name}"], cwd=root)
        (destination / "AnsibleUIKit/Sources" / name).write_bytes(source)

target = destination / "ControlLab/Sources"
if target.exists():
    shutil.rmtree(target)
shutil.copytree(lab / "Sources", target)
(destination / "ControlLab/Package.swift").write_text((lab / "Package.swift").read_text().replace("../../../packages/AnsibleUIKit", "../AnsibleUIKit"))
files = [destination / "AnsibleUIKit/Sources" / name for name in changed]
files.append(destination / "ControlLab/Sources/ControlLab/main.swift")
provenance = {
    "variant": variant,
    "baselineCommit": baseline,
    "swift": subprocess.check_output(["swift", "--version"], text=True).strip(),
    "sha256": {str(p.relative_to(destination)): hashlib.sha256(p.read_bytes()).hexdigest() for p in files},
}
(destination / "provenance.json").write_text(json.dumps(provenance, indent=2) + "\n")
