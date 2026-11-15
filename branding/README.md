# Ansible macOS brand resources

The application keeps its approved dark Dock/Finder icon. `masters/diamond-original.webp` is the owner's original bitmap, SHA-256 `fe7a413dd32bc80c39822fd4a08504bce96857140b4d7f96a213ba3f4d4a5068`.

Run from the repository root:

```sh
swift scripts/branding/export.swift
```

`asset-manifest.json` records exact destinations, dimensions and roles. The exporter updates 46 PNG slots. Color amounts use the original bitmap; menu icons use a luminance/alpha template; settings use a rounded blue tile. The Premium input is a transparent glyph because `generatePremiumIcon` already creates its gradient tile. Application icon slots marked `preserved-app` are skipped.

`animation-manifest.json` records exact hashes of seven reused animation files. The currency/hero comes byte-for-byte from Ansible Web `src/assets/ass/Diamond.ass`; paid reactions use its `diamonds/DiamondReaction.ass`. The three Premium gifts are the same `messages.getStickerSet(inputStickerSetPremiumGifts)` documents consumed by mobile iOS, downloaded on 15 November 2026, for 3/6/12 months. They contain crystals. Existing `.tgs` bundle names are retained for their callers; the format is the same gzip-compressed Lottie as `.ass`. No new diamond animation was drawn.

`localization-aliases.json` lists the new macOS presentation keys. Matching Swift lookup retains the original key as fallback. It isolates incompatible plain/plural families and Crystal Piece text without changing the keys consumed by old clients. English bundled strings stay UTF-16.

`previews` contains public resource contact sheets, rendered through native AppKit/TLottie. These are asset previews, not a replacement for application UI acceptance screenshots.
