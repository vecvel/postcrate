import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class FetchedPreview {
  const FetchedPreview({this.title, this.description, this.imageUrl, required this.url});

  final String url;
  final String? title;
  final String? description;
  final String? imageUrl;
}

/// Reads a page's Open Graph / Twitter card / HTML title and description.
/// Only the first 512 KB are read; nothing is sent besides the request itself.
class LinkPreviewFetcher {
  LinkPreviewFetcher({http.Client Function()? client}) : _newClient = client ?? http.Client.new;

  final http.Client Function() _newClient;
  static const _maxBytes = 512 * 1024;

  Future<FetchedPreview?> fetch(String rawUrl) async {
    final url = Uri.tryParse(rawUrl.trim().startsWith('http') ? rawUrl.trim() : 'https://${rawUrl.trim()}');
    if (url == null || url.host.isEmpty) return null;
    final client = _newClient();
    try {
      final req = http.Request('GET', url)
        ..headers.addAll({'User-Agent': 'Mozilla/5.0 (compatible; Postcrate link preview)', 'Accept': 'text/html'});
      final res = await client.send(req).timeout(const Duration(seconds: 8));
      if (res.statusCode >= 400) return null;
      final type = res.headers['content-type'] ?? '';
      if (!type.contains('html')) return FetchedPreview(url: url.toString());
      final bytes = <int>[];
      await for (final chunk in res.stream.timeout(const Duration(seconds: 8))) {
        bytes.addAll(chunk);
        if (bytes.length >= _maxBytes) break;
      }
      return parse(utf8.decode(bytes, allowMalformed: true), url);
    } on TimeoutException {
      return null;
    } catch (_) {
      return null;
    } finally {
      client.close();
    }
  }

  static FetchedPreview parse(String html, Uri url) {
    String? meta(String key) {
      final patterns = [
        RegExp('<meta[^>]+(?:property|name)=["\']$key["\'][^>]*content=["\']([^"\']*)["\']', caseSensitive: false),
        RegExp('<meta[^>]+content=["\']([^"\']*)["\'][^>]*(?:property|name)=["\']$key["\']', caseSensitive: false),
      ];
      for (final p in patterns) {
        final m = p.firstMatch(html);
        if (m != null && m.group(1)!.trim().isNotEmpty) return _decode(m.group(1)!.trim());
      }
      return null;
    }

    final titleTag = RegExp(r'<title[^>]*>([^<]*)</title>', caseSensitive: false).firstMatch(html)?.group(1)?.trim();
    final image = meta('og:image') ?? meta('twitter:image');
    return FetchedPreview(
      url: url.toString(),
      title:
          meta('og:title') ??
          meta('twitter:title') ??
          (titleTag == null || titleTag.isEmpty ? null : _decode(titleTag)),
      description: meta('og:description') ?? meta('twitter:description') ?? meta('description'),
      imageUrl: image == null ? null : url.resolve(image).toString(),
    );
  }

  static String _decode(String s) => s
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&#x27;', "'")
      .replaceAll('&apos;', "'")
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&nbsp;', ' ')
      .replaceAll(RegExp(r'\s+'), ' ');
}
