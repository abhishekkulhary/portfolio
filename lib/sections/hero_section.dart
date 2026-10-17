import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../core/links.dart';
import '../core/responsive.dart';
import '../data/portfolio_data.dart';
import '../theme/app_colors.dart';
import '../widgets/accent_button.dart';
import '../widgets/glass_card.dart';
import '../widgets/section_header.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key, required this.onViewProjects, required this.onGetApp});

  final VoidCallback onViewProjects;
  final VoidCallback onGetApp;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final desktop = context.isDesktop;
    final avatarSize = context.responsive<double>(mobile: 220, tablet: 280, desktop: 400);

    final text = _HeroText(onViewProjects: onViewProjects, onGetApp: onGetApp);
    final visual = _HeroVisual(size: avatarSize);

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: math.max(height, 680)),
      child: ContentWidth(
        child: Padding(
          padding: EdgeInsets.only(top: Layout.navHeight + (desktop ? 72 : 48), bottom: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (desktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 6, child: text),
                    const SizedBox(width: 48),
                    Expanded(flex: 4, child: Center(child: visual)),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Center(child: visual), const SizedBox(height: 40), text],
                ),
              SizedBox(height: desktop ? 72 : 48),
              const _StatsStrip(),
              if (desktop) ...[
                const SizedBox(height: 40),
                const _ScrollHint(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  const _HeroText({required this.onViewProjects, required this.onGetApp});

  final VoidCallback onViewProjects;
  final VoidCallback onGetApp;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final profile = PortfolioData.profile;
    final nameSize = context.responsive<double>(mobile: 54, tablet: 76, desktop: 92);

    final children = <Widget>[
      _StatusPill(text: profile.statusLine),
      const SizedBox(height: 28),
      Row(children: [
        Text('> hello, world. I\'m', style: TextStyle(fontFamily: AppFonts.mono, fontSize: 16, color: p.primary)),
        const _BlinkingCursor(),
      ]),
      const SizedBox(height: 12),
      GradientText(
        '${profile.firstName}\n${profile.lastName}',
        style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: nameSize),
      ),
      const SizedBox(height: 20),
      _RotatingRole(roles: profile.rotatingRoles),
      const SizedBox(height: 20),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Text(profile.headline, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18)),
      ),
      const SizedBox(height: 36),
      Wrap(
        spacing: 14,
        runSpacing: 14,
        children: [
          AccentButton(
            label: 'View projects',
            icon: const Icon(Icons.arrow_forward_rounded),
            onPressed: onViewProjects,
          ),
          AccentButton(
            label: 'Download CV',
            icon: const FaIcon(FontAwesomeIcons.filePdf),
            filled: false,
            onPressed: () => openLink(resumeUrl()),
          ),
          AccentButton(
            label: 'Get the app',
            icon: const Icon(Icons.download_rounded),
            filled: false,
            onPressed: onGetApp,
          ),
        ],
      ),
      const SizedBox(height: 28),
      Row(children: [
        for (final social in PortfolioData.socials)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: IconButton(
              tooltip: social.label,
              onPressed: () => openLink(social.url),
              icon: FaIcon(social.icon, size: 20, color: p.textMuted),
              hoverColor: p.primary.withValues(alpha: .1),
            ),
          ),
      ]),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children
          .animate(interval: 70.ms)
          .fadeIn(duration: 600.ms, curve: Curves.easeOut)
          .moveY(begin: 18, end: 0, duration: 600.ms, curve: Curves.easeOutCubic),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    const live = Color(0xFF34D399);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: p.glass,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: p.glassBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: live,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: live.withValues(alpha: .8), blurRadius: 8)],
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .fade(begin: 1, end: .35, duration: 1200.ms),
          const SizedBox(width: 10),
          Flexible(
            child: Text(text, style: TextStyle(fontFamily: AppFonts.mono, fontSize: 12.5, color: p.textPrimary)),
          ),
        ],
      ),
    );
  }
}

class _BlinkingCursor extends StatelessWidget {
  const _BlinkingCursor();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      width: 9,
      height: 18,
      color: context.palette.primary,
    ).animate(onPlay: (c) => c.repeat(reverse: true)).fade(begin: 1, end: 0, duration: 550.ms, curve: Curves.easeInOutExpo);
  }
}

/// Cycles through [roles] with a slide-up transition.
class _RotatingRole extends StatefulWidget {
  const _RotatingRole({required this.roles});

  final List<String> roles;

  @override
  State<_RotatingRole> createState() => _RotatingRoleState();
}

class _RotatingRoleState extends State<_RotatingRole> {
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 2800), (_) {
      if (mounted) setState(() => _index = (_index + 1) % widget.roles.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final size = context.responsive<double>(mobile: 19, desktop: 26);
    return Row(
      children: [
        Text('~/ ', style: TextStyle(fontFamily: AppFonts.mono, fontSize: size, color: p.textMuted)),
        Flexible(
          child: ClipRect(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 450),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              // New role rises in from below; the old one rises out the top.
              transitionBuilder: (child, animation) {
                final incoming = child.key == ValueKey(_index);
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween(begin: Offset(0, incoming ? .6 : -.6), end: Offset.zero).animate(animation),
                    child: child,
                  ),
                );
              },
              layoutBuilder: (current, previous) => Stack(
                alignment: Alignment.centerLeft,
                children: [...previous, ?current],
              ),
              child: Text(
                widget.roles[_index],
                key: ValueKey(_index),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: size, fontWeight: FontWeight.w500, color: p.textPrimary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Photo inside a rotating gradient ring, with tech badges in orbit.
class _HeroVisual extends StatelessWidget {
  const _HeroVisual({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final profile = PortfolioData.profile;
    final ring = size * .74;
    const badges = ['Java', 'Spring', 'Angular', 'Flutter'];

    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Soft glow.
          Container(
            width: ring,
            height: ring,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: p.primary.withValues(alpha: .28), blurRadius: size * .25),
                BoxShadow(color: p.secondary.withValues(alpha: .22), blurRadius: size * .35, offset: Offset(size * .05, size * .06)),
              ],
            ),
          ),
          // Dashed orbit.
          CustomPaint(size: Size.square(size * .98), painter: _DashedCirclePainter(p.glassBorder)),
          // Rotating gradient ring.
          Container(
            width: ring,
            height: ring,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(colors: [p.primary, p.secondary, p.tertiary, p.primary]),
            ),
          ).animate(onPlay: (c) => c.repeat()).rotate(duration: 14.seconds),
          // Photo.
          Container(
            width: ring - 8,
            height: ring - 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: p.background),
            padding: const EdgeInsets.all(6),
            child: ClipOval(
              child: profile.photoAsset != null
                  ? Image.asset(
                      profile.photoAsset!,
                      fit: BoxFit.cover,
                      semanticLabel: 'Portrait of ${profile.fullName}',
                    )
                  : Center(
                      child: GradientText(
                        profile.initials,
                        style: TextStyle(fontSize: ring * .3, fontWeight: FontWeight.w700),
                      ),
                    ),
            ),
          ),
          // Orbiting badges.
          for (var i = 0; i < badges.length; i++)
            Align(
              alignment: Alignment(
                math.cos(-math.pi / 4 + i * math.pi / 2) * .98,
                math.sin(-math.pi / 4 + i * math.pi / 2) * .98,
              ),
              child: GlassCard(
                blur: true,
                radius: 12,
                padding: EdgeInsets.symmetric(horizontal: size < 300 ? 10 : 14, vertical: size < 300 ? 6 : 8),
                child: Text(
                  badges[i],
                  style: TextStyle(fontFamily: AppFonts.mono, fontSize: size < 300 ? 11 : 13, color: p.textPrimary),
                ),
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .moveY(begin: -5, end: 5, duration: (2200 + i * 300).ms, curve: Curves.easeInOutSine),
            ),
        ],
      ),
    ).animate().fadeIn(duration: 900.ms).scaleXY(begin: .92, end: 1, duration: 900.ms, curve: Curves.easeOutCubic);
  }
}

class _DashedCirclePainter extends CustomPainter {
  _DashedCirclePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final radius = size.width / 2;
    final center = size.center(Offset.zero);
    const dashes = 72;
    const sweep = 2 * math.pi / dashes;
    for (var i = 0; i < dashes; i++) {
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), i * sweep, sweep * .5, false, paint);
    }
  }

  @override
  bool shouldRepaint(_DashedCirclePainter oldDelegate) => oldDelegate.color != color;
}

class _StatsStrip extends StatelessWidget {
  const _StatsStrip();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final stats = PortfolioData.stats;
    final tiles = [
      for (final stat in stats)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            GradientText(
              stat.value,
              gradient: p.accentGradient,
              style: TextStyle(fontSize: context.responsive<double>(mobile: 32, desktop: 42), fontWeight: FontWeight.w700, height: 1),
            ),
            const SizedBox(height: 8),
            Text(
              stat.label.toUpperCase(),
              style: TextStyle(fontFamily: AppFonts.mono, fontSize: 11.5, letterSpacing: 1.6, color: p.textMuted),
            ),
          ],
        ),
    ];

    return GlassCard(
      padding: EdgeInsets.symmetric(horizontal: 28, vertical: context.isMobile ? 24 : 28),
      child: context.isMobile
          ? Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [for (final t in tiles) SizedBox(width: 130, child: t)],
            )
          : Row(
              children: [
                for (var i = 0; i < tiles.length; i++) ...[
                  if (i > 0) Container(width: 1, height: 48, color: p.glassBorder, margin: const EdgeInsets.symmetric(horizontal: 24)),
                  Expanded(child: tiles[i]),
                ],
              ],
            ),
    ).animate().fadeIn(delay: 500.ms, duration: 700.ms).moveY(begin: 20, end: 0, delay: 500.ms, duration: 700.ms, curve: Curves.easeOutCubic);
  }
}

class _ScrollHint extends StatelessWidget {
  const _ScrollHint();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Column(
      children: [
        Text('SCROLL', style: TextStyle(fontFamily: AppFonts.mono, fontSize: 10.5, letterSpacing: 3, color: p.textMuted)),
        const SizedBox(height: 6),
        Icon(Icons.keyboard_double_arrow_down_rounded, color: p.primary, size: 20)
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .moveY(begin: -3, end: 4, duration: 900.ms, curve: Curves.easeInOut),
      ],
    );
  }
}
