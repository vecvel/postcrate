import 'package:flutter_test/flutter_test.dart';
import 'package:postcrate/features/share/incoming_share.dart';
import 'package:postcrate/features/share/native/native_share.dart';

NativeShareFile _file(String mime) => NativeShareFile(path: '/tmp/x', mimeType: mime, name: 'x');

void main() {
  group('describeIncoming', () {
    test('counts files by kind and names the text', () {
      final item = IncomingItem(
        id: '1',
        text: 'https://example.com/a',
        files: [_file('image/jpeg'), _file('image/heic'), _file('video/quicktime')],
      );
      expect(describeIncoming(item), '2 photos, 1 video and a link');
    });

    test('plain text', () {
      expect(describeIncoming(const IncomingItem(id: '1', text: 'Launch day notes')), 'Some text');
    });

    test('reads items from the platform map', () {
      final item = IncomingItem.fromMap({
        'id': 'abc',
        'text': null,
        'files': [
          {'path': '/p/1-a.pdf', 'name': 'a.pdf', 'mimeType': 'application/pdf'},
        ],
      });
      expect(item.files.single.name, 'a.pdf');
      expect(describeIncoming(item), '1 document');
    });
  });
}
