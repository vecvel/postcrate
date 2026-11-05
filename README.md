# Postcrate

Keep all your posts in one place and share them to any app on your phone.

## Run

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Test

```bash
flutter analyze
flutter test
```

## App icons

```bash
bash design/logo/export_icons.sh
```

Needs `node`, `rsvg-convert` and `magick`.
