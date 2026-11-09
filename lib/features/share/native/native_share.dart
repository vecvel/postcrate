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

  /// Called when something new is shared into Postcrate while it runs
  /// (Android). iOS items are picked up when the app comes to the front.
  set onIncoming(void Function()? handler) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onIncoming') handler?.call();
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

  /// Items shared into Postcrate that haven't been saved or discarded yet,
  /// oldest first.
  Future<List<IncomingItem>> incomingItems() async {
    final raw = await _channel.invokeListMethod<Object?>('incomingItems') ?? const [];
    return [for (final m in raw.whereType<Map<Object?, Object?>>()) IncomingItem.fromMap(m)];
  }

  /// Deletes a shared item and its copied files.
  Future<void> removeIncoming(String id) => _channel.invokeMethod<void>('removeIncoming', {'id': id});
}

/// Text and files shared into Postcrate from another app.
class IncomingItem {
  const IncomingItem({required this.id, this.text, this.files = const []});

  factory IncomingItem.fromMap(Map<Object?, Object?> m) => IncomingItem(
    id: m['id']! as String,
    text: m['text'] as String?,
    files: [
      for (final f in (m['files'] as List?)?.whereType<Map<Object?, Object?>>() ?? const <Map<Object?, Object?>>[])
        NativeShareFile(
          path: f['path']! as String,
          name: f['name'] as String? ?? '',
          mimeType: f['mimeType'] as String? ?? 'application/octet-stream',
        ),
    ],
  );

  final String id;
  final String? text;
  final List<NativeShareFile> files;
}
