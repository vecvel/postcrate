import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/pc_tokens.dart';
import 'pc_card.dart';
import 'pc_controls.dart';
import 'pc_mark.dart';

/// Minimal page header: page context only.
class PcHeader extends StatelessWidget {
  const PcHeader({super.key, required this.title, this.showMark = false, this.actions = const []});

  final String title;
  final bool showMark;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(PcSpace.gutter + 4, PcSpace.sm, PcSpace.gutter - 10, PcSpace.sm),
      child: Row(
        children: [
          if (showMark) ...[PcMark(size: PcSize.logo, color: context.pc.textPrimary), const SizedBox(width: 10)],
          Expanded(
            child: Semantics(header: true, child: Text(title, style: context.text.headlineSmall)),
          ),
          ...actions,
        ],
      ),
    );
  }
}

/// Header for pushed screens: back or cancel on the left, actions on the right.
class PcNavBar extends StatelessWidget {
  const PcNavBar({super.key, required this.title, this.leadingLabel, this.onLeading, this.trailing});

  final String title;
  final String? leadingLabel;
  final VoidCallback? onLeading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final leading = leadingLabel == null
        ? PcIconButton(
            icon: CupertinoIcons.chevron_back,
            label: 'Back',
            onTap: onLeading ?? () => Navigator.of(context).maybePop(),
          )
        : PcButton(
            label: leadingLabel!,
            variant: PcButtonVariant.plain,
            compact: true,
            onPressed: onLeading ?? () => Navigator.of(context).maybePop(),
          );
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Semantics(header: true, child: Text(title, style: context.text.titleMedium)),
          Positioned(left: 4, child: leading),
          if (trailing != null) Positioned(right: PcSpace.sm, child: trailing!),
        ],
      ),
    );
  }
}

/// Opens a borderless bottom sheet on the page color.
Future<T?> showPcSheet<T>(BuildContext context, {required String title, required WidgetBuilder builder}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 36,
                height: 5,
                decoration: BoxDecoration(color: ctx.pc.fieldOnPage, borderRadius: BorderRadius.circular(3)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(PcSpace.gutter + 4, PcSpace.md, PcSpace.gutter, PcSpace.xs),
              child: Semantics(header: true, child: Text(title, style: ctx.text.titleMedium)),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(PcSpace.gutter, 0, PcSpace.gutter, PcSpace.md),
                child: builder(ctx),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Confirmation sheet. Pass [typedConfirmation] to require typing a word
/// before a large or irreversible action.
Future<bool> showPcConfirm(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  bool destructive = false,
  String? typedConfirmation,
}) async {
  final result = await showPcSheet<bool>(
    context,
    title: title,
    builder: (ctx) => _ConfirmBody(
      message: message,
      confirmLabel: confirmLabel,
      destructive: destructive,
      typedConfirmation: typedConfirmation,
    ),
  );
  return result ?? false;
}

class _ConfirmBody extends StatefulWidget {
  const _ConfirmBody({
    required this.message,
    required this.confirmLabel,
    required this.destructive,
    this.typedConfirmation,
  });

  final String message;
  final String confirmLabel;
  final bool destructive;
  final String? typedConfirmation;

  @override
  State<_ConfirmBody> createState() => _ConfirmBodyState();
}

class _ConfirmBodyState extends State<_ConfirmBody> {
  final _typed = TextEditingController();

  @override
  void dispose() {
    _typed.dispose();
    super.dispose();
  }

  bool get _ready => widget.typedConfirmation == null || _typed.text.trim() == widget.typedConfirmation;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(widget.message, style: context.text.bodyMedium),
        ),
        if (widget.typedConfirmation != null) ...[
          const SizedBox(height: PcSpace.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text('Type "${widget.typedConfirmation}" to confirm', style: context.text.bodySmall),
          ),
          const SizedBox(height: 6),
          PcTextField(
            controller: _typed,
            hint: widget.typedConfirmation,
            autofocus: true,
            textCapitalization: TextCapitalization.none,
            onChanged: (_) => setState(() {}),
          ),
        ],
        const SizedBox(height: PcSpace.lg),
        PcButton(
          label: widget.confirmLabel,
          variant: widget.destructive ? PcButtonVariant.danger : PcButtonVariant.primary,
          expand: true,
          onPressed: _ready ? () => Navigator.of(context).pop(true) : null,
        ),
        const SizedBox(height: PcSpace.xs),
        PcButton.secondary(label: 'Cancel', expand: true, onPressed: () => Navigator.of(context).pop(false)),
      ],
    );
  }
}

/// Invitation shown when a list is empty.
class PcEmptyState extends StatelessWidget {
  const PcEmptyState({super.key, required this.title, required this.body, this.actionLabel, this.onAction, this.icon});

  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return PcCard(
      padding: const EdgeInsets.all(PcSpace.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[PcIconTile(icon: icon!, size: 40), const SizedBox(height: PcSpace.sm)],
          Text(title, style: context.text.titleMedium),
          const SizedBox(height: 4),
          Text(body, style: context.text.bodyMedium),
          if (actionLabel != null) ...[
            const SizedBox(height: PcSpace.md),
            PcButton(label: actionLabel!, onPressed: onAction),
          ],
        ],
      ),
    );
  }
}

void showPcToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 3)));
}
