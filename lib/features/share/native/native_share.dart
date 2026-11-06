import 'dart:io';

import 'package:flutter/services.dart';

import '../../posts/domain/social_app.dart';

enum NativeShareStatus { completed, dismissed, unavailable }

class NativeShareResult {
  const NativeShareResult(this.status, this.target);

  final NativeShareStatus status;

  /// iOS activity type, or Android package / flattened component name.
  final String target;
}

class NativeShareFile {
  const NativeShareFile({required this.path, required this.mimeType, required this.name});

  final String path;
  final String mimeType;
  final String name;

  Map<String, String> toMap() => {'path': path, 'mimeType': mimeType, 'name': name};
}

/// Dart side of PostcrateSharePlugin (ios/Runner/Share, android .../share).
class NativeShare {
  NativeShare({MethodChannel? channel}) : _channel = channel ?? const MethodChannel('com.vecvel.postcrate/share');

  final MethodChannel _channel;
  void Function(String text)? _onIncomingText;

  /// Receives text shared into Postcrate while it is running (Android).
  set onIncomingText(void Function(String text)? handler) {
    _onIncomingText = handler;
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onIncomingText' && call.arguments is String) _onIncomingText?.call(call.arguments as String);
    });
  }

  /// Copies [text] to the clipboard, then opens the share sheet (or the
  /// target app directly on Android when [target] is installed).
  Future<NativeShareResult> share({
    required String text,
    String? subject,
    List<NativeShareFile> files = const [],
    SocialApp? target,
    Rect? origin,
  }) async {
    final raw = await _channel.invokeMapMethod<String, Object?>('share', {
      'text': text,
      'subject': subject,
      'files': [for (final f in files) f.toMap()],
      'targetPackages': target?.android ?? const <String>[],
      if (origin != null) 'origin': {'x': origin.left, 'y': origin.top, 'width': origin.width, 'height': origin.height},
    });
    final status = switch (raw?['status']) {
      'completed' => NativeShareStatus.completed,
      'dismissed' => NativeShareStatus.dismissed,
      _ => NativeShareStatus.unavailable,
    };
    return NativeShareResult(status, raw?['target'] as String? ?? '');
  }

  /// Platforms installed on this device.
  Future<Set<SocialApp>> installedApps() async {
    final args = Platform.isIOS
        ? {
            'schemes': {
              for (final a in SocialApp.platforms)
                if (a.iosScheme != null) a.name: a.iosScheme,
            },
          }
        : {
            'packages': {for (final a in SocialApp.platforms) a.name: a.android},
          };
    final ids = await _channel.invokeListMethod<String>('installedApps', args) ?? const [];
    return ids.map(SocialApp.fromName).toSet();
  }

  /// Opens [url], preferring the native app that claims it.
  Future<bool> openUrl(Uri url, {bool preferApp = true}) async =>
      await _channel.invokeMethod<bool>('openUrl', {'url': url.toString(), 'preferApp': preferApp}) ?? false;

  /// Text that launched the app through the share sheet (Android), once.
  Future<String?> takeIncomingText() => _channel.invokeMethod<String>('takeIncomingText');
}
