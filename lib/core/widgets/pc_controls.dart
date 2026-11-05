import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/pc_tokens.dart';
import 'pc_card.dart';
import 'pc_surface.dart';
import 'pc_tap.dart';

enum PcButtonVariant { primary, secondary, danger, plain }

/// Borderless button. Primary and danger use deep fills with light text;
/// secondary uses the field shade of whatever surface it sits on.
class PcButton extends StatelessWidget {
  const PcButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = PcButtonVariant.primary,
    this.icon,
    this.loading = false,
    this.expand = false,
    this.compact = false,
  });

  const PcButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.expand = false,
    this.compact = false,
  }) : variant = PcButtonVariant.secondary;

  const PcButton.danger({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.expand = false,
    this.compact = false,
  }) : variant = PcButtonVariant.danger;

  final String label;
  final VoidCallback? onPressed;
  final PcButtonVariant variant;
  final IconData? icon;
  final bool loading;
  final bool expand;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final c = context.pc;
    final (Color bg, Color fg) = switch (variant) {
      PcButtonVariant.primary => (c.primaryFill, c.onPrimary),
      PcButtonVariant.danger => (c.dangerFill, c.onDanger),
      PcButtonVariant.secondary => (PcSurface.fieldColor(context), c.textPrimary),
      PcButtonVariant.plain => (Colors.transparent, c.textPrimary),
    };
    final disabled = onPressed == null || loading;
    final style = context.text.labelLarge!.copyWith(color: fg, fontSize: compact ? 14 : 16);

    final content = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          SizedBox.square(dimension: 16, child: CupertinoActivityIndicator(color: fg, radius: 8))
        else if (icon != null)
          Icon(icon, size: compact ? 16 : 18, color: fg),
        if (loading || icon != null) const SizedBox(width: 6),
        Flexible(
          child: Text(label, style: style, overflow: TextOverflow.ellipsis),
        ),
      ],
    );

    return Opacity(
      opacity: disabled && !loading ? 0.45 : 1,
      child: PcTap(
        onTap: disabled ? null : onPressed,
        semanticLabel: label,
        child: Container(
          constraints: BoxConstraints(minHeight: compact ? 36 : PcSize.touch, minWidth: PcSize.touch),
          padding: EdgeInsets.symmetric(horizontal: compact ? 14 : 18),
          decoration: pcShape(bg, PcRadius.control),
          child: ExcludeSemantics(
            // Hug the label unless expanded; the min height still centers it.
            child: expand ? Center(child: content) : Center(widthFactor: 1, heightFactor: 1, child: content),
          ),
        ),
      ),
    );
  }
}

/// 44x44 icon target with no background and no press feedback.
class PcIconButton extends StatelessWidget {
  const PcIconButton({super.key, required this.icon, required this.onTap, required this.label, this.color});

  final IconData icon;
  final VoidCallback? onTap;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return PcTap(
      onTap: onTap,
      semanticLabel: label,
      child: SizedBox.square(
        dimension: PcSize.touch,
        child: Icon(icon, size: PcSize.navIcon, color: color ?? context.pc.textPrimary),
      ),
    );
  }
}

/// Borderless text field filled one shade off its container.
class PcTextField extends StatelessWidget {
  const PcTextField({
    super.key,
    this.controller,
    this.hint,
    this.minLines = 1,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.prefixIcon,
    this.focusNode,
    this.textCapitalization = TextCapitalization.sentences,
    this.style,
    this.semanticLabel,
  });

  final TextEditingController? controller;
  final String? hint;
  final int minLines;
  final int? maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  final IconData? prefixIcon;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.pc;
    return Semantics(
      textField: true,
      label: semanticLabel ?? hint,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus,
        minLines: minLines,
        maxLines: maxLines,
        keyboardType: keyboardType ?? (maxLines == 1 ? TextInputType.text : TextInputType.multiline),
        textInputAction: textInputAction,
        textCapitalization: textCapitalization,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        style: style ?? context.text.bodyLarge,
        scrollPadding: const EdgeInsets.only(bottom: 120),
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        decoration: InputDecoration(
          hintText: hint,
          fillColor: PcSurface.fieldColor(context),
          prefixIcon: prefixIcon == null ? null : Icon(prefixIcon, size: 18, color: c.textTertiary),
          prefixIconConstraints: const BoxConstraints(minWidth: 38, minHeight: 20),
        ),
      ),
    );
  }
}

/// iOS-proportioned switch drawn without any press or focus effect.
class PcSwitch extends StatelessWidget {
  const PcSwitch({super.key, required this.value, required this.onChanged, this.label});

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final c = context.pc;
    final duration = context.reduceMotion ? Duration.zero : PcMotion.quick;
    final light = Theme.of(context).brightness == Brightness.light;
    final thumb = value && !light ? c.page : c.switchThumb;
    return Semantics(
      toggled: value,
      label: label,
      child: PcTap(
        onTap: onChanged == null ? null : () => onChanged!(!value),
        child: AnimatedContainer(
          duration: duration,
          curve: PcMotion.curve,
          width: 51,
          height: 31,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: value ? c.switchOn : PcSurface.fieldColor(context),
            borderRadius: BorderRadius.circular(16),
          ),
          child: AnimatedAlign(
            duration: duration,
            curve: PcMotion.curve,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 27,
              height: 27,
              decoration: BoxDecoration(
                color: thumb,
                shape: BoxShape.circle,
                boxShadow: light
                    ? const [BoxShadow(color: Color(0x1F000000), blurRadius: 3, offset: Offset(0, 1))]
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Toggle chip. Unselected uses the field shade; selected uses the deep fill.
class PcChip extends StatelessWidget {
  const PcChip({super.key, required this.label, this.selected = false, this.onTap, this.icon});

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = context.pc;
    final bg = selected ? c.primaryFill : PcSurface.fieldColor(context);
    final fg = selected ? c.onPrimary : c.textPrimary;
    return Semantics(
      selected: selected,
      child: PcTap(
        onTap: onTap,
        semanticLabel: label,
        child: Container(
          constraints: const BoxConstraints(minHeight: 34),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: pcShape(bg, PcRadius.control),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[Icon(icon, size: 15, color: fg), const SizedBox(width: 5)],
              Text(label, style: context.text.bodyMedium!.copyWith(color: fg, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}

/// iOS segmented control: field-shade track, selected segment in the surface color above it.
class PcSegmented<T> extends StatelessWidget {
  const PcSegmented({
    super.key,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
  });

  final List<T> values;
  final T selected;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.pc;
    final onCard = PcSurface.of(context) == PcSurfaceLevel.card;
    final selectedBg = onCard ? c.card : c.page;
    final track = PcSurface.fieldColor(context);
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: pcShape(track, PcRadius.control),
      child: Row(
        children: [
          for (final v in values)
            Expanded(
              child: Semantics(
                selected: v == selected,
                child: PcTap(
                  onTap: () => onChanged(v),
                  semanticLabel: labelOf(v),
                  child: AnimatedContainer(
                    duration: context.reduceMotion ? Duration.zero : PcMotion.quick,
                    curve: PcMotion.curve,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: pcShape(v == selected ? selectedBg : track, 8),
                    child: Text(
                      labelOf(v),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.bodyMedium!.copyWith(
                        fontSize: 13,
                        color: v == selected ? c.textPrimary : c.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Square tile holding an icon, equal padding on every side.
class PcIconTile extends StatelessWidget {
  const PcIconTile({super.key, required this.icon, this.size = 32, this.color});

  final IconData icon;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: pcShape(PcSurface.fieldColor(context), size * 0.28),
      child: Icon(icon, size: size * 0.55, color: color ?? context.pc.textPrimary),
    );
  }
}
