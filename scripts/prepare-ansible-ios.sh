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
        patches="ansible-uikit.patch ansible-ios-macos.patch ansible-network.patch ansible-media.patch ansible-sticker-upload.patch ansible-sticker-playback.patch ansible-pack-covers.patch ansible-pack-editing.patch ansible-macos-no-wallet.patch ansible-forum-errors.patch"
        ;;
    1:--reverse)
        patches="ansible-forum-errors.patch ansible-macos-no-wallet.patch ansible-pack-editing.patch ansible-pack-covers.patch ansible-sticker-playback.patch ansible-sticker-upload.patch ansible-media.patch ansible-network.patch ansible-ios-macos.patch ansible-uikit.patch"
        ;;
    *)
        printf 'Usage: %s [--reverse]\n' "$0" >&2
        exit 2
        ;;
esac

for name in $patches; do
    patch="$scripts_dir/$name"
    if [ "$#" -eq 0 ]; then
        if [ "$name" = ansible-media.patch ] &&
            git -C "$ios" apply --unidiff-zero --reverse --check "$scripts_dir/ansible-sticker-playback.patch" 2>/dev/null &&
            git -C "$ios" apply --unidiff-zero --reverse --check --exclude='*/SyncCore_TelegramMediaFile.swift' "$patch" 2>/dev/null; then
            continue
        fi
        if git -C "$ios" apply --unidiff-zero --reverse --check "$patch" 2>/dev/null; then
            continue
        fi
    elif [ "$name" = ansible-sticker-playback.patch ] && git -C "$ios" apply --unidiff-zero --check "$scripts_dir/ansible-media.patch" 2>/dev/null; then
        continue
    elif git -C "$ios" apply --unidiff-zero --check "$patch" 2>/dev/null; then
        continue
    fi
    git -C "$ios" apply --unidiff-zero --check "$@" "$patch"
    git -C "$ios" apply --unidiff-zero --whitespace=nowarn "$@" "$patch"
done
