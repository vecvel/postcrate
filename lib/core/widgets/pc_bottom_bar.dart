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

  /// Space screens leave at the bottom so their last item rests just above
  /// the tiles (the fade is off at the end of a page). Under the shell's
  /// `Scaffold(extendBody: true)` a page's bottom padding already covers the
  /// bar (tiles plus safe area), so this adds one spacing step to it.
  static double contentInset(BuildContext context) => MediaQuery.paddingOf(context).bottom + PcSpace.md;

  /// Height of the faded strip at the bottom of the screen, measured from
  /// inside a tab page (where the bottom padding is the bar).
  static double fadeHeight(BuildContext context) => fadeAbove + MediaQuery.paddingOf(context).bottom;

  final List<PcBarItem> items;
  final int index;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    // The bar draws nothing behind the tiles, but taps anywhere on it (the
    // gaps between tiles, the home indicator strip) must not reach the posts
    // underneath. A transparent ColoredBox hit-tests as opaque.
    return ColoredBox(
      color: const Color(0x00000000),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottom),
        child: SizedBox(
          height: tilesHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: PcSpace.xl),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var i = 0; i < items.length; i++)
                  _Tile(item: items[i], selected: i == index, onTap: () => onTap(i)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Fades a tab page out toward the screen edges along a smootherstep curve,
/// only while there is content to scroll on that side:
///
/// * Top: transparent at the top edge, opaque [topBelowStatusBar] below the
///   status bar. At rest (scrolled to the top) nothing is faded, so the
///   header sits right under the status bar.
/// * Bottom: transparent at the bottom edge, opaque [PcBottomBar.fadeHeight]
///   above it, behind the floating tab bar. At the end of the page nothing is
///   faded, so the last item sits right above the tabs.
///
/// Each fade eases in over the first [topBelowStatusBar] (top) or
/// [PcBottomBar.fadeAbove] (bottom) of scrollable content.
class PcEdgeFade extends StatefulWidget {
  const PcEdgeFade({super.key, required this.child});

  /// The page's vertical scroll view.
  final Widget child;

  /// How far below the status bar the top fade reaches.
  static const topBelowStatusBar = 44.0;

  /// Top padding for scroll content on tab pages.
  static double topContentInset(BuildContext context) => MediaQuery.paddingOf(context).top;

  static double smootherstep(double t) => t * t * t * (t * (t * 6 - 15) + 10);

  static const steps = 16;

  @override
  State<PcEdgeFade> createState() => _PcEdgeFadeState();
}

class _PcEdgeFadeState extends State<PcEdgeFade> {
  double _top = 0;
  double _bottom = 1;

  bool _onMetrics(ScrollMetrics m, int depth) {
    if (depth != 0 || m.axis != Axis.vertical || !m.hasContentDimensions) return false;
    final top = (m.extentBefore / PcEdgeFade.topBelowStatusBar).clamp(0.0, 1.0);
    final bottom = (m.extentAfter / PcBottomBar.fadeAbove).clamp(0.0, 1.0);
    if (top != _top || bottom != _bottom) {
      setState(() {
        _top = top;
        _bottom = bottom;
      });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final topFade = MediaQuery.paddingOf(context).top + PcEdgeFade.topBelowStatusBar;
    final bottomFade = PcBottomBar.fadeHeight(context);
    final top = _top, bottom = _bottom;
    const steps = PcEdgeFade.steps;
    double curve(int i) => PcEdgeFade.smootherstep(i / steps);

    return NotificationListener<ScrollMetricsNotification>(
      onNotification: (n) => _onMetrics(n.metrics, n.depth),
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) => _onMetrics(n.metrics, n.depth),
        child: ShaderMask(
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
                for (var i = 0; i <= steps; i++) Color.fromRGBO(0, 0, 0, 1 - top * (1 - curve(i))),
                for (var i = 0; i <= steps; i++) Color.fromRGBO(0, 0, 0, 1 - bottom * curve(i)),
              ],
            ).createShader(rect);
          },
          child: widget.child,
        ),
      ),
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
