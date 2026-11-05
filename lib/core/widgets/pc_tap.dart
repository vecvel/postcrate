import 'package:flutter/widgets.dart';

/// Tap target with no visual feedback (no splash, highlight or press state).
class PcTap extends StatelessWidget {
  const PcTap({super.key, required this.child, this.onTap, this.onLongPress, this.semanticLabel, this.button = true});

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? semanticLabel;
  final bool button;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: button && onTap != null,
      label: semanticLabel,
      enabled: onTap != null,
      child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: onTap, onLongPress: onLongPress, child: child),
    );
  }
}
