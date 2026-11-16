import 'package:flutter/material.dart';

import '../theme/pc_tokens.dart';
import 'pc_card.dart';
import 'pc_tap.dart';
import 'pc_icons.dart';

class PcBarItem {
  const PcBarItem({required this.icon, required this.label});

  final PcIconData icon;
  final String label;
}

/// Bottom bar with no background of its own: the tiles float over the page,
/// and [PcEdgeFade] fades the content out toward the bottom edge behind
/// them, so nothing is cut off by a solid band. Every tile shares one size
/// and baseline.
class PcBottomBar extends StatelessWidget {
  const PcBottomBar({super.key, required this.items, required this.index, required this.onTap});

  static const tilesHeight = PcSize.navTile + 10;

  /// How far above the tiles the content starts to fade.
  static const fadeAbove = 64.0;

  /// Space screens should leave at the bottom so their last item can scroll
  /// clear of the tiles and the fade.
  static double contentInset(BuildContext context) =>
      fadeAbove + tilesHeight + MediaQuery.paddingOf(context).bottom + PcSpace.md;

  /// Height of the faded strip at the bottom of the screen.
  static double fadeHeight(BuildContext context) => fadeAbove + tilesHeight + MediaQuery.paddingOf(context).bottom;

  final List<PcBarItem> items;
  final int index;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SizedBox(
        height: tilesHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: PcSpace.xl),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var i = 0; i < items.length; i++) _Tile(item: items[i], selected: i == index, onTap: () => onTap(i)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Fades [child] out toward both screen edges along a smootherstep curve:
/// at the top under the status bar, and at the bottom over
/// [PcBottomBar.fadeHeight] behind the floating tab bar. Content dissolves
/// into the page instead of meeting a hard edge.
class PcEdgeFade extends StatelessWidget {
  const PcEdgeFade({super.key, required this.child});

  final Widget child;

  /// How far below the status bar the top fade reaches; transparent at the
  /// top edge, opaque from here down.
  static const topBelowStatusBar = 44.0;

  /// Extra space tab pages leave above their header so it rests just below
  /// the top fade.
  static const topHeaderGap = 32.0;

  /// Top padding for scroll content on tab pages.
  static double topContentInset(BuildContext context) => MediaQuery.paddingOf(context).top + topHeaderGap;

  static double _smootherstep(double t) => t * t * t * (t * (t * 6 - 15) + 10);

  @override
  Widget build(BuildContext context) {
    final bottomFade = PcBottomBar.fadeHeight(context);
    final topFade = MediaQuery.paddingOf(context).top + topBelowStatusBar;
    const steps = 16;
    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (rect) {
        final h = rect.height;
        final topEnd = (topFade / h).clamp(0.0, 0.5);
        final bottomStart = ((h - bottomFade) / h).clamp(topEnd, 1.0);
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [
            for (var i = 0; i <= steps; i++) topEnd * i / steps,
            for (var i = 0; i <= steps; i++) bottomStart + (1 - bottomStart) * i / steps,
          ],
          colors: [
            for (var i = 0; i <= steps; i++) Color.fromRGBO(0, 0, 0, _smootherstep(i / steps)),
            for (var i = 0; i <= steps; i++) Color.fromRGBO(0, 0, 0, 1 - _smootherstep(i / steps)),
          ],
        ).createShader(rect);
      },
      child: child,
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.item, required this.selected, required this.onTap});

  final PcBarItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.pc;
    final bg = selected ? c.selectedTint : const Color(0x00000000);
    return Semantics(
      selected: selected,
      label: item.label,
      button: true,
      child: PcTap(
        onTap: onTap,
        child: Container(
          width: PcSize.navTile,
          height: PcSize.navTile,
          decoration: pcShape(bg, PcRadius.navTile),
          child: PcIcon(item.icon, size: PcSize.navIcon, color: selected ? c.textPrimary : c.textTertiary),
        ),
      ),
    );
  }
}
