import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Fades and slides [child] in the first time it scrolls into view.
class Reveal extends StatefulWidget {
  const Reveal({super.key, required this.child, this.delay = Duration.zero});

  final Widget child;

  /// Stagger offset, e.g. `index * 80.ms` for items in a list.
  final Duration delay;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> {
  ScrollPosition? _position;
  bool _visible = false;
  bool _reduceMotion = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (_reduceMotion) {
      _visible = true;
      return;
    }
    final position = Scrollable.maybeOf(context)?.position;
    if (position != _position) {
      _position?.removeListener(_check);
      _position = position?..addListener(_check);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _check() {
    if (_visible || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    if (top < MediaQuery.sizeOf(context).height * .92) {
      _position?.removeListener(_check);
      setState(() => _visible = true);
    }
  }

  @override
  void dispose() {
    _position?.removeListener(_check);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_reduceMotion) return widget.child;
    return widget.child
        .animate(target: _visible ? 1 : 0)
        .fadeIn(delay: widget.delay, duration: 650.ms, curve: Curves.easeOut)
        .moveY(begin: 28, end: 0, delay: widget.delay, duration: 650.ms, curve: Curves.easeOutCubic);
  }
}
