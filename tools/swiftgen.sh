#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
output=packages/Localization/Sources/Localization/Localizable.swift
temp=$(mktemp -d "$(dirname "$output")/.strings.XXXXXX")
trap 'rm -rf "$temp"' EXIT
swiftgen run strings -p tools/strings.stencil --output "$temp/raw.swift" Ansible-Mac/en.lproj/Localizable.strings
python3 tools/brand-localization.py "$temp/raw.swift" "$temp/branded.swift"
mv "$temp/branded.swift" "$output"
