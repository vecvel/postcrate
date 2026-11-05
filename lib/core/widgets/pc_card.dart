import 'package:flutter/material.dart';

import '../theme/pc_tokens.dart';
import 'pc_surface.dart';
import 'pc_tap.dart';

ShapeDecoration pcShape(Color color, double radius) => ShapeDecoration(
  color: color,
  shape: RoundedSuperellipseBorder(borderRadius: BorderRadius.all(Radius.circular(radius))),
);

/// Borderless card: separated from the page by fill shade only.
class PcCard extends StatelessWidget {
  const PcCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(PcSpace.cardPadding),
    this.onTap,
    this.onLongPress,
    this.semanticLabel,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final card = DecoratedBox(
      decoration: pcShape(context.pc.card, PcRadius.card),
      child: PcSurface(
        level: PcSurfaceLevel.card,
        child: Padding(padding: padding, child: child),
      ),
    );
    if (onTap == null && onLongPress == null) return card;
    return PcTap(onTap: onTap, onLongPress: onLongPress, semanticLabel: semanticLabel, child: card);
  }
}

/// iOS grouped list: one borderless card with inset separators between rows.
class PcGroup extends StatelessWidget {
  const PcGroup({super.key, required this.children, this.separatorIndent = PcSpace.cardPadding});

  final List<Widget> children;
  final double separatorIndent;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) {
        rows.add(
          Padding(
            padding: EdgeInsetsDirectional.only(start: separatorIndent),
            child: Container(height: 0.5, color: context.pc.separator),
          ),
        );
      }
      rows.add(children[i]);
    }
    return ClipRSuperellipse(
      borderRadius: const BorderRadius.all(Radius.circular(PcRadius.card)),
      child: ColoredBox(
        color: context.pc.card,
        child: PcSurface(
          level: PcSurfaceLevel.card,
          child: Column(mainAxisSize: MainAxisSize.min, children: rows),
        ),
      ),
    );
  }
}

/// A row inside a [PcGroup].
class PcRow extends StatelessWidget {
  const PcRow({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.titleColor,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    final content = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 52),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: PcSpace.cardPadding, vertical: 10),
        child: Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: PcSpace.sm)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: context.text.bodyLarge!.copyWith(color: titleColor)),
                  if (subtitle != null) ...[const SizedBox(height: 2), Text(subtitle!, style: context.text.bodySmall)],
                ],
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: PcSpace.sm), trailing!],
          ],
        ),
      ),
    );
    if (onTap == null) return content;
    return PcTap(onTap: onTap, semanticLabel: title, child: content);
  }
}

/// Small dim sentence-case label above a section.
class PcSectionLabel extends StatelessWidget {
  const PcSectionLabel(this.text, {super.key, this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, PcSpace.lg, 4, PcSpace.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(text, style: context.text.labelMedium, semanticsLabel: text),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
