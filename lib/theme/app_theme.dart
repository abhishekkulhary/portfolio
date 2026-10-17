import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData dark() => _build(Brightness.dark, AppPalette.dark);
  static ThemeData light() => _build(Brightness.light, AppPalette.light);

  static ThemeData _build(Brightness brightness, AppPalette p) {
    final scheme = ColorScheme.fromSeed(
      seedColor: p.primary,
      brightness: brightness,
    ).copyWith(
      primary: p.primary,
      onPrimary: p.onAccent,
      secondary: p.secondary,
      tertiary: p.tertiary,
      surface: p.surface,
      onSurface: p.textPrimary,
      onSurfaceVariant: p.textMuted,
      outline: p.glassBorder,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: AppFonts.sans,
      scaffoldBackgroundColor: p.background,
      extensions: [p],
    );

    final t = base.textTheme.apply(
      bodyColor: p.textPrimary,
      displayColor: p.textPrimary,
    );

    return base.copyWith(
      textTheme: t.copyWith(
        displayLarge: t.displayLarge?.copyWith(
            fontWeight: FontWeight.w700, letterSpacing: -2.5, height: .95),
        displayMedium: t.displayMedium?.copyWith(
            fontWeight: FontWeight.w700, letterSpacing: -1.5, height: 1.05),
        displaySmall: t.displaySmall
            ?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -1),
        headlineLarge: t.headlineLarge
            ?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -1),
        headlineMedium: t.headlineMedium
            ?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -.5),
        titleLarge: t.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        titleMedium: t.titleMedium?.copyWith(fontWeight: FontWeight.w500),
        bodyLarge: t.bodyLarge?.copyWith(height: 1.65, color: p.textMuted),
        bodyMedium: t.bodyMedium?.copyWith(height: 1.6, color: p.textMuted),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: p.primary,
        selectionColor: p.primary.withValues(alpha: .28),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(p.primary.withValues(alpha: .35)),
        thickness: const WidgetStatePropertyAll(6),
        radius: const Radius.circular(8),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: p.surface,
          borderRadius: BorderRadius.circular(AppRadii.sm),
          border: Border.all(color: p.glassBorder),
        ),
        textStyle: TextStyle(
            fontFamily: AppFonts.mono, fontSize: 12, color: p.textPrimary),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: p.surface,
        contentTextStyle:
            TextStyle(fontFamily: AppFonts.mono, color: p.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          side: BorderSide(color: p.primary.withValues(alpha: .4)),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.surface,
        shape: RoundedRectangleBorder(
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
          side: BorderSide(color: p.glassBorder),
        ),
      ),
      iconTheme: IconThemeData(color: p.textPrimary),
      dividerColor: p.glassBorder,
    );
  }
}
