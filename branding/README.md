# Ansible macOS brand resources

The application keeps its approved dark Dock/Finder icon. `masters/diamond-original.webp` is the owner's original bitmap, SHA-256 `fe7a413dd32bc80c39822fd4a08504bce96857140b4d7f96a213ba3f4d4a5068`.

Run from the repository root:

```sh
swift scripts/branding/export.swift
```

`asset-manifest.json` records exact destinations, dimensions and roles. The exporter updates 46 PNG slots. Color amounts use the original bitmap; menu icons use a luminance/alpha template; settings use a rounded blue tile. The Premium input is a transparent glyph because `generatePremiumIcon` already creates its gradient tile. Application icon slots marked `preserved-app` are skipped.

`animation-manifest.json` records exact hashes of the bundled brand animations. The currency/hero comes byte-for-byte from Ansible Web `src/assets/ass/Diamond.ass`; paid reactions use its `diamonds/DiamondReaction.ass`. The three Premium gifts are the same `messages.getStickerSet(inputStickerSetPremiumGifts)` documents consumed by mobile iOS, downloaded on 15 November 2026, for 3/6/12 months. They contain crystals. Existing `.tgs` bundle names are retained for their callers; the format is the same gzip-compressed Lottie as `.ass`. No new diamond animation was drawn.

`localization-aliases.json` lists the new macOS presentation keys. Matching Swift lookup retains the original key as fallback. It isolates incompatible plain/plural families and Crystal Piece text without changing the keys consumed by old clients. English bundled strings stay UTF-16.

`previews` contains public resource contact sheets, from native AppKit/TLottie and rlottie. These are asset previews, not a replacement for application UI acceptance screenshots.

The chat chooses from five paid reaction effects. Variants 1–3 use the desktop pack, and variants 4–5 use the Android pack compressed as TGS. The broadcast-group animation and the 64 px SceneKit particle texture come from the iOS pack. See [three sample frames per animation](previews/reaction-effects-and-group.png). Both animated QR logos already match the iOS pack byte for byte. QR Studio uses the macOS menu diamond template for its fee label.

The [system resource comparison](previews/system-surfaces.png) shows the menu bar template from the Web pack, the login mask, the signed-out Share extension image, the recorded video-message watermark, the dark alternate icon resource and the folder menu animation. The folder animation keeps its macOS timing and uses the white foreground path of the Web logo as a template. Phone sign-in uses the dark iOS pack icon at 140 and 280 pixels. The sign-in QR and exported invitation QR use the Ansible mark in the foreground color of the QR itself. The web login confirmation uses the same mark in the current theme.

Premium, boosts and gift headers load the iOS pack’s uncompressed star2 scene. The coin used by affiliate and business screens has the pack’s reverse-side logo. Both source scenes matched the macOS originals before substitution. The star scene resolves its two particle-image references to the bundled badgestar.png. Verify lighting, rotation and particles in SceneKit on the Mac.

[Payment and gift resources before and after](previews/payments-and-gifts.png) compares macOS slots at their original scales. Auction carryover and refunds use the iOS pack’s NextDrop and Refund shapes. The refund master retains its circular arrow on re-export. Paid broadcasts use the pack’s bubble with a diamond cutout. Paid messages, subscription invitations, Premium bot and unknown top-ups, and the gift guide use the pack’s ButtonStar diamond. The recurring arrows, top-up plus and gift box distinguish these actions at small sizes.

[Giveaway, boost and affiliate resources before and after](previews/giveaways-boosts-affiliates.png) shows the iOS pack artwork in the macOS slots and five frames of the gift menu animation. Giveaway announcements, results and winners’ messages use the same Diamond prize artwork thresholds at 1,000 and 2,500.

The [Premium, identity and paid menu comparison](previews/premium-paid-and-identity.png) shows both macOS template states. Profile and boarding badges use the iOS pack's `Peer_Info__PremiumIcon.pdf`, sticker packs use `Chat_Input_Media__EntityInputPremiumIcon.pdf`, and the emoji picker uses `Chat_Context_Menu__Stars.pdf`. The Passport cover and unsupported-message overlay use the foreground of `Share__QrPlaneIcon.pdf`. Both large and small send buttons use the Web pack's `assets_font-icons__new-send.svg`. The paid menu uses the four Gem paths from the iOS pack's `PremiumStar.ass` with the original macOS pulse timing. Its static template is rendered from frame zero.
