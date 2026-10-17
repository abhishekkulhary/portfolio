import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class TechChip extends StatelessWidget {
  const TechChip(this.label, {super.key, this.muted = false});

  final String label;

  /// Neutral styling, e.g. for "+3" overflow chips.
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final color = muted ? p.textMuted : p.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: .25)),
      ),
      child: Text(
        label,
        style: TextStyle(fontFamily: AppFonts.mono, fontSize: 12.5, color: color, height: 1.2),
      ),
    );
  }
}

/// Monospace pill used for small labels ("NOW", "YOUR DEVICE", project kind).
class LabelPill extends StatelessWidget {
  const LabelPill(this.label, {super.key, this.color});

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final c = color ?? p.primary;
    // Pulled towards the text colour so the label stays legible on tinted banners.
    final text = Color.lerp(c, p.textPrimary, .45)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: c.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.withValues(alpha: .4)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(fontFamily: AppFonts.mono, fontSize: 10.5, letterSpacing: 1.2, color: text, fontWeight: FontWeight.w500),
      ),
    );
  }
}
