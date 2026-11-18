#!/bin/sh
set -eu

scripts_dir="$(CDPATH= cd "$(dirname "$0")" && pwd)"
ios="$scripts_dir/../submodules/ansible-ios"

if [ ! -f "$ios/submodules/TelegramVoip/Package.swift" ]; then
    printf 'Initialize the ansible-ios submodule before preparing the macOS build.\n' >&2
    exit 1
fi

case "$#:${1:-}" in
    0:)
        patches="ansible-ios-macos.patch ansible-network.patch ansible-media.patch"
        ;;
    1:--reverse)
        patches="ansible-media.patch ansible-network.patch ansible-ios-macos.patch"
        ;;
    *)
        printf 'Usage: %s [--reverse]\n' "$0" >&2
        exit 2
        ;;
esac

for name in $patches; do
    patch="$scripts_dir/$name"
    if [ "$#" -eq 0 ]; then
        if git -C "$ios" apply --unidiff-zero --reverse --check "$patch" 2>/dev/null; then
            continue
        fi
    elif git -C "$ios" apply --unidiff-zero --check "$patch" 2>/dev/null; then
        continue
    fi
    git -C "$ios" apply --unidiff-zero --check "$@" "$patch"
    git -C "$ios" apply --unidiff-zero --whitespace=nowarn "$@" "$patch"
done
