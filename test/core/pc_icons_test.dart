import 'package:flutter_test/flutter_test.dart';
import 'package:postcrate/core/widgets/pc_icons.dart';

void main() {
  const all = {
    'plus': PcIcons.plus,
    'check': PcIcons.check,
    'chevronRight': PcIcons.chevronRight,
    'chevronLeft': PcIcons.chevronLeft,
    'arrowRight': PcIcons.arrowRight,
    'arrowLeft': PcIcons.arrowLeft,
    'arrowUpRight': PcIcons.arrowUpRight,
    'circle': PcIcons.circle,
    'checkCircle': PcIcons.checkCircle,
    'minusCircle': PcIcons.minusCircle,
    'info': PcIcons.info,
    'alert': PcIcons.alert,
    'home': PcIcons.home,
    'library': PcIcons.library,
    'backup': PcIcons.backup,
    'folder': PcIcons.folder,
    'trash': PcIcons.trash,
    'pencil': PcIcons.pencil,
    'compose': PcIcons.compose,
    'share': PcIcons.share,
    'send': PcIcons.send,
    'search': PcIcons.search,
    'pin': PcIcons.pin,
    'link': PcIcons.link,
    'bell': PcIcons.bell,
    'downloadDoc': PcIcons.downloadDoc,
    'archive': PcIcons.archive,
    'photos': PcIcons.photos,
    'photo': PcIcons.photo,
    'audio': PcIcons.audio,
    'location': PcIcons.location,
    'globe': PcIcons.globe,
    'video': PcIcons.video,
    'doc': PcIcons.doc,
    'copy': PcIcons.copy,
    'clipboard': PcIcons.clipboard,
    'camera': PcIcons.camera,
  };

  test('every icon parses and stays inside the 24px grid', () {
    for (final e in all.entries) {
      for (final d in [...e.value.strokes, ...e.value.fills]) {
        final b = SvgPath.parse(d).getBounds();
        expect(b.isEmpty && b.width == 0 && b.height == 0, isFalse, reason: e.key);
        expect(b.left >= 1 && b.top >= 1 && b.right <= 23 && b.bottom <= 23, isTrue, reason: '${e.key} $b');
      }
    }
  });

  test('relative arcs with packed flags', () {
    final b = SvgPath.parse('M4 7.5A1.5 1.5 0 015.5 6h4').getBounds();
    expect(b.left, closeTo(4, 0.01));
    expect(b.right, closeTo(9.5, 0.01));
  });

  test('circle helper path is a full circle', () {
    final b = SvgPath.parse(PcIcons.circle.strokes.single).getBounds();
    expect(b.width, closeTo(17, 0.05));
    expect(b.height, closeTo(17, 0.05));
  });
}
