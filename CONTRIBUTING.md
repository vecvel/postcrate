# Contributing

Thanks for helping with Postcrate.

## Setup

You need Flutter 3.44 (stable) and, for iOS, Xcode 26.

```bash
git clone https://github.com/vecvel/postcrate.git
cd postcrate
flutter pub get
flutter run
```

If you change the database tables in `lib/core/database/app_database.dart`, regenerate the drift code:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Before you open a pull request

```bash
dart format -l 120 lib test
flutter analyze
flutter test
```

All three must pass. CI runs the same checks.

## Pull requests

- Branch from `main` and keep each pull request to one change.
- Write commit messages in the imperative: `Fix crash when sharing a PDF`.
- Add or update tests for behavior changes.
- For UI changes, include a screenshot or short screen recording.
- Native code lives in `ios/Runner/Share/` (Swift) and `android/app/src/main/kotlin/com/vecvel/postcrate/` (Kotlin). Test those changes on a device or simulator for that platform.

## Reporting bugs and ideas

Use the issue templates. For security problems, follow [SECURITY.md](SECURITY.md) instead of opening a public issue.

## Releasing

Bump `version:` in `pubspec.yaml` (for example `1.0.1+2`) and merge to `main`. The Android release workflow tags the commit, builds a signed APK and AAB, and publishes the GitHub release. Pushes that keep the same version do not release.
