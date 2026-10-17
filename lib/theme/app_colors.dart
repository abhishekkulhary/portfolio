import 'package:flutter/material.dart';

/// Design tokens. Change colours here — every widget reads them through
/// `context.palette`, so a tweak applies across the whole app.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.glass,
    required this.glassBorder,
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.onAccent,
    required this.textPrimary,
    required this.textMuted,
    required this.gridLine,
    required this.auroraStrength,
  });

  /// Page background behind the aurora.
  final Color background;

  /// Opaque surfaces: dialogs, sheets.
  final Color surface;

  /// Translucent fill and hairline border of glass cards.
  final Color glass;
  final Color glassBorder;

  /// Accent trio: cyan → violet → pink.
  final Color primary;
  final Color secondary;
  final Color tertiary;

  /// Text drawn on top of the accent gradient.
  final Color onAccent;

  final Color textPrimary;
  final Color textMuted;

  /// Background grid lines.
  final Color gridLine;

  /// 0–1, how visible the moving aurora blobs are.
  final double auroraStrength;

  static const dark = AppPalette(
    background: Color(0xFF05070D),
    surface: Color(0xFF0B1020),
    glass: Color(0x12FFFFFF),
    glassBorder: Color(0x1FFFFFFF),
    primary: Color(0xFF22D3EE),
    secondary: Color(0xFF8B5CF6),
    tertiary: Color(0xFFF472B6),
    onAccent: Color(0xFF041018),
    textPrimary: Color(0xFFE6EDF7),
    textMuted: Color(0xFF8A96AD),
    gridLine: Color(0x0FFFFFFF),
    auroraStrength: 1,
  );

  static const light = AppPalette(
    background: Color(0xFFF3F6FB),
    surface: Color(0xFFFFFFFF),
    glass: Color(0xB3FFFFFF),
    glassBorder: Color(0x1A0B1020),
    primary: Color(0xFF0891B2),
    secondary: Color(0xFF7C3AED),
    tertiary: Color(0xFFDB2777),
    onAccent: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF0B1020),
    textMuted: Color(0xFF55607A),
    gridLine: Color(0x120B1020),
    auroraStrength: .55,
  );

  LinearGradient get accentGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primary, secondary],
      );

  LinearGradient get headlineGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [textPrimary, primary, secondary],
        stops: const [.15, .65, 1],
      );

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? glass,
    Color? glassBorder,
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? onAccent,
    Color? textPrimary,
    Color? textMuted,
    Color? gridLine,
    double? auroraStrength,
  }) {
    return AppPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      glass: glass ?? this.glass,
      glassBorder: glassBorder ?? this.glassBorder,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      onAccent: onAccent ?? this.onAccent,
      textPrimary: textPrimary ?? this.textPrimary,
      textMuted: textMuted ?? this.textMuted,
      gridLine: gridLine ?? this.gridLine,
      auroraStrength: auroraStrength ?? this.auroraStrength,
    );
  }

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      glass: Color.lerp(glass, other.glass, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      gridLine: Color.lerp(gridLine, other.gridLine, t)!,
      auroraStrength:
          auroraStrength + (other.auroraStrength - auroraStrength) * t,
    );
  }
}

abstract final class AppRadii {
  static const double sm = 10;
  static const double md = 16;
  static const double lg = 24;
}

abstract final class AppFonts {
  static const sans = 'SpaceGrotesk';
  static const mono = 'JetBrainsMono';
}

extension PaletteContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}
