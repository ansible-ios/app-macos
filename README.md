# Ansible for macOS

<img src="Telegram-Mac/Assets.xcassets/AppIcon.appiconset/Logo_128.png" width="96" alt="Ansible">

Native macOS client for the [Ansible](https://ansible.su) messaging service, built with Swift and AppKit.

> **This project is a fork of [Telegram for macOS](https://github.com/TelegramMessenger/telegram-macos).**
> It is distributed under the [GNU General Public License, version 2](LICENSE), as is the upstream project.
> We thank the Telegram for macOS contributors for the code on which this client is based.
>
> Ansible for macOS is **not affiliated with, endorsed by, or sponsored by Telegram**.
> It connects to Ansible infrastructure and uses Ansible accounts.

[![License: GPLv2](https://img.shields.io/badge/License-GPLv2-blue.svg)](LICENSE)
[![Upstream](https://img.shields.io/badge/forked%20from-Telegram%20for%20macOS-orange.svg)](https://github.com/TelegramMessenger/telegram-macos)

## What this is

This is the native macOS client for Ansible. It is a separate application from the cross-platform [Ansible Desktop](https://github.com/ansible-desktop/app-desktop) client and shares its core libraries with Telegram-iOS.

The Ansible integration includes:

- **Backend connection:** Ansible DC1 bootstrap, server public key and locally configured Ansible API credentials. Telegram backup discovery and update feeds are disabled.
- **Own identity:** the Ansible name, application identifier, mobile-client artwork, menus, login screens and currency labels.
- **Own links:** `https://asme.su/` and `as://`, matching Ansible Desktop and iOS. Telegram links are not resolved as Ansible accounts.
- **Own media format:** `.ass` animated stickers with `application/x-ansible-sticker`, matching the iOS client and backend.
- **Diamonds:** the internal currency is presented as Diamonds, with diamond icons and artwork from the iOS client. Wire identifiers such as `XTR` remain protocol identifiers.
- **Anonymous numbers:** the `+777` prefix with 1–8 digits after it, matching the backend country configuration.
- **Separate storage:** application data and keychain items are scoped to Ansible; Telegram account data is not migrated.

This is a development integration. A successful local build is not a release certification; see [integration and verification notes](docs/ansible-integration.md) for the checks and remaining compatibility work.

## Relationship to upstream

| | Telegram for macOS | Ansible for macOS |
|---|---|---|
| License | GPL v2 | GPL v2 |
| Backend and accounts | Telegram | Ansible |
| Public links | `t.me` | `asme.su` |
| Application scheme | `tg://` | `as://` |
| Animated stickers | `.tgs` | `.ass` |
| Currency presentation | Stars | Diamonds |
| Application identifier | `ru.keepcoder.Telegram` | `com.ansible.macos` |
| Source | [TelegramMessenger/telegram-macos](https://github.com/TelegramMessenger/telegram-macos) | [ansible-ios/app-macos](https://github.com/ansible-ios/app-macos) |

The initial upstream base is [`246e3e95`](https://github.com/TelegramMessenger/telegram-macos/commit/246e3e95). The latest integrated upstream revision is [`38309ec9`](https://github.com/TelegramMessenger/telegram-macos/commit/38309ec9). Internal module names, protocol symbols and copyright headers retain upstream names where appropriate.

## Building from source

Requirements: Xcode, its Metal toolchain, Homebrew build tools and Rust. See [INSTALL.md](INSTALL.md) for native dependency setup and [XCODE27.md](XCODE27.md) for Xcode 27 compatibility details.

```sh
git clone https://github.com/ansible-ios/app-macos.git
cd app-macos
git -c url.https://github.com/.insteadOf=git@github.com: submodule update --init --recursive
cp configurations/Ansible.local.example.xcconfig configurations/Ansible.local.xcconfig
```

Set `ANSIBLE_API_ID` and `ANSIBLE_API_HASH` in `configurations/Ansible.local.xcconfig`. This file is ignored by Git; do not publish it. The client does not fall back to Telegram API credentials.

With Homebrew tools and Cargo on `PATH`:

```sh
bash scripts/build-ansible.sh
```

The helper applies the pinned macOS/Ansible core patches, prepares native dependencies, builds and ad-hoc signs the Debug app. On Xcode 27 it also applies the local compatibility changes documented in XCODE27.md. Revert those generated project changes with `bash scripts/xcode27.sh revert` before committing.

Build parallelism defaults to two tasks; override it with `ANSIBLE_BUILD_JOBS` when appropriate. On Apple Silicon the application is built for ARM64. An Intel-only dependency generator can require Rosetta 2 even though the resulting application is native ARM64.

The result is `.build/Ansible/Build/Products/Debug/Ansible.app`. To build and launch it:

```sh
bash scripts/build-ansible.sh --run
```

Standalone Debug data is stored under `~/Library/Application Support/com.ansible.macos/debug`. The Share extension requires a separately configured signed App Group build; it is not supported in the standalone ad-hoc build.

## Verification

```sh
swiftc packages/PhoneNumberUtils/Sources/PhoneNumberUtils/AnsiblePhoneNumber.swift tools/tests/ansible-phone-numbers.swift -o /tmp/ansible-phone-tests
/tmp/ansible-phone-tests
python3 tools/tests/contact-free-links/run.py
```

The native workspace and scheme retain their upstream names: `Telegram-Mac.xcworkspace` and `Telegram`.

## License and attribution

Ansible for macOS is free software distributed under the **GNU General Public License, version 2**. See [LICENSE](LICENSE) and [NOTICE](NOTICE). Third-party components retain their respective licenses and notices.

The upstream fork requirements are addressed by using Ansible API credentials, an independent product name and logo, and publishing the source. Upstream security guidance remains relevant and is not replaced by branding changes.

“Telegram” is used to identify and credit the upstream project, not as the name or trademark of this application.

## Contact

- Project: [ansible.su](https://ansible.su)
- Source code and issues: [ansible-ios/app-macos](https://github.com/ansible-ios/app-macos)
