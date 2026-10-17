import 'package:flutter/material.dart';

import '../core/responsive.dart';
import '../theme/app_colors.dart';
import 'reveal.dart';

/// Paints its text with [gradient] (defaults to the palette's headline gradient).
class GradientText extends StatelessWidget {
  const GradientText(this.text, {super.key, this.style, this.gradient, this.textAlign});

  final String text;
  final TextStyle? style;
  final Gradient? gradient;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final g = gradient ?? context.palette.headlineGradient;
    final fontSize = style?.fontSize ?? DefaultTextStyle.of(context).style.fontSize ?? 14;
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => g.createShader(Offset.zero & bounds.size),
      // The mask clips to its child's box; tight line heights push descenders
      // (g, y, p) below it, so reserve room under the last line.
      child: Padding(
        padding: EdgeInsets.only(bottom: fontSize * .14),
        child: Text(text, style: style, textAlign: textAlign),
      ),
    );
  }
}

/// `01 ── about` eyebrow, a large title ending in an accent dot, and an
/// optional subtitle.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.index,
    required this.eyebrow,
    required this.title,
    this.subtitle,
  });

  final int index;
  final String eyebrow;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final theme = Theme.of(context);
    final titleStyle = (context.isMobile ? theme.textTheme.headlineLarge : theme.textTheme.displaySmall)!;

    return Reveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(
              index.toString().padLeft(2, '0'),
              style: TextStyle(fontFamily: AppFonts.mono, color: p.primary, fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 12),
            Container(
              width: 44,
              height: 1,
              decoration: BoxDecoration(gradient: p.accentGradient),
            ),
            const SizedBox(width: 12),
            Text(
              eyebrow.toUpperCase(),
              style: TextStyle(fontFamily: AppFonts.mono, color: p.textMuted, fontSize: 12, letterSpacing: 2.5),
            ),
          ]),
          const SizedBox(height: 16),
          Text.rich(
            TextSpan(children: [
              TextSpan(text: title),
              TextSpan(text: '.', style: TextStyle(color: p.primary)),
            ]),
            style: titleStyle,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Text(subtitle!, style: theme.textTheme.bodyLarge),
            ),
          ],
        ],
      ),
    );
  }
}

/// Vertical rhythm shared by all page sections.
class SectionShell extends StatelessWidget {
  const SectionShell({super.key, required this.child});

  final Widget child;

  /// Space above a section's header; nav jumps use it to land the header
  /// just below the floating bar.
  static double verticalPadding(BuildContext context) =>
      context.responsive<double>(mobile: 64, desktop: 104);

  @override
  Widget build(BuildContext context) {
    final vertical = verticalPadding(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: vertical),
      child: ContentWidth(child: child),
    );
  }
}
