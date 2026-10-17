import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Fixed, full-screen backdrop: slowly drifting colour blobs over a faint
/// grid that fades out towards the edges. Static when the OS asks for
/// reduced motion.
class AuroraBackground extends StatefulWidget {
  const AuroraBackground({super.key});

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 28),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _AuroraPainter(_controller, context.palette),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _AuroraPainter extends CustomPainter {
  _AuroraPainter(this.animation, this.palette) : super(repaint: animation);

  final Animation<double> animation;
  final AppPalette palette;

  static const double _gridSpacing = 56;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.drawRect(bounds, Paint()..color = palette.background);

    final t = animation.value * 2 * math.pi;
    final extent = math.max(size.width, size.height);
    final blobs = [
      (palette.primary, Offset(.12 + .08 * math.sin(t), .18 + .07 * math.cos(t)), .55, .20),
      (palette.secondary, Offset(.88 + .06 * math.cos(t), .30 + .09 * math.sin(t)), .50, .22),
      (palette.tertiary, Offset(.55 + .12 * math.sin(t + 2), .95 + .05 * math.cos(t)), .42, .12),
    ];
    for (final (color, rel, radiusFactor, alpha) in blobs) {
      final center = Offset(rel.dx * size.width, rel.dy * size.height);
      final radius = radiusFactor * extent;
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..shader = RadialGradient(colors: [
            color.withValues(alpha: alpha * palette.auroraStrength),
            color.withValues(alpha: 0),
          ]).createShader(Rect.fromCircle(center: center, radius: radius)),
      );
    }

    // Grid, faded radially from the top centre.
    final gridPaint = Paint()
      ..strokeWidth = 1
      ..shader = RadialGradient(
        center: const Alignment(0, -.6),
        radius: 1.1,
        colors: [palette.gridLine, palette.gridLine.withValues(alpha: 0)],
      ).createShader(bounds);
    for (var x = _gridSpacing / 2; x < size.width; x += _gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (var y = _gridSpacing / 2; y < size.height; y += _gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(_AuroraPainter oldDelegate) => oldDelegate.palette != palette;
}
