# Native sharing: code and platform setup

Design and platform rules are in [sharing-architecture.md](sharing-architecture.md). This page lists the files and every manifest or plist change the module needs. All of it is already applied in this repo.

## Files

| Layer | File |
|---|---|
| iOS core | `ios/Runner/Share/PostcrateShare.swift` (clipboard, `UIActivityViewController`, text item filtering, iPad popover) |
| iOS bridge | `ios/Runner/Share/PostcrateSharePlugin.swift` (MethodChannel `com.vecvel.postcrate/share`) |
| iOS registration | `ios/Runner/AppDelegate.swift`, `didInitializeImplicitFlutterEngine` |
| Android core and bridge | `android/app/src/main/kotlin/com/vecvel/postcrate/share/PostcrateSharePlugin.kt` |
| Android registration | `android/app/src/main/kotlin/com/vecvel/postcrate/MainActivity.kt` |
| Android FileProvider paths | `android/app/src/main/res/xml/share_paths.xml` |
| Dart bridge | `lib/features/share/native/native_share.dart` |
| Dart service | `lib/features/share/share_service.dart` |
| Link capture | `lib/features/share/link_capture.dart`, `lib/features/share/post_links.dart` |
| Platform registry | `lib/features/posts/domain/social_app.dart` |

## iOS

### Info.plist

```xml
<!-- canOpenURL checks for installed apps (max 50 entries) -->
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>fb</string> <string>fb-messenger</string> <string>instagram</string>
  <string>barcelona</string> <string>whatsapp</string> <string>tg</string>
  <string>twitter</string> <string>linkedin</string> <string>bluesky</string>
  <string>mastodon</string> <string>tiktok</string> <string>snssdk1233</string>
  <string>youtube</string> <string>reddit</string> <string>pinterest</string>
  <string>snapchat</string> <string>discord</string> <string>tumblr</string>
</array>

<!-- Picking and capturing media for posts -->
<key>NSPhotoLibraryUsageDescription</key>
<string>Postcrate adds the photos and videos you pick to your posts.</string>
<key>NSCameraUsageDescription</key>
<string>Postcrate uses the camera when you take a photo for a post.</string>
<key>NSMicrophoneUsageDescription</key>
<string>Postcrate records sound when you capture a video for a post.</string>
```

No permission is needed to write to `UIPasteboard` or present `UIActivityViewController`. Saving to Photos isn't used, so `NSPhotoLibraryAddUsageDescription` isn't required. Reading the clipboard for post links shows the system "Allow Paste" prompt; no plist key controls it.

### Registration

```swift
func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
  GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "PostcrateSharePlugin") {
    PostcrateSharePlugin.register(with: registrar)
  }
}
```

The two Swift files are members of the Runner target (added to `project.pbxproj`).

## Android

### AndroidManifest.xml

```xml
<!-- Inside <application> -->
<provider
    android:name="androidx.core.content.FileProvider"
    android:authorities="${applicationId}.share"
    android:exported="false"
    android:grantUriPermissions="true">
    <meta-data
        android:name="android.support.FILE_PROVIDER_PATHS"
        android:resource="@xml/share_paths" />
</provider>

<!-- Inside the MainActivity <activity>: receive post links via Share > Postcrate -->
<intent-filter>
    <action android:name="android.intent.action.SEND" />
    <category android:name="android.intent.category.DEFAULT" />
    <data android:mimeType="text/plain" />
</intent-filter>

<!-- Inside <queries>: package visibility (Android 11+) -->
<package android:name="com.facebook.katana" />
<package android:name="com.instagram.android" />
<package android:name="com.whatsapp" />
<!-- ...one per package in SocialApp.android -->
<intent>
    <action android:name="android.intent.action.SEND" />
    <data android:mimeType="*/*" />
</intent>
<intent>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="https" />
</intent>
```

### res/xml/share_paths.xml

```xml
<paths>
    <cache-path name="share" path="share/" />
</paths>
```

### Gradle

```kotlin
dependencies {
    implementation("androidx.core:core-ktx:1.16.0") // FileProvider, ContextCompat
}
```

No runtime permission is needed for sharing, the clipboard, or `FileProvider`. Files are copied into `cacheDir/share` before each share because Flutter's documents directory (`app_flutter`) isn't a `FileProvider`-supported root.

### Registration

```kotlin
class MainActivity : FlutterActivity() {
  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    flutterEngine.plugins.add(PostcrateSharePlugin())
  }
}
```

## Dart usage

```dart
final native = NativeShare();

// Image + caption to the share sheet. The caption is copied to the clipboard first.
final result = await native.share(
  text: 'Shipped the new onboarding flow #design',
  files: [NativeShareFile(path: imagePath, mimeType: 'image/jpeg', name: 'launch.jpg')],
  origin: buttonRect, // anchors the iPad popover
);

// Straight to one app on Android (skips the chooser when installed).
await native.share(text: caption, files: files, target: SocialApp.whatsapp);

// Open a saved post in its native app.
await native.openUrl(Uri.parse('https://www.instagram.com/p/C9abcDEF12/'));
```

In the app, call `ShareService.share(context, post, app: ...)`. It picks composer links for text-only posts, records the share and returns whether the caption needs pasting.

## Adding a platform

1. Add a value to `SocialApp` with its label, limits, Android packages, iOS scheme and `keepsText`.
2. Add a `composer` case if it has a text composer URL, and a pattern in `PostLinks` for its post URLs.
3. Add its package to `<queries>` and its scheme to `LSApplicationQueriesSchemes`.
