import 'package:flutter/material.dart';

import '../theme/pc_tokens.dart';
import 'pc_card.dart';
import 'pc_tap.dart';

class PcBarItem {
  const PcBarItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// Bottom bar: no top border, solid behind the tiles, fading upward into the
/// content along a smootherstep curve and slightly darker toward the bottom
/// edge. Every tile shares one size and baseline.
class PcBottomBar extends StatelessWidget {
  const PcBottomBar({super.key, required this.items, required this.index, required this.onTap});

  static const fadeHeight = 28.0;
  static const tilesHeight = PcSize.navTile + 10;

  /// Space screens should leave at the bottom so content can scroll under the fade.
  static double contentInset(BuildContext context) =>
      fadeHeight + tilesHeight + MediaQuery.paddingOf(context).bottom + PcSpace.md;

  final List<PcBarItem> items;
  final int index;
  final ValueChanged<int> onTap;

  static double _smootherstep(double t) => t * t * t * (t * (t * 6 - 15) + 10);

  @override
  Widget build(BuildContext context) {
    final c = context.pc;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final darker = Color.alphaBlend(Colors.black.withValues(alpha: 0.04), c.page);
    const stops = 16;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IgnorePointer(
          child: Container(
            height: fadeHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [for (var i = 0; i <= stops; i++) i / stops],
                colors: [for (var i = 0; i <= stops; i++) c.page.withValues(alpha: _smootherstep(i / stops))],
              ),
            ),
          ),
        ),
        Container(
          color: c.page,
          height: tilesHeight,
          padding: const EdgeInsets.symmetric(horizontal: PcSpace.xl),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var i = 0; i < items.length; i++) _Tile(item: items[i], selected: i == index, onTap: () => onTap(i)),
            ],
          ),
        ),
        Container(
          height: bottom,
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [c.page, darker]),
          ),
        ),
      ],
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
    final bg = selected ? Color.alphaBlend(c.selectedTint, c.page) : c.page;
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
          child: Icon(item.icon, size: PcSize.navIcon, color: selected ? c.textPrimary : c.textTertiary),
        ),
      ),
    );
  }
}
