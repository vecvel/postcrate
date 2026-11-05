import 'package:flutter/material.dart';

/// Values mirror design/tokens.json. Widgets read colors through
/// `context.pc` and sizes through the constant classes below.
@immutable
class PcColors extends ThemeExtension<PcColors> {
  const PcColors({
    required this.page,
    required this.card,
    required this.fieldOnCard,
    required this.fieldOnPage,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.primaryFill,
    required this.onPrimary,
    required this.selectedTint,
    required this.separator,
    required this.success,
    required this.warning,
    required this.danger,
    required this.dangerFill,
    required this.onDanger,
    required this.switchOn,
    required this.switchThumb,
  });

  final Color page;
  final Color card;
  final Color fieldOnCard;
  final Color fieldOnPage;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color primaryFill;
  final Color onPrimary;
  final Color selectedTint;
  final Color separator;
  final Color success;
  final Color warning;
  final Color danger;
  final Color dangerFill;
  final Color onDanger;
  final Color switchOn;
  final Color switchThumb;

  static const light = PcColors(
    page: Color(0xFFF2F2F2),
    card: Color(0xFFFFFFFF),
    fieldOnCard: Color(0xFFF0F0F0),
    fieldOnPage: Color(0xFFE6E6E6),
    textPrimary: Color(0xFF111111),
    textSecondary: Color(0xFF4A4A4A),
    textTertiary: Color(0xFF6E6E6E),
    primaryFill: Color(0xFF111111),
    onPrimary: Color(0xFFFFFFFF),
    selectedTint: Color(0x14111111),
    separator: Color(0x0F111111),
    success: Color(0xFF1E7B45),
    warning: Color(0xFF8A5A00),
    danger: Color(0xFFB3261E),
    dangerFill: Color(0xFFB3261E),
    onDanger: Color(0xFFFFFFFF),
    switchOn: Color(0xFF111111),
    switchThumb: Color(0xFFFFFFFF),
  );

  static const dark = PcColors(
    page: Color(0xFF0A0A0A),
    card: Color(0xFF1A1A1A),
    fieldOnCard: Color(0xFF262626),
    fieldOnPage: Color(0xFF1F1F1F),
    textPrimary: Color(0xFFF2F2F2),
    textSecondary: Color(0xFFA8A8A8),
    textTertiary: Color(0xFF939393),
    primaryFill: Color(0xFF3A3A3A),
    onPrimary: Color(0xFFFFFFFF),
    selectedTint: Color(0x14F2F2F2),
    separator: Color(0x0FF2F2F2),
    success: Color(0xFF5FC98A),
    warning: Color(0xFFE0B252),
    danger: Color(0xFFFF8A80),
    dangerFill: Color(0xFFB3261E),
    onDanger: Color(0xFFFFFFFF),
    switchOn: Color(0xFFF2F2F2),
    switchThumb: Color(0xFF8C8C8C),
  );

  @override
  PcColors copyWith() => this;

  @override
  PcColors lerp(PcColors? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return PcColors(
      page: l(page, other.page),
      card: l(card, other.card),
      fieldOnCard: l(fieldOnCard, other.fieldOnCard),
      fieldOnPage: l(fieldOnPage, other.fieldOnPage),
      textPrimary: l(textPrimary, other.textPrimary),
      textSecondary: l(textSecondary, other.textSecondary),
      textTertiary: l(textTertiary, other.textTertiary),
      primaryFill: l(primaryFill, other.primaryFill),
      onPrimary: l(onPrimary, other.onPrimary),
      selectedTint: l(selectedTint, other.selectedTint),
      separator: l(separator, other.separator),
      success: l(success, other.success),
      warning: l(warning, other.warning),
      danger: l(danger, other.danger),
      dangerFill: l(dangerFill, other.dangerFill),
      onDanger: l(onDanger, other.onDanger),
      switchOn: l(switchOn, other.switchOn),
      switchThumb: l(switchThumb, other.switchThumb),
    );
  }
}

abstract final class PcRadius {
  static const control = 10.0;
  static const navTile = 12.0;
  static const card = 16.0;
  static const sheet = 22.0;
}

abstract final class PcSpace {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 20.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const gutter = 16.0;
  static const cardPadding = 14.0;
}

abstract final class PcSize {
  static const touch = 44.0;
  static const navTile = 44.0;
  static const navIcon = 22.0;
  static const logo = 26.0;
  static const field = 44.0;
  static const mediaThumb = 64.0;
}

abstract final class PcMotion {
  static const curve = Cubic(0.32, 0.72, 0, 1);
  static const standard = Duration(milliseconds: 420);
  static const quick = Duration(milliseconds: 240);
  static const fade = Duration(milliseconds: 200);
}

extension PcThemeContext on BuildContext {
  PcColors get pc => Theme.of(this).extension<PcColors>()!;
  TextTheme get text => Theme.of(this).textTheme;
  bool get reduceMotion => MediaQuery.maybeDisableAnimationsOf(this) ?? false;
}
