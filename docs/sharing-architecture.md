# Sharing architecture

How Postcrate sends a post (text plus images, video, audio or documents) to social apps, and how it finds out where the post ended up.

## Goals

1. One tap shares text and media to any installed app.
2. Text is never lost, even when an app strips it.
3. No accounts, no servers. Everything runs on the device.
4. After sharing, Postcrate records where the post went and keeps a link that opens the live post in its native app.

## Layers

```
Flutter UI (editor, post card, Home)
        │
ShareService (Dart)            features/share/share_service.dart
  ├─ composes text per app (variant text, link)
  ├─ picks a strategy per platform (sheet, direct, composer)
  └─ records ShareEvents in the database
        │
NativeShare channel (Dart)     features/share/native/native_share.dart
        │  MethodChannel "com.vecvel.postcrate/share"
        ├────────────────────────────┐
iOS: PostcrateSharePlugin.swift   Android: PostcrateSharePlugin.kt
  UIPasteboard + UIActivityVC       ClipboardManager + FileProvider
  UIApplication.open (links)        ACTION_SEND(_MULTIPLE), chooser callback
                                    ACTION_VIEW (links), incoming ACTION_SEND
        │
LinkCapture (Dart)             features/share/link_capture.dart
  ├─ clipboard check when the app resumes after a share
  ├─ links shared into Postcrate (Android share target)
  └─ PostLinks parser: URL → platform + post id
```

## Channel contract

| Method | Arguments | Returns |
|---|---|---|
| `share` | `text`, `subject?`, `files: [{path, mimeType, name}]`, `target?` (platform id), `origin?` `{x, y, width, height}` | `{status: completed \| dismissed \| unavailable, target: String}` |
| `installedApps` | none | `[platform id]` |
| `openUrl` | `url`, `preferApp: bool` | `bool` opened |
| `takeIncomingText` | none | `String?` text shared into Postcrate (Android) |

Native code calls `onIncomingText(String)` on the same channel when a link is shared into the running app.

## The clipboard trick

Before any share sheet or intent opens, the post text is written to the system clipboard (iOS `UIPasteboard.general.string`, Android `ClipboardManager`). Facebook (by platform policy) and Instagram feed ignore pre-filled text. With the clipboard set, the user long-presses the empty caption field and pastes. Postcrate shows "Caption copied, paste it if the app leaves it empty" after these shares.

## Per-OS payload rules

### iOS

- Images are passed as `UIImage`. Video, audio and documents are passed as file `URL`s.
- Text is passed through a `UIActivityItemSource` that returns `nil` for activity types known to strip or mishandle text (Facebook, Instagram share extensions). Those apps always get the image, never a half-working text item, and rely on the clipboard.
- `popoverPresentationController.sourceView` and `sourceRect` are always set from the tapped button (falling back to the view center) so iPad never crashes.
- The completion handler returns the chosen `activityType` raw value (for example `com.burbn.instagram.shareextension`). Dart maps it to a platform.
- iOS cannot preselect an app inside the share sheet. A "Share to X" tap with media still opens the sheet; text-only posts open the platform's composer link instead (universal link → native app).

### Android

- Files are copied into `cacheDir/share/` with friendly names and exposed as `content://` URIs through `FileProvider` (authority `com.vecvel.postcrate.share`). Raw `file://` paths are never sent.
- One file: `ACTION_SEND` with `EXTRA_STREAM`. Several: `ACTION_SEND_MULTIPLE` with a `ArrayList<Uri>`. Text only: `ACTION_SEND` with `text/plain`.
- MIME type: `image/*` when every file is an image, `video/*` for all video, otherwise the single file's type or `*/*`.
- `EXTRA_TEXT` (and `EXTRA_SUBJECT` for titles) is always set, plus `ClipData` and `FLAG_GRANT_READ_URI_PERMISSION` so the receiver can read every URI.
- With a target platform whose package is installed, the intent gets `setPackage()` and skips the chooser. Otherwise `Intent.createChooser` is used with an `IntentSender` callback that reports the chosen component (`EXTRA_CHOSEN_COMPONENT`).
- Package visibility: `<queries>` lists each platform package and the `ACTION_SEND` intent.

## Platform matrix

| Platform | Android package | iOS scheme | Media in share | Keeps pre-filled text | Text-only composer |
|---|---|---|---|---|---|
| Facebook | com.facebook.katana | fb | yes | no (policy), clipboard | facebook.com/sharer (link only) |
| Messenger | com.facebook.orca | fb-messenger | yes | yes | share sheet |
| Instagram | com.instagram.android | instagram | yes (feed, story, DM picker) | no, clipboard | share sheet |
| Threads | com.instagram.barcelona | barcelona | yes | yes | threads.net/intent/post |
| WhatsApp | com.whatsapp | whatsapp | yes | yes (as caption) | wa.me/?text= |
| Telegram | org.telegram.messenger | tg | yes | yes | t.me/share/url |
| X | com.twitter.android | twitter | yes | yes | x.com/intent/post |
| LinkedIn | com.linkedin.android | linkedin | yes | yes | linkedin.com/feed/?shareActive=true&text= |
| Bluesky | xyz.blueskyweb.app | bluesky | yes | yes | bsky.app/intent/compose |
| Mastodon | org.joinmastodon.android | mastodon | yes | yes | share sheet |
| TikTok | com.zhiliaoapp.musically | tiktok | video, images | no, clipboard | share sheet |
| YouTube | com.google.android.youtube | youtube | video | no, clipboard | share sheet |
| Reddit | com.reddit.frontpage | reddit | yes | partly (title) | reddit.com/submit |
| Pinterest | com.pinterest | pinterest | images | partly | pinterest.com/pin/create/button |
| Snapchat | com.snapchat.android | snapchat | yes | no, clipboard | share sheet |
| Discord | com.discord | discord | yes | yes | share sheet |
| Tumblr | com.tumblr | tumblr | yes | yes | tumblr.com/widgets/share/tool |

The source of truth for this table is `SocialApp` in `lib/features/posts/domain/social_app.dart`; native code receives package names and schemes from Dart, so adding a platform is a Dart-only change plus one `<queries>` entry and one `LSApplicationQueriesSchemes` entry.

## File handling

| Kind | Formats | iOS item | Android MIME |
|---|---|---|---|
| Image | JPG, PNG, HEIC, HEIF, WebP, GIF, AVIF | `UIImage` (GIF as file URL to keep animation) | `image/*` |
| Video | MP4, MOV, M4V, WebM | file URL | `video/*` |
| Audio | MP3, M4A, AAC, WAV | file URL | `audio/*` |
| Document | PDF, DOCX, PPTX, TXT | file URL | the file's type |

Apps reject what they can't post (for example Instagram with a PDF); the share sheet hides incompatible targets on both systems.

## Where did it get shared? (post links)

Social platforms don't tell other apps the URL of a post that was just published, and reading it through their APIs needs per-platform OAuth, paid tiers or app review (X API, Meta Graph API, LinkedIn Marketing API). Postcrate keeps its no-account design and captures the link on the device instead:

1. **Share event.** When the share completes, a `ShareEvent` is stored with the platform and time and no link yet ("waiting for link").
2. **Clipboard capture.** Every social app has "Copy link". When Postcrate returns to the foreground and has a share waiting for a link from the last 24 hours, it checks the clipboard. A URL that `PostLinks` recognizes as a post on a known platform is offered in a sheet: "Add this link to your post?" iOS shows its paste permission prompt the first time.
3. **Share into Postcrate (Android).** Postcrate is a share target for `text/plain`. Choosing Share → Postcrate on a published post sends the link straight to the same sheet.
4. **Manual.** Any share history row accepts a pasted link.
5. **Open.** Saved links open in the native app (`UIApplication.open` with universal links, Android `ACTION_VIEW` with app links), falling back to the browser.

`PostLinks` recognizes post URLs for X/Twitter, Instagram, Facebook (`fb.watch` too), Threads, LinkedIn, Bluesky, TikTok (`vm.tiktok.com` too), YouTube (`youtu.be`, Shorts), Reddit (`redd.it`), Pinterest (`pin.it`), Telegram, Tumblr and any Mastodon-style `https://host/@user/123` link.

### Next steps

- iOS share extension target so iOS users can also Share → Postcrate from a social app (needs an App Group to hand the link to the main app).
- Optional per-platform API connectors (user's own tokens, stored in the Keychain) to fetch links and engagement automatically where the platform allows it.
