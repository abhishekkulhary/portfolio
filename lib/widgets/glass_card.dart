import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Translucent card with a hairline border. With [hoverGlow] it lifts and
/// glows on hover/focus; [blur] adds a backdrop blur (keep it for a few
/// prominent surfaces — it is expensive on the web).
class GlassCard extends StatefulWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.radius = AppRadii.lg,
    this.blur = false,
    this.hoverGlow = false,
    this.onTap,
    this.semanticLabel,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final bool blur;
  final bool hoverGlow;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _hovered = false;

  void _setHovered(bool value) {
    if (_hovered != value) setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final glowing = widget.hoverGlow && _hovered;
    final radius = BorderRadius.circular(widget.radius);

    Widget card = AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      padding: widget.padding,
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [p.glass, p.glass.withValues(alpha: p.glass.a * .45)],
        ),
        border: Border.all(
          color: glowing ? p.primary.withValues(alpha: .55) : p.glassBorder,
        ),
        boxShadow: [
          if (glowing)
            BoxShadow(
              color: p.primary.withValues(alpha: .18),
              blurRadius: 36,
              spreadRadius: -6,
              offset: const Offset(0, 12),
            ),
        ],
      ),
      child: widget.child,
    );

    if (widget.blur) {
      card = ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: card,
        ),
      );
    }

    card = AnimatedSlide(
      offset: Offset(0, glowing ? -.012 : 0),
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      child: card,
    );

    if (widget.onTap == null) {
      return MouseRegion(
        onEnter: (_) => _setHovered(true),
        onExit: (_) => _setHovered(false),
        child: card,
      );
    }

    // InkWell gives keyboard focus, Enter/Space activation and button semantics.
    return Semantics(
      label: widget.semanticLabel,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: widget.onTap,
          onHover: _setHovered,
          onFocusChange: _setHovered,
          borderRadius: radius,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          child: card,
        ),
      ),
    );
  }
}
