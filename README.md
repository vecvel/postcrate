# Postcrate

All your posts in one place, shared to any app on your phone. No accounts, no servers, no API keys. Backups are files you save wherever you like.

Bundle ID `com.vecvel.postcrate` · Flutter 3.44 · iOS and Android

## Run

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

Postcrate needs no account, keys or configuration.

## Test

```bash
flutter analyze
flutter test
```

## Structure

```
lib/
  app/                 app widget, router, shell (bottom bar, link capture host)
  core/
    theme/             tokens (from design/tokens.json) and ThemeData
    widgets/           borderless components: card, group, field, button, switch, chip, bar
    database/          drift schema
    storage/           attachment files and preview frames
    media/             native media probe bridge (codecs, bitrate, frames)
    notifications/     post reminders
  features/
    home/              summary counts, setup checklist, reminders, recent
    posts/             domain model, repository, library, editor
    share/             native share bridge, share service, post link capture
    youtube/           YouTube format checks shown before sharing to the YouTube app
    backup/            backup file (zip) export and restore by date
ios/Runner/Share/      native iOS share and media modules (Swift)
android/.../share/     native Android share module (Kotlin)
android/.../media/     native Android media module (Kotlin)
design/                tokens, logo source and generated assets, visual reference
docs/                  sharing architecture, native setup, backup format
```

## Design

[DESIGN.md](DESIGN.md) records the approved palette, surfaces, corners, logo and post model. Logo and app icons come from one source: `bash design/logo/export_icons.sh`.
