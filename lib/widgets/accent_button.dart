import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Gradient (filled) or outlined call-to-action with a hover glow.
class AccentButton extends StatefulWidget {
  const AccentButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.filled = true,
    this.compact = false,
  });

  final String label;
  final VoidCallback? onPressed;

  /// Any icon widget — `Icon` or `FaIcon`. Colour and size come from the button.
  final Widget? icon;
  final bool filled;
  final bool compact;

  @override
  State<AccentButton> createState() => _AccentButtonState();
}

class _AccentButtonState extends State<AccentButton> {
  bool _hovered = false;

  void _setHovered(bool value) {
    if (_hovered != value) setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final enabled = widget.onPressed != null;
    final foreground = widget.filled ? p.onAccent : p.primary;
    final radius = BorderRadius.circular(widget.compact ? 10 : 14);

    return Opacity(
      opacity: enabled ? 1 : .45,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: widget.onPressed,
          onHover: _setHovered,
          onFocusChange: _setHovered,
          borderRadius: radius,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            padding: widget.compact
                ? const EdgeInsets.symmetric(horizontal: 14, vertical: 10)
                : const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: radius,
              gradient: widget.filled ? p.accentGradient : null,
              color: widget.filled ? null : p.primary.withValues(alpha: _hovered ? .12 : .04),
              border: widget.filled ? null : Border.all(color: p.primary.withValues(alpha: _hovered ? .8 : .4)),
              boxShadow: [
                if (widget.filled)
                  BoxShadow(
                    color: p.primary.withValues(alpha: _hovered ? .45 : .22),
                    blurRadius: _hovered ? 28 : 18,
                    spreadRadius: -4,
                    offset: const Offset(0, 8),
                  ),
              ],
            ),
            child: IconTheme.merge(
              data: IconThemeData(color: foreground, size: widget.compact ? 15 : 17),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[widget.icon!, const SizedBox(width: 10)],
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: foreground,
                      fontWeight: FontWeight.w700,
                      fontSize: widget.compact ? 13.5 : 15,
                      letterSpacing: .2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
