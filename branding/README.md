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
