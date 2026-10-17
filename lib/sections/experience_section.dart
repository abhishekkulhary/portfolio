import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../core/responsive.dart';
import '../data/models.dart';
import '../data/portfolio_data.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/reveal.dart';
import '../widgets/section_header.dart';
import '../widgets/tech_chip.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    const jobs = PortfolioData.experience;
    return SectionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            index: 3,
            eyebrow: 'experience',
            title: 'Where I\'ve shipped',
            subtitle: 'From enterprise integrations to airfreight billing and logistics platforms — '
                'production systems that people rely on every day.',
          ),
          const SizedBox(height: 48),
          for (var i = 0; i < jobs.length; i++)
            Reveal(
              delay: 60.ms,
              child: _TimelineEntry(job: jobs[i], isLast: i == jobs.length - 1),
            ),
        ],
      ),
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({required this.job, required this.isLast});

  final Experience job;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final desktop = context.isDesktop;
    final periodStyle = TextStyle(fontFamily: AppFonts.mono, fontSize: 13, color: p.primary);

    final card = Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!desktop) ...[
            Text(job.period, style: periodStyle),
            const SizedBox(height: 10),
          ],
          _JobCard(job: job),
        ],
      ),
    );

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (desktop)
            SizedBox(
              width: 190,
              child: Padding(
                padding: const EdgeInsets.only(top: 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(job.period, style: periodStyle, textAlign: TextAlign.right),
                    const SizedBox(height: 4),
                    Text(job.location,
                        style: TextStyle(fontSize: 13, color: p.textMuted), textAlign: TextAlign.right),
                  ],
                ),
              ),
            ),
          SizedBox(width: desktop ? 28 : 0),
          _Rail(highlight: job.isCurrent, isLast: isLast),
          SizedBox(width: desktop ? 28 : 18),
          Expanded(child: card),
        ],
      ),
    );
  }
}

class _Rail extends StatelessWidget {
  const _Rail({required this.highlight, required this.isLast});

  final bool highlight;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final dot = Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: highlight ? p.primary : p.background,
        border: Border.all(color: p.primary, width: 2),
        boxShadow: [BoxShadow(color: p.primary.withValues(alpha: highlight ? .8 : .35), blurRadius: highlight ? 14 : 6)],
      ),
    );

    return SizedBox(
      width: 14,
      child: Column(
        children: [
          const SizedBox(height: 30),
          if (highlight)
            dot.animate(onPlay: (c) => c.repeat(reverse: true)).scaleXY(begin: 1, end: 1.25, duration: 1100.ms)
          else
            dot,
          Expanded(
            child: Container(
              width: 2,
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    p.primary.withValues(alpha: .6),
                    isLast ? p.primary.withValues(alpha: 0) : p.secondary.withValues(alpha: .35),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  const _JobCard({required this.job});

  final Experience job;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final theme = Theme.of(context);
    return GlassCard(
      hoverGlow: true,
      padding: EdgeInsets.all(context.isMobile ? 20 : 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(job.role, style: theme.textTheme.titleLarge),
              if (job.isCurrent) const LabelPill('Now', color: Color(0xFF34D399)),
            ],
          ),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(children: [
              TextSpan(text: job.company, style: TextStyle(color: p.primary, fontWeight: FontWeight.w700)),
              if (!context.isDesktop) TextSpan(text: '  ·  ${job.location}'),
            ]),
            style: TextStyle(fontSize: 15, color: p.textMuted),
          ),
          const SizedBox(height: 16),
          for (final line in job.highlights)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text('▹', style: TextStyle(fontFamily: AppFonts.mono, color: p.primary)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(line, style: theme.textTheme.bodyMedium!.copyWith(fontSize: 15))),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [for (final s in job.stack) TechChip(s)]),
        ],
      ),
    );
  }
}
