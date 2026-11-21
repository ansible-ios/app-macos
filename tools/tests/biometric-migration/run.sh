#!/bin/sh
set -eu
tests="$(cd "$(dirname "$0")" && pwd)"
deps="$tests/../../../submodules/ansible-ios/submodules"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
pkg="$work/Migration"
mkdir -p "$pkg/Sources/PasscodeCore" "$pkg/Tests/MigrationTests"
ln -s "$deps/SSignalKit" "$work/SSignalKit"
cp "$tests/Package.swift" "$pkg/"
for file in Passcode PasscodeCrypto PasscodeKeychainScope; do
    cp "$deps/PasscodeCore/Sources/$file.swift" "$pkg/Sources/PasscodeCore/"
done
cp "$tests/BiometricMigrationTests.swift" "$pkg/Tests/MigrationTests/"
swift test --package-path "$pkg"
