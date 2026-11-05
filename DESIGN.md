# Postcrate design

Approved 2026-11-02. Open [design/reference.html](design/reference.html) in a browser to see everything below rendered in light and dark.

## Product

- Keep every post in one place, stored locally on the device.
- Share a post through apps already installed on the phone (mostly social media) using the system share sheet.
- No accounts or sign-up.
- Backup to a file: one zip with every post and file, saved wherever the user chooses (Files, Google Drive, iCloud Drive, a computer). Restore everything or only chosen days. No accounts, no servers, no API keys. See [docs/backup.md](docs/backup.md).
- Flutter, feature-based architecture, production grade.

## Files

| Path | What it is |
|---|---|
| `design/tokens.json` | Single source for color, corners, spacing, sizes, type, motion. Map into Flutter `ThemeData` and a `ThemeExtension`; never hardcode values in widgets. |
| `design/logo/generate.mjs` | Single source for the logo. `node design/logo/generate.mjs` regenerates every asset. |
| `design/logo/out/` | Generated SVGs: mark (ink, paper, currentColor), app icons (full-bleed 1024 and squircle previews), Android adaptive foreground and monochrome, construction sheet. |
| `design/reference.html` | Visual reference with light, dark and system toggle. |

## Decisions

### Palette: Ink and paper

Pure neutral, no hue. Color on screen comes from the posts themselves.

| Token | Light | Dark |
|---|---|---|
| page | #F2F2F2 | #0A0A0A |
| card | #FFFFFF | #1A1A1A |
| fieldOnCard | #F0F0F0 | #262626 |
| fieldOnPage | #E6E6E6 | #1F1F1F |
| textPrimary | #111111 | #F2F2F2 |
| textSecondary | #4A4A4A | #A8A8A8 |
| textTertiary | #6E6E6E | #939393 |
| primaryFill (white text) | #111111 | #3A3A3A |
| dangerFill (white text) | #B3261E | #B3261E |

All text pairs pass WCAG AA on every surface they sit on. Full list, including success, warning, switches and app icon colors, is in `tokens.json`.

### Surfaces: borderless, iOS grouped style

- Cards, fields, inputs and buttons have no borders.
- Each layer is one shade away from its container: page, then card, then field.
- Secondary buttons are filled with the field shade, not outlined.
- The only lines allowed are inset list separators inside a grouped card (6% of text color).

### Corners: continuous

- Superellipse corners everywhere (Flutter: `RoundedSuperellipseBorder`, `ClipRSuperellipse`).
- Radii: control 10, nav tile 12, card 16, sheet 22. App icon corner ratio 0.2237.

### Logo: P1, Orbit flight

A paper plane flying clockwise around an orbit: your post, sent out from one place. Built on a 24-unit grid.

- Orbit: ring centered at (12, 12), radius 8.5, stroke 2.5, round ends.
- Plane: dart `M0 0 L11 4.5 L0 9 L2.6 4.5 Z` with a 1.2 stroke and round joins, scaled 0.78, centered on the orbit at -45° and rotated +45° to follow it.
- Gap: the ring is an open arc from 1.35° to 254.40°. The generator solves those angles so each round end stops exactly 1.5 units from the plane's outline.
- The mark spans 60% of the app icon and 40% of the Android adaptive canvas (inside the safe zone).
- App icons sit on neutral tiles: #F4F4F4 with the ink mark, #141414 with the paper mark. Icon tiles use superellipse corners (n = 5).
- The in-app mark is 26 px, slightly larger than the 22 px nav icons, with no tile behind it. On Home it sits next to the app name, which replaces the page title. Library and Backup show their own titles.
- One source: `design/logo/generate.mjs` (geometry), `bash design/logo/export_icons.sh` (every platform asset). `lib/core/widgets/pc_mark.dart` paints the same geometry in the app.

### Type

System font only (San Francisco, Roboto, Segoe UI). No monospace anywhere, including IDs. iOS text style scale from large title 34 to caption 11. Selected states change color or background only, never weight or size.

### Motion

- Standard: curve (0.32, 0.72, 0, 1), 420 ms. Quick: same curve, 240 ms.
- Reduced motion: replace movement with a 150 ms cross-fade.

### Interaction

No hover, focus ring, ripple, splash or press highlight on any control. In Flutter: `NoSplash.splashFactory`, transparent splash, highlight, hover and focus colors, transparent button overlay, `focusedBorder` equal to `enabledBorder`. Keep selected, disabled, invalid and loading states.

### Navigation

- Phone: bottom bar with three tabs: Library, Home (center, selected on launch), Backup. Same size and baseline for every tab.
- Icons sit on 44 pt square tiles with 12 radius. The selected tile is an 8% tint of the text color.
- Bottom bar has no top border. It fades up into the content with a smootherstep curve and gets slightly darker toward the bottom edge. Inactive tiles have a solid base so content never shows through.
- Tablet and desktop: the same three destinations in an icon rail or sidebar, with the same tile and icon sizes.
- Header shows page context only.

## Post model

### Post

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| title | string? | YouTube, Reddit, LinkedIn articles |
| body | string | Main text |
| threadParts | list of string | Multi-part posts for X, Threads, Bluesky, Mastodon |
| attachments | list of Attachment | Ordered |
| link | LinkPreview? | url, title, description, image |
| poll | Poll? | question, options (2 to 4), duration |
| hashtags | list of string | Parsed from text and editable |
| mentions | list of string | Parsed from text and editable |
| location | Place? | name, latitude, longitude |
| language | string? | BCP 47 code |
| contentWarning | string? | Empty means off |
| firstComment | string? | |
| reminderAt | datetime? | Local notification at that time |
| targets | list of TargetApp | App plus an optional text variant for that app |
| collectionIds | list of UUID | Private grouping |
| status | enum | draft, ready, shared, archived |
| pinned | bool | |
| notes | string? | Private, never shared |
| createdAt, updatedAt | datetime | Restore by date uses these |
| shareHistory | list of ShareEvent | app, sharedAt, optional live post URL |

### Attachment

| Field | Type |
|---|---|
| id, order | UUID, int |
| kind | image, video, audio, document |
| fileName, mimeType, sizeBytes, sha256 | Stored file metadata |
| width, height, durationMs | Where they apply |
| altText | string? |
| coverFrameMs | int? (video) |
| crop | aspect 1:1, 4:5, 9:16, 16:9, or free |

### Media info (from the native probe)

Read on import by `PostcrateMediaPlugin` (AVFoundation, ImageIO and PDFKit on iOS; MediaExtractor, MediaMetadataRetriever, ExifInterface and PdfRenderer on Android) and shown in each attachment's Details:

| Field | Example |
|---|---|
| container | QuickTime, MPEG-4, HEIC, PDF |
| videoCodec, audioCodec | hvc1 → H.265 (HEVC), mp4a → AAC |
| width, height, rotation | 3840 × 2160, 90° |
| durationMs, bitrate, frameRate | 1:03, 24 Mbps, 29.97 fps |
| sampleRate, channels | 48 kHz, Stereo |
| colorSpace, hdr | Rec. 2020, HDR |
| pageCount | PDF pages or animated image frames |

Videos and PDFs also get a preview frame (`media/thumbs/`); for videos the user picks the cover frame. Videos also show YouTube checks before sharing to the YouTube app: Shorts eligibility (vertical, under 3 minutes), the 15-minute limit for unverified accounts, and unsupported formats.

### File types

| Kind | Formats |
|---|---|
| Image | JPG, PNG, HEIC, HEIF, WebP, GIF, AVIF |
| Video | MP4, MOV, M4V, WebM |
| Audio | MP3, M4A, AAC, WAV |
| Document | PDF, DOCX, PPTX, TXT |

### Text limits shown in the editor

X 280 · Bluesky 300 · Threads 500 · Mastodon 500 · Instagram 2,200 · TikTok 2,200 · LinkedIn 3,000 · YouTube title 100. Treat these as guidance and keep them in one config file, since apps change them.

### Sharing limits

The system share sheet passes only text and files to the receiving app. Title, poll, alt text, first comment and location cannot be passed through it, so the editor gives each of these a copy button for the user to paste in the target app.
