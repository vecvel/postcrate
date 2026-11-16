import 'package:flutter/widgets.dart';

/// Postcrate's own icon set: outline icons on a 24x24 grid with a 1.6 rounded
/// stroke, stored as SVG path data and drawn by [PcIcon]. The source drawings
/// are in design/icons-and-bar-preview.html.
@immutable
class PcIconData {
  const PcIconData(this.strokes, {this.fills = const []});

  /// Outlined shapes, in SVG path syntax.
  final List<String> strokes;

  /// Small solid shapes such as the dot in [PcIcons.info].
  final List<String> fills;
}

abstract final class PcIcons {
  static const plus = PcIconData(['M12 5v14M5 12h14']);
  static const check = PcIconData(['M5 12.5l4.2 4.2L19 7']);
  static const chevronRight = PcIconData(['M10 6l6 6-6 6']);
  static const chevronLeft = PcIconData(['M14 6l-6 6 6 6']);
  static const arrowRight = PcIconData(['M5 12h14M13 6l6 6-6 6']);
  static const arrowLeft = PcIconData(['M19 12H5M11 6l-6 6 6 6']);
  static const arrowUpRight = PcIconData(['M7 17L17 7M9 7h8v8']);
  static const circle = PcIconData(['M3.5 12a8.5 8.5 0 1 0 17 0a8.5 8.5 0 1 0 -17 0z']);
  static const checkCircle = PcIconData(['M3.5 12a8.5 8.5 0 1 0 17 0a8.5 8.5 0 1 0 -17 0z', 'M8.3 12.3l2.5 2.5 5-5']);
  static const minusCircle = PcIconData(['M3.5 12a8.5 8.5 0 1 0 17 0a8.5 8.5 0 1 0 -17 0z', 'M8.5 12h7']);
  static const info = PcIconData(
    ['M3.5 12a8.5 8.5 0 1 0 17 0a8.5 8.5 0 1 0 -17 0z', 'M12 11v5'],
    fills: ['M11.4 8a0.6 0.6 0 1 0 1.2 0a0.6 0.6 0 1 0 -1.2 0z'],
  );
  static const alert = PcIconData(
    ['M3.5 12a8.5 8.5 0 1 0 17 0a8.5 8.5 0 1 0 -17 0z', 'M12 7.5v5'],
    fills: ['M11.4 15.8a0.6 0.6 0 1 0 1.2 0a0.6 0.6 0 1 0 -1.2 0z'],
  );
  static const home = PcIconData([
    'M4.5 10.5L12 4.5l7.5 6V18a1.5 1.5 0 01-1.5 1.5h-3.5V14h-5v5.5H6A1.5 1.5 0 014.5 18z',
  ]);
  static const library = PcIconData([
    'M6.1 4.5h2.8a1.6 1.6 0 0 1 1.6 1.6v2.8a1.6 1.6 0 0 1 -1.6 1.6h-2.8a1.6 1.6 0 0 1 -1.6 -1.6v-2.8a1.6 1.6 0 0 1 1.6 -1.6z',
    'M15.1 4.5h2.8a1.6 1.6 0 0 1 1.6 1.6v2.8a1.6 1.6 0 0 1 -1.6 1.6h-2.8a1.6 1.6 0 0 1 -1.6 -1.6v-2.8a1.6 1.6 0 0 1 1.6 -1.6z',
    'M6.1 13.5h2.8a1.6 1.6 0 0 1 1.6 1.6v2.8a1.6 1.6 0 0 1 -1.6 1.6h-2.8a1.6 1.6 0 0 1 -1.6 -1.6v-2.8a1.6 1.6 0 0 1 1.6 -1.6z',
    'M15.1 13.5h2.8a1.6 1.6 0 0 1 1.6 1.6v2.8a1.6 1.6 0 0 1 -1.6 1.6h-2.8a1.6 1.6 0 0 1 -1.6 -1.6v-2.8a1.6 1.6 0 0 1 1.6 -1.6z',
  ]);
  static const backup = PcIconData([
    'M7.5 18.5h9a4 4 0 00.6-7.95A5.5 5.5 0 006.4 9.6 4.5 4.5 0 007.5 18.5z',
    'M12 16v-5.5M9.5 13l2.5-2.5 2.5 2.5',
  ]);
  static const folder = PcIconData([
    'M4 7.5A1.5 1.5 0 015.5 6h4l2 2h7A1.5 1.5 0 0120 9.5v8a1.5 1.5 0 01-1.5 1.5h-13A1.5 1.5 0 014 17.5z',
  ]);
  static const trash = PcIconData([
    'M5 7h14M10 7V5.5h4V7M6.5 7l.8 11.1A1.5 1.5 0 008.8 19.5h6.4a1.5 1.5 0 001.5-1.4L17.5 7M10.5 10.5v5.5M13.5 10.5v5.5',
  ]);
  static const pencil = PcIconData(['M15.5 5.5l3 3L9 18l-4 1 1-4z', 'M13.5 7.5l3 3']);
  static const compose = PcIconData([
    'M11 5H6.5A1.5 1.5 0 005 6.5v11A1.5 1.5 0 006.5 19h11a1.5 1.5 0 001.5-1.5V13',
    'M17 4.5l2.5 2.5-7 7-3.2.7.7-3.2z',
  ]);
  static const share = PcIconData([
    'M12 4.5v10M8.5 8L12 4.5 15.5 8',
    'M8 11H6.5A1.5 1.5 0 005 12.5v5A1.5 1.5 0 006.5 19h11a1.5 1.5 0 001.5-1.5v-5a1.5 1.5 0 00-1.5-1.5H16',
  ]);
  static const send = PcIconData(['M19.5 4.5L10 14M19.5 4.5l-5.5 15-4-5.5-5.5-4z']);
  static const search = PcIconData(['M5 11a6 6 0 1 0 12 0a6 6 0 1 0 -12 0z', 'M15.5 15.5l4 4']);
  static const pin = PcIconData(['M9 4.5h6M10 4.5v5l-3 3.5h10l-3-3.5v-5M12 13v6.5']);
  static const link = PcIconData([
    'M10 14a3.5 3.5 0 005 0l3-3a3.5 3.5 0 00-5-5l-1 1',
    'M14 10a3.5 3.5 0 00-5 0l-3 3a3.5 3.5 0 005 5l1-1',
  ]);
  static const bell = PcIconData(['M6.5 16.5V11a5.5 5.5 0 0111 0v5.5l1.5 1.5H5z', 'M10 19.5a2 2 0 004 0']);
  static const downloadDoc = PcIconData([
    'M13.5 4.5H7A1.5 1.5 0 005.5 6v12A1.5 1.5 0 007 19.5h10a1.5 1.5 0 001.5-1.5V9.5z',
    'M13.5 4.5v5h5M12 11.5v5M9.5 14l2.5 2.5 2.5-2.5',
  ]);
  static const archive = PcIconData([
    'M5.2 5h13.6a1.2 1.2 0 0 1 1.2 1.2v1.6a1.2 1.2 0 0 1 -1.2 1.2h-13.6a1.2 1.2 0 0 1 -1.2 -1.2v-1.6a1.2 1.2 0 0 1 1.2 -1.2z',
    'M5.5 9v8.5A1.5 1.5 0 007 19h10a1.5 1.5 0 001.5-1.5V9M10 12.5h4',
  ]);
  static const photos = PcIconData([
    'M9.1 7.5h8.8a1.6 1.6 0 0 1 1.6 1.6v7.8a1.6 1.6 0 0 1 -1.6 1.6h-8.8a1.6 1.6 0 0 1 -1.6 -1.6v-7.8a1.6 1.6 0 0 1 1.6 -1.6z',
    'M4.5 15V6A1.5 1.5 0 016 4.5h10M7.5 16l3.2-3.2 2.3 2.2 2-2 4.5 4',
  ]);
  static const photo = PcIconData([
    'M6.1 5.5h11.8a1.6 1.6 0 0 1 1.6 1.6v9.8a1.6 1.6 0 0 1 -1.6 1.6h-11.8a1.6 1.6 0 0 1 -1.6 -1.6v-9.8a1.6 1.6 0 0 1 1.6 -1.6z',
    'M7.6 10a1.4 1.4 0 1 0 2.8 0a1.4 1.4 0 1 0 -2.8 0z',
    'M4.5 16l4.5-4 3 2.5 3-3 4.5 4',
  ]);
  static const audio = PcIconData([
    'M9.5 17V6.5l9-2V15',
    'M5.5 17a2 2 0 1 0 4 0a2 2 0 1 0 -4 0z',
    'M14.5 15a2 2 0 1 0 4 0a2 2 0 1 0 -4 0z',
  ]);
  static const location = PcIconData([
    'M12 20s6-5.4 6-10.5A6 6 0 006 9.5C6 14.6 12 20 12 20z',
    'M9.8 9.5a2.2 2.2 0 1 0 4.4 0a2.2 2.2 0 1 0 -4.4 0z',
  ]);
  static const globe = PcIconData([
    'M3.5 12a8.5 8.5 0 1 0 17 0a8.5 8.5 0 1 0 -17 0z',
    'M3.5 12h17M12 3.5c2.4 2.4 3.5 5.3 3.5 8.5s-1.1 6.1-3.5 8.5c-2.4-2.4-3.5-5.3-3.5-8.5s1.1-6.1 3.5-8.5z',
  ]);
  static const video = PcIconData([
    'M6.1 6h11.8a1.6 1.6 0 0 1 1.6 1.6v8.8a1.6 1.6 0 0 1 -1.6 1.6h-11.8a1.6 1.6 0 0 1 -1.6 -1.6v-8.8a1.6 1.6 0 0 1 1.6 -1.6z',
    'M10.5 9.8v4.4l3.8-2.2z',
  ]);
  static const doc = PcIconData([
    'M13.5 4.5H7A1.5 1.5 0 005.5 6v12A1.5 1.5 0 007 19.5h10a1.5 1.5 0 001.5-1.5V9.5z',
    'M13.5 4.5v5h5M9 13h6M9 16h4',
  ]);
  static const copy = PcIconData([
    'M10.1 8.5h7.8a1.6 1.6 0 0 1 1.6 1.6v7.8a1.6 1.6 0 0 1 -1.6 1.6h-7.8a1.6 1.6 0 0 1 -1.6 -1.6v-7.8a1.6 1.6 0 0 1 1.6 -1.6z',
    'M15.5 5.5A1.5 1.5 0 0014 4.5H6A1.5 1.5 0 004.5 6v8a1.5 1.5 0 001 1.4',
  ]);
  static const clipboard = PcIconData([
    'M7.1 5.5h9.8a1.6 1.6 0 0 1 1.6 1.6v10.8a1.6 1.6 0 0 1 -1.6 1.6h-9.8a1.6 1.6 0 0 1 -1.6 -1.6v-10.8a1.6 1.6 0 0 1 1.6 -1.6z',
    'M10 3.8h4a1 1 0 0 1 1 1v1.2a1 1 0 0 1 -1 1h-4a1 1 0 0 1 -1 -1v-1.2a1 1 0 0 1 1 -1z',
    'M9 12h6M9 15h4',
  ]);
  static const camera = PcIconData([
    'M4.5 9A1.5 1.5 0 016 7.5h2.2L9.7 5.5h4.6l1.5 2H18A1.5 1.5 0 0119.5 9v8.5A1.5 1.5 0 0118 19H6a1.5 1.5 0 01-1.5-1.5z',
    'M9 13a3 3 0 1 0 6 0a3 3 0 1 0 -6 0z',
  ]);
}

/// Draws a [PcIconData]. Size and color fall back to the ambient [IconTheme],
/// so it drops in wherever an [Icon] was used.
class PcIcon extends StatelessWidget {
  const PcIcon(this.icon, {super.key, this.size, this.color, this.semanticLabel});

  final PcIconData icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = IconTheme.of(context);
    final s = size ?? theme.size ?? 24;
    // Like Icon: keep the drawing square and centred even when the parent
    // forces a larger box (input decorations, list tiles).
    final painted = SizedBox.square(
      dimension: s,
      child: Center(
        child: SizedBox.square(
          dimension: s,
          child: CustomPaint(painter: _IconPainter(icon, color ?? theme.color ?? const Color(0xFF000000))),
        ),
      ),
    );
    return semanticLabel == null
        ? ExcludeSemantics(child: painted)
        : Semantics(
            label: semanticLabel,
            image: true,
            child: ExcludeSemantics(child: painted),
          );
  }
}

class _IconPainter extends CustomPainter {
  _IconPainter(this.icon, this.color);

  final PcIconData icon;
  final Color color;

  static const _grid = 24.0;
  static const _stroke = 1.6;

  /// Drawings keep a 1.5 unit margin on the 24 grid; cropping it makes them
  /// fill the box about as much as platform icon glyphs do.
  static const _crop = 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    const view = _grid - 2 * _crop;
    canvas.scale(size.width / view, size.height / view);
    canvas.translate(-_crop, -_crop);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    for (final d in icon.strokes) {
      canvas.drawPath(SvgPath.parse(d), stroke);
    }
    for (final d in icon.fills) {
      canvas.drawPath(SvgPath.parse(d), fill);
    }
  }

  @override
  bool shouldRepaint(_IconPainter old) => old.icon != icon || old.color != color;
}

/// A small SVG path parser covering M, L, H, V, C, S, A and Z in absolute and
/// relative form. Parsed paths are cached by their source string.
abstract final class SvgPath {
  static final _cache = <String, Path>{};

  static Path parse(String d) => _cache[d] ??= _Parser(d).parse();
}

class _Parser {
  _Parser(this.src);

  final String src;
  int _i = 0;

  bool get _done => _i >= src.length;

  void _skip() {
    while (!_done && (src[_i] == ' ' || src[_i] == ',' || src[_i] == '\n' || src[_i] == '\t')) {
      _i++;
    }
  }

  bool get _atNumber {
    _skip();
    if (_done) return false;
    final ch = src.codeUnitAt(_i);
    return (ch >= 48 && ch <= 57) || ch == 45 || ch == 43 || ch == 46;
  }

  double _number() {
    _skip();
    final start = _i;
    if (src[_i] == '-' || src[_i] == '+') _i++;
    var dot = false;
    while (!_done) {
      final ch = src[_i];
      if (ch == '.') {
        if (dot) break;
        dot = true;
      } else if (ch.codeUnitAt(0) < 48 || ch.codeUnitAt(0) > 57) {
        break;
      }
      _i++;
    }
    return double.parse(src.substring(start, _i));
  }

  /// Arc flags are single digits and may be written without separators.
  bool _flag() {
    _skip();
    return src[_i++] == '1';
  }

  Path parse() {
    final path = Path();
    var x = 0.0, y = 0.0, startX = 0.0, startY = 0.0;
    double? ctrlX, ctrlY;
    String? cmd;
    while (true) {
      _skip();
      if (_done) break;
      final ch = src[_i];
      if (RegExp(r'[MmLlHhVvCcSsAaZz]').hasMatch(ch)) {
        cmd = ch;
        _i++;
      } else if (cmd == null) {
        throw FormatException('Path data must start with a command', src);
      }
      final rel = cmd.toLowerCase() == cmd;
      switch (cmd.toUpperCase()) {
        case 'M':
          x = _number() + (rel ? x : 0);
          y = _number() + (rel ? y : 0);
          path.moveTo(x, y);
          startX = x;
          startY = y;
          // Further pairs after a move are line-tos.
          cmd = rel ? 'l' : 'L';
          ctrlX = null;
        case 'L':
          x = _number() + (rel ? x : 0);
          y = _number() + (rel ? y : 0);
          path.lineTo(x, y);
          ctrlX = null;
        case 'H':
          x = _number() + (rel ? x : 0);
          path.lineTo(x, y);
          ctrlX = null;
        case 'V':
          y = _number() + (rel ? y : 0);
          path.lineTo(x, y);
          ctrlX = null;
        case 'C':
          final x1 = _number() + (rel ? x : 0), y1 = _number() + (rel ? y : 0);
          final x2 = _number() + (rel ? x : 0), y2 = _number() + (rel ? y : 0);
          final ex = _number() + (rel ? x : 0), ey = _number() + (rel ? y : 0);
          path.cubicTo(x1, y1, x2, y2, ex, ey);
          ctrlX = x2;
          ctrlY = y2;
          x = ex;
          y = ey;
        case 'S':
          final x1 = ctrlX == null ? x : 2 * x - ctrlX, y1 = ctrlY == null || ctrlX == null ? y : 2 * y - ctrlY;
          final x2 = _number() + (rel ? x : 0), y2 = _number() + (rel ? y : 0);
          final ex = _number() + (rel ? x : 0), ey = _number() + (rel ? y : 0);
          path.cubicTo(x1, y1, x2, y2, ex, ey);
          ctrlX = x2;
          ctrlY = y2;
          x = ex;
          y = ey;
        case 'A':
          final rx = _number(), ry = _number(), rotation = _number();
          final large = _flag(), sweep = _flag();
          final ex = _number() + (rel ? x : 0), ey = _number() + (rel ? y : 0);
          path.arcToPoint(
            Offset(ex, ey),
            radius: Radius.elliptical(rx, ry),
            rotation: rotation,
            largeArc: large,
            clockwise: sweep,
          );
          x = ex;
          y = ey;
          ctrlX = null;
        case 'Z':
          path.close();
          x = startX;
          y = startY;
          ctrlX = null;
          cmd = null;
          continue;
      }
      // Repeated coordinates reuse the last command.
      if (!_atNumber) cmd = null;
    }
    return path;
  }
}
