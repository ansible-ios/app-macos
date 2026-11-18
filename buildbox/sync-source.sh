#!/bin/sh
set -e

SOURCE_DIR="$1"
DEST_DIR="$2"

mkdir -p "$DEST_DIR"
rsync -a --delete \
    --exclude='/core-xprojects/*/build/' \
    --exclude='/Ansible-Mac/Release.xcconfig' \
    --exclude='/submodules/ansible-ios/submodules/MTProtoRustEngine/MTProtoEngineFFI.xcframework/' \
    --exclude='/submodules/**/SharedHeaders/' \
    --exclude='/.build/ansible-api-generation/' \
    --exclude='/submodules/ansible-ios/build-system/SwiftTL/.build/' \
    --exclude='/submodules/ansible-ios/submodules/TelegramApi/Sources/SwiftPMGenerated/' \
    --exclude='/submodules/ansible-ios/submodules/TelegramApi/ObjC/SwiftPMGenerated/' \
    --exclude='/submodules/ansible-ios/submodules/TelegramApi/Tests/SwiftPMGenerated/' \
    --exclude='/submodules/ansible-ios/submodules/TelegramCore/FlatSerialization/Sources/' \
    --exclude='/.ci-build-logs/' \
    "$SOURCE_DIR/" "$DEST_DIR/"
