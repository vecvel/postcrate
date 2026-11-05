<div align="center">

<picture>
  <source media="(prefers-color-scheme: dark)" srcset=".github/media/logo-dark.png">
  <img src=".github/media/logo-light.png" alt="Postcrate logo" width="112">
</picture>

# Postcrate

All your posts in one place. Share them to any app.

[![CI](https://github.com/vecvel/postcrate/actions/workflows/ci.yml/badge.svg)](https://github.com/vecvel/postcrate/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
![Platforms](https://img.shields.io/badge/platforms-Android%20%7C%20iOS-lightgrey.svg)

</div>

Postcrate is a mobile app for people who post the same thing to several social networks. Write a post once, keep it with its photos, videos and files, and send it to Instagram, X, LinkedIn, WhatsApp, YouTube or any other installed app through the system share sheet. It keeps track of where each post went and lets you open the live post later.

There are no accounts and no servers. Everything stays on your phone, and backups are files you save wherever you like.

## Contents

- [Features](#features)
- [Getting started](#getting-started)
- [Project structure](#project-structure)
- [Contributing](#contributing)
- [Security](#security)
- [License](#license)
- [Contact](#contact)

<!--
## Demo

<p align="center"><img src=".github/media/demo.gif" alt="Postcrate demo" width="320"></p>
-->

## Features

- **Every post field in one editor.** Title, text, thread parts, photos, videos, audio and documents, link preview, poll, hashtags and mentions, location, language, content warning, first comment, per-app text with character limits, collections, status, pinning and private notes.
- **Share to any app.** Uses the native share sheet on iOS and Android. The caption is copied to the clipboard first, because Facebook and Instagram drop pre-filled text. Text-only posts can open X, Threads, Bluesky, LinkedIn, WhatsApp, Telegram, Reddit and Tumblr composers directly.
- **Where it went.** Each share is recorded. Copy the post link in the other app (or share it into Postcrate on Android) and Postcrate attaches it, so you can open the live post from your library.
- **Media details.** Codec, resolution, duration, frame rate, bitrate, audio format, color and page count for every attachment, with video and PDF previews and a cover frame picker. Videos show YouTube checks such as Shorts eligibility.
- **Reminders.** Set a time to post and get a notification.
- **Backup to a file.** Pack all posts and media into one zip, save it to Files, Google Drive, iCloud Drive or a computer, and restore everything or only selected days.
- **Light and dark themes** that follow the system.

## Getting started

Requirements: Flutter 3.44 (stable). For iOS, Xcode 26; the app runs on iOS 15 or later. Android builds run on Android 7.0 (API 24) or later.

```bash
git clone https://github.com/vecvel/postcrate.git
cd postcrate
flutter pub get
flutter run
```

Run the checks:

```bash
flutter analyze
flutter test
```

Build release apps:

```bash
flutter build apk --release
flutter build ios --release
```

After changing database tables, regenerate the drift code with `dart run build_runner build --delete-conflicting-outputs`.

App icons are generated from `design/logo/generate.mjs`. To rebuild them, run `bash design/logo/export_icons.sh` (needs `node`, `rsvg-convert` and ImageMagick).

## Project structure

```
lib/
  app/          app widget, router, bottom bar shell
  core/         theme, shared widgets, database, media storage, notifications
  features/
    home/       summary, setup checklist, reminders, recent posts
    posts/      post model, repository, library and editor
    share/      native share bridge, post link capture
    backup/     backup file export and restore
    youtube/    video checks for YouTube
ios/Runner/Share/                        native share and media code (Swift)
android/app/src/main/kotlin/.../share/   native share code (Kotlin)
android/app/src/main/kotlin/.../media/   native media code (Kotlin)
```

## Contributing

Bug reports, ideas and pull requests are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) and follow the [code of conduct](CODE_OF_CONDUCT.md).

## Security

Please report vulnerabilities privately. See [SECURITY.md](SECURITY.md).

## License

[MIT](LICENSE) © 2026 Vecvel

## Contact

Vecvel · [github.com/vecvel](https://github.com/vecvel) · support@vecvel.com
