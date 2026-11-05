import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'pc_tokens.dart';

/// Builds the app theme from the tokens. System font only; no splash, hover,
/// focus or press highlights anywhere.
ThemeData buildAppTheme(Brightness brightness) {
  final c = brightness == Brightness.light ? PcColors.light : PcColors.dark;

  TextStyle s(double size, double height, FontWeight weight, Color color) =>
      TextStyle(fontSize: size, height: height / size, fontWeight: weight, color: color, letterSpacing: 0);

  final textTheme = TextTheme(
    displaySmall: s(34, 41, FontWeight.w700, c.textPrimary),
    headlineMedium: s(28, 34, FontWeight.w700, c.textPrimary),
    headlineSmall: s(22, 28, FontWeight.w600, c.textPrimary),
    titleLarge: s(20, 25, FontWeight.w600, c.textPrimary),
    titleMedium: s(17, 22, FontWeight.w600, c.textPrimary),
    bodyLarge: s(17, 22, FontWeight.w400, c.textPrimary),
    bodyMedium: s(15, 20, FontWeight.w400, c.textSecondary),
    labelLarge: s(16, 21, FontWeight.w500, c.textPrimary),
    bodySmall: s(13, 18, FontWeight.w400, c.textTertiary),
    labelMedium: s(12, 16, FontWeight.w400, c.textTertiary),
    labelSmall: s(11, 13, FontWeight.w400, c.textTertiary),
  );

  const noBorder = OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.all(Radius.circular(PcRadius.control)),
  );

  final transitions = PageTransitionsTheme(
    builders: {for (final p in TargetPlatform.values) p: const CupertinoPageTransitionsBuilder()},
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: c.textPrimary,
          brightness: brightness,
          dynamicSchemeVariant: DynamicSchemeVariant.monochrome,
        ).copyWith(
          surface: c.page,
          onSurface: c.textPrimary,
          primary: c.primaryFill,
          onPrimary: c.onPrimary,
          error: c.danger,
        ),
    scaffoldBackgroundColor: c.page,
    canvasColor: c.page,
    textTheme: textTheme,
    extensions: [c],
    splashFactory: NoSplash.splashFactory,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    focusColor: Colors.transparent,
    pageTransitionsTheme: transitions,
    cupertinoOverrideTheme: CupertinoThemeData(
      brightness: brightness,
      primaryColor: c.textPrimary,
      scaffoldBackgroundColor: c.page,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: c.textPrimary,
      selectionColor: c.textPrimary.withValues(alpha: 0.18),
      selectionHandleColor: c.textPrimary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: c.fieldOnPage,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      hintStyle: textTheme.bodyLarge!.copyWith(color: c.textTertiary),
      border: noBorder,
      enabledBorder: noBorder,
      focusedBorder: noBorder,
      errorBorder: noBorder,
      focusedErrorBorder: noBorder,
      disabledBorder: noBorder,
    ),
    iconTheme: IconThemeData(color: c.textPrimary, size: PcSize.navIcon),
    dividerTheme: DividerThemeData(color: c.separator, thickness: 0.5, space: 0.5),
    datePickerTheme: DatePickerThemeData(backgroundColor: c.card),
    timePickerTheme: TimePickerThemeData(backgroundColor: c.card),
    dialogTheme: DialogThemeData(
      backgroundColor: c.card,
      elevation: 0,
      shape: const RoundedSuperellipseBorder(borderRadius: BorderRadius.all(Radius.circular(PcRadius.sheet))),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: c.page,
      modalBackgroundColor: c.page,
      elevation: 0,
      showDragHandle: false,
      shape: const RoundedSuperellipseBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(PcRadius.sheet))),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: c.primaryFill,
      contentTextStyle: textTheme.bodyMedium!.copyWith(color: c.onPrimary),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      shape: const RoundedSuperellipseBorder(borderRadius: BorderRadius.all(Radius.circular(PcRadius.control))),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        splashFactory: NoSplash.splashFactory,
        foregroundColor: WidgetStateProperty.all(c.textPrimary),
      ),
    ),
    scrollbarTheme: const ScrollbarThemeData(thickness: WidgetStatePropertyAll(3)),
  );
}
