import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Icon in a gradient-bordered rounded square, used on cards.
class IconBadge extends StatelessWidget {
  const IconBadge({super.key, required this.icon, this.size = 44});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(gradient: p.accentGradient, borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(color: p.background.withValues(alpha: .85), borderRadius: BorderRadius.circular(11)),
        child: Icon(icon, color: p.primary, size: size * .5),
      ),
    );
  }
}
