from pathlib import Path
import hashlib
import gzip
import json
import re
import shutil
import subprocess
import sys

lab = Path(__file__).resolve().parent
root = lab.parents[2]
output = Path(sys.argv[1]).resolve()
assert output.is_relative_to(Path('/tmp').resolve()) and not output.exists()

shutil.copytree(lab, output, ignore=shutil.ignore_patterns('.build', 'results'))
kit = root / 'packages/AnsibleUIKit'
copy = output / 'AnsibleUIKit'
hashes = {}
for folder in ['Sources', 'Tests']:
    for path in (kit / folder).rglob('*'):
        if path.is_file():
            relative = path.relative_to(kit)
            destination = copy / relative
            destination.parent.mkdir(parents=True, exist_ok=True)
            destination.write_bytes(path.read_bytes())
            hashes[str(relative)] = hashlib.sha256(path.read_bytes()).hexdigest()
for relative, expected in hashes.items():
    assert hashlib.sha256((kit / relative).read_bytes()).hexdigest() == expected
    assert hashlib.sha256((copy / relative).read_bytes()).hexdigest() == expected
manifest = (kit / 'Package.swift').read_text()
manifest = re.sub(r'(path: ")([^"]+)', lambda m: m[1] + str((kit / m[2]).resolve()) if m[2].startswith('..') else m[0], manifest)
(copy / 'Package.swift').write_text(manifest)
path = output / 'Package.swift'
path.write_text(path.read_text().replace('../../../packages/AnsibleUIKit', str(copy)))
baseline = output / 'AnsibleUIKitBaseline'
shutil.copytree(copy, baseline)
path = baseline / 'Package.swift'
path.write_text(path.read_text().replace('"AnsibleUIKit"', '"AnsibleUIKitBaseline"').replace('name: "AnsibleUIKitTests"', 'name: "AnsibleUIKitBaselineTests"'))
for name in ['ShimmerLayer.swift', 'ShimmerEffect.swift']:
    original = gzip.decompress((lab / 'Reference' / (name + '.gz')).read_bytes())
    candidate = gzip.decompress((lab / 'Reference' / (name + '.candidate.gz')).read_bytes())
    metadata = json.loads((lab / 'Reference' / (name + '.provenance.json')).read_text())
    assert hashlib.sha256(original).hexdigest() == metadata['original_sha256']
    assert hashlib.sha256(candidate).hexdigest() == metadata['candidate_sha256']
    assert (copy / 'Sources' / name).read_bytes() in [original, candidate]
    (copy / 'Sources' / name).write_bytes(candidate)
    (baseline / 'Sources' / name).write_bytes(original)
(output / 'snapshot.json').write_text(json.dumps(hashes, indent=2) + '\n')
print(output)

for module in [copy, baseline]:
    for name in ['ShimmerLayer.swift', 'ShimmerEffect.swift']:
        path = module / 'Sources' / name
        path.write_text(path.read_text() + (lab / (name + '.inspection.txt')).read_text())
    path = module / 'Sources/ShimmerLayer.swift'
    suffix = 'baseline' if module == baseline else 'candidate'
    path.write_text(path.read_text() + (lab / ('cache.' + suffix + '.inspection.txt')).read_text())
