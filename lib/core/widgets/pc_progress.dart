import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../theme/pc_tokens.dart';

/// Loading indicator: a thin arc turning on a faint track. With reduced
/// motion it holds still.
class PcSpinner extends StatefulWidget {
  const PcSpinner({super.key, this.size = 20, this.color, this.semanticLabel = 'Loading'});

  final double size;
  final Color? color;
  final String semanticLabel;

  @override
  State<PcSpinner> createState() => _PcSpinnerState();
}

class _PcSpinnerState extends State<PcSpinner> with SingleTickerProviderStateMixin {
  late final _turn = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.reduceMotion) {
      _turn.stop();
    } else if (!_turn.isAnimating) {
      _turn.repeat();
    }
  }

  @override
  void dispose() {
    _turn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? context.pc.textPrimary;
    return Semantics(
      label: widget.semanticLabel,
      child: SizedBox.square(
        dimension: widget.size,
        child: RotationTransition(
          turns: _turn,
          child: CustomPaint(painter: _ArcPainter(color, widget.size)),
        ),
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  _ArcPainter(this.color, this.size);

  final Color color;
  final double size;

  @override
  void paint(Canvas canvas, Size s) {
    final stroke = (size / 10).clamp(1.5, 2.5);
    final rect = Offset.zero & s;
    final r = rect.deflate(stroke / 2);
    final track = Paint()
      ..color = color.withValues(alpha: 0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    final arc = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawOval(r, track);
    canvas.drawArc(r, -math.pi / 2, math.pi * 0.6, false, arc);
  }

  @override
  bool shouldRepaint(_ArcPainter old) => old.color != color || old.size != size;
}

/// Horizontal slider: a thin track filled up to a round thumb. Drag or tap
/// anywhere on it. No press or focus visuals.
class PcSlider extends StatelessWidget {
  const PcSlider({
    super.key,
    required this.value,
    required this.max,
    required this.onChanged,
    this.onChangeEnd,
    this.semanticLabel,
    this.semanticValue,
  });

  final double value;
  final double max;
  final ValueChanged<double> onChanged;
  final ValueChanged<double>? onChangeEnd;
  final String? semanticLabel;

  /// Spoken value, such as "0:04". Defaults to a percentage.
  final String? semanticValue;

  static const _thumb = 24.0;
  static const _track = 4.0;

  @override
  Widget build(BuildContext context) {
    final c = context.pc;
    final t = max <= 0 ? 0.0 : (value / max).clamp(0.0, 1.0);
    const step = 0.05;

    return LayoutBuilder(
      builder: (context, box) {
        final usable = box.maxWidth - _thumb;
        double at(double dx) => ((dx - _thumb / 2) / usable).clamp(0.0, 1.0) * max;
        void nudge(double by) {
          final v = (value + by * max).clamp(0.0, max);
          onChanged(v);
          onChangeEnd?.call(v);
        }

        return Semantics(
          slider: true,
          label: semanticLabel,
          value: semanticValue ?? '${(t * 100).round()}%',
          onIncrease: () => nudge(step),
          onDecrease: () => nudge(-step),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: (d) {
              final v = at(d.localPosition.dx);
              onChanged(v);
              onChangeEnd?.call(v);
            },
            onHorizontalDragUpdate: (d) => onChanged(at(d.localPosition.dx)),
            onHorizontalDragEnd: (_) => onChangeEnd?.call(value),
            child: SizedBox(
              height: PcSize.touch,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Positioned(
                    left: _thumb / 2,
                    right: _thumb / 2,
                    child: Container(
                      height: _track,
                      decoration: BoxDecoration(color: c.selectedTint, borderRadius: BorderRadius.circular(_track)),
                    ),
                  ),
                  Positioned(
                    left: _thumb / 2,
                    width: usable * t,
                    child: Container(
                      height: _track,
                      decoration: BoxDecoration(color: c.textPrimary, borderRadius: BorderRadius.circular(_track)),
                    ),
                  ),
                  Positioned(
                    left: usable * t,
                    child: Container(
                      width: _thumb,
                      height: _thumb,
                      decoration: BoxDecoration(
                        // White in both themes, like the system slider thumb.
                        color: c.onPrimary,
                        shape: BoxShape.circle,
                        border: Border.all(color: c.separator),
                        boxShadow: const [
                          BoxShadow(color: Color(0x24000000), blurRadius: 8, offset: Offset(0, 2)),
                          BoxShadow(color: Color(0x0F000000), blurRadius: 1.5),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
