import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../core/responsive.dart';
import '../data/models.dart';
import '../data/portfolio_data.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/icon_badge.dart';
import '../widgets/reveal.dart';
import '../widgets/section_header.dart';
import '../widgets/tech_chip.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            index: 2,
            eyebrow: 'skills',
            title: 'The stack',
            subtitle: 'Enterprise Java on the back end, Angular and Flutter on the front, '
                'and the databases and tooling that keep it all running in production.',
          ),
          const SizedBox(height: 40),
          ResponsiveGrid(
            minItemWidth: 320,
            maxColumns: 3,
            children: [
              for (var i = 0; i < PortfolioData.skills.length; i++)
                Reveal(delay: (i * 80).ms, child: _SkillCard(group: PortfolioData.skills[i])),
            ],
          ),
        ],
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({required this.group});

  final SkillGroup group;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return GlassCard(
      hoverGlow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            IconBadge(icon: group.icon, size: 40),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                group.title.toUpperCase(),
                style: TextStyle(fontFamily: AppFonts.mono, fontSize: 13, letterSpacing: 1.8, color: p.textPrimary, fontWeight: FontWeight.w500),
              ),
            ),
            Text(group.items.length.toString().padLeft(2, '0'),
                style: TextStyle(fontFamily: AppFonts.mono, fontSize: 12, color: p.textMuted)),
          ]),
          const SizedBox(height: 20),
          Wrap(spacing: 8, runSpacing: 8, children: [for (final item in group.items) TechChip(item)]),
        ],
      ),
    );
  }
}
