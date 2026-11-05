import 'package:flutter/widgets.dart';

import '../theme/pc_tokens.dart';

enum PcSurfaceLevel { page, card }

/// Tells fields, chips and secondary buttons which layer they sit on, so they
/// pick a fill one shade off their container (no borders anywhere).
class PcSurface extends InheritedWidget {
  const PcSurface({super.key, required this.level, required super.child});

  final PcSurfaceLevel level;

  static PcSurfaceLevel of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PcSurface>()?.level ?? PcSurfaceLevel.page;

  /// Fill for controls placed on the current surface.
  static Color fieldColor(BuildContext context) {
    final c = context.pc;
    return of(context) == PcSurfaceLevel.card ? c.fieldOnCard : c.fieldOnPage;
  }

  /// Background of the current surface itself.
  static Color surfaceColor(BuildContext context) {
    final c = context.pc;
    return of(context) == PcSurfaceLevel.card ? c.card : c.page;
  }

  @override
  bool updateShouldNotify(PcSurface oldWidget) => level != oldWidget.level;
}
