#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
if [[ $# -gt 1 || ( $# -eq 1 && "$1" != "--run" ) ]]; then
    echo "Usage: scripts/build-ansible.sh [--run]" >&2
    exit 2
fi

python3 - <<'PY'
from pathlib import Path
import re

path = Path("configurations/Ansible.local.xcconfig")
if not path.is_file():
    raise SystemExit("Copy configurations/Ansible.local.example.xcconfig to Ansible.local.xcconfig and configure the Ansible API credentials.")
text = path.read_text()
api_id = re.search(r"(?m)^ANSIBLE_API_ID\s*=\s*([1-9][0-9]*)\s*$", text)
api_hash = re.search(r"(?m)^ANSIBLE_API_HASH\s*=\s*([0-9a-fA-F]{32})\s*$", text)
if not api_id or not api_hash:
    raise SystemExit("Configure valid ANSIBLE_API_ID and ANSIBLE_API_HASH in Ansible.local.xcconfig.")
PY

export CMAKE_POLICY_VERSION_MINIMUM=3.5
export CARGO_PROFILE_RELEASE_STRIP=none
/bin/bash scripts/prepare-ansible-ios.sh
if [[ "$(xcodebuild -version | head -1)" == "Xcode 27"* ]]; then
    /bin/bash scripts/xcode27.sh apply
fi
/bin/bash scripts/configure_frameworks.sh
xcodebuild -quiet -jobs "${ANSIBLE_BUILD_JOBS:-2}" -workspace Ansible-Mac.xcworkspace -scheme Ansible \
    -configuration Debug -destination "platform=macOS,arch=$(uname -m)" \
    -derivedDataPath "$ROOT/.build/Ansible" \
    CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO build
APP="$ROOT/.build/Ansible/Build/Products/Debug/Ansible.app"
test -x "$APP/Contents/MacOS/Ansible"
codesign --force --deep --sign - "$APP"
codesign --verify --deep --strict "$APP"
if [[ "${1:-}" == "--run" ]]; then
    open "$APP"
fi
