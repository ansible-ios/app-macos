# Ansible macOS integration

Source audit and local validation: 14 November 2026.

## Reference implementations

The integration was checked against the local `app-ios` and `app-desktop` implementations and the Ansible backend sources, rather than only their README summaries.

| Area | Existing Ansible implementation | Native macOS adaptation |
|---|---|---|
| Bootstrap | iOS `Network.swift`, Desktop DC options | DC1 `85.193.80.91:10443`; no Telegram backup discovery |
| Server identity | iOS/Desktop RSA public key | Same public key; fingerprint `ddcf36f8466e4286` matched the endpoint's resPQ response |
| API credentials | Existing Ansible client configuration | Local ignored xcconfig; no upstream fallback |
| Links | Desktop `as://`; iOS handles `as://` and registers an extra application scheme | Canonical `as://`, `asme.su` and `www.asme.su`; generated QR-login/proxy/profile links use Ansible |
| Animated stickers | iOS media model and backend use `application/x-ansible-sticker` | Same MIME and `.ass` extension for file attributes, imports and bundled animations |
| Anonymous numbers | Backend `rpc_help.erl`, prefix 777, unmasked 1–8 digit tail | Country FT, longest-prefix parsing, variable-length formatting |
| Translations | Backend supports a separate `macos` platform | Retains `macos`; existing localization identifiers are preserved |
| Currency | iOS Diamonds artwork and strings | Diamonds text, static icons, inline animation artwork and a diamond currency scene |
| Storage | Separate application identity | `com.ansible.macos`, own keychain scope and standalone Application Support directory |

`asme.su` is the backend's `me_url_prefix`. General information, privacy, FAQ and terms use `ansible.su`. The iOS client also registers `ansible://`; this macOS build deliberately uses the canonical Desktop scheme requested for this client, `as://`.

## Patch ownership

The shared Telegram-iOS checkout remains pinned to the upstream revision. Ansible changes to that checkout are carried as parent-repository patches and applied by `scripts/prepare-ansible-ios.sh`, not as unpushed submodule commits:

- `ansible-ios-macos.patch`: upstream macOS preparation.
- `ansible-network.patch`: Ansible bootstrap and server key.
- `ansible-media.patch`: Ansible animated-sticker recognition and file attributes.

The preparation script supports idempotent application and reversal. Local Xcode 27 project adjustments are temporary and are reverted before publishing source changes.

## Validation

- Native ARM64 build and strict ad-hoc code-signature verification.
- Focused `+777` number checks, contact-token parsing, scheme normalization and rejection of misleading contact-link hosts.
- Preservation of all 9448 bundled localization keys and format arguments; localized menu/plist validation.
- Offline rendering of the mobile-derived inline Diamond with the same tlottie renderer used by the client. Inline currency artwork remains one frame to avoid adding continuous animation to message lists.
- The initial app launch was observed. Verification of the latest UI after a restart is pending the owner's completion of work in the currently running application.

## Compatibility boundaries

The upstream native core declares layer 233; the existing iOS fork declares layer 230, and the checked-in backend schema set currently reaches layer 232. These are separate source facts, not a claim about the currently deployed server configuration.

A schema comparison found 27 native-only entries and one changed RPC wire signature (`channels.toggleForum`, adding `sidebar`). The two common response types with textual differences (`user`, `channel`) retain the same constructor IDs and only add boolean flag names. The layer has not been artificially lowered to hide these differences.

Authenticated end-to-end tests of the latest build and the newer native-only APIs have not yet been completed. This initial integration must not be described as full feature parity or complete removal of upstream TON/wallet functionality. App Store distribution, Developer ID signing/notarization, App Groups, push delivery and an Ansible update feed require their own configured release setup.
