import 'dart:io';

import 'package:flutter/services.dart';

import '../../features/posts/domain/media_info.dart';

/// Dart side of PostcrateMediaPlugin (ios/Runner/Share, android .../media).
/// Returns null or false where the native side isn't available (tests).
class MediaProbe {
  const MediaProbe({MethodChannel? channel}) : _channel = channel ?? const MethodChannel('com.vecvel.postcrate/media');

  final MethodChannel _channel;

  Future<MediaInfo?> probe(File file) async {
    try {
      final raw = await _channel.invokeMapMethod<String, Object?>('probe', {'path': file.path});
      if (raw == null || raw.isEmpty) return null;
      final info = MediaInfo.fromJson(raw);
      return info.isEmpty ? null : info;
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }

  /// Writes a JPEG preview of a video frame at [atMs] or a PDF's first page.
  Future<bool> thumbnail(File file, File out, {int atMs = 0, int maxSize = 640}) async {
    try {
      return await _channel.invokeMethod<bool>('thumbnail', {
            'path': file.path,
            'outPath': out.path,
            'atMs': atMs,
            'maxSize': maxSize,
          }) ??
          false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }
}
