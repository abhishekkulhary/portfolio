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

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final desktop = context.isDesktop;
    const story = _StoryCard();
    const facts = _FactsColumn();

    return SectionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(index: 1, eyebrow: 'about', title: 'About me'),
          const SizedBox(height: 40),
          if (desktop)
            const IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 3, child: story),
                  SizedBox(width: 24),
                  Expanded(flex: 2, child: facts),
                ],
              ),
            )
          else
            const Column(children: [story, SizedBox(height: 24), facts]),
          const SizedBox(height: 24),
          ResponsiveGrid(
            minItemWidth: 280,
            maxColumns: 3,
            children: [
              for (var i = 0; i < PortfolioData.focusAreas.length; i++)
                Reveal(delay: (i * 90).ms, child: _FocusCard(area: PortfolioData.focusAreas[i])),
            ],
          ),
        ],
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  const _StoryCard();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final theme = Theme.of(context);
    final profile = PortfolioData.profile;
    return Reveal(
      child: GlassCard(
        padding: EdgeInsets.all(context.isMobile ? 24 : 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('// ${profile.role.toLowerCase()}',
                style: TextStyle(fontFamily: AppFonts.mono, fontSize: 13, color: p.primary)),
            const SizedBox(height: 18),
            for (var i = 0; i < profile.summary.length; i++) ...[
              if (i > 0) const SizedBox(height: 16),
              Text(
                profile.summary[i],
                style: i == 0
                    ? theme.textTheme.titleMedium!.copyWith(fontSize: 19, height: 1.6, color: p.textPrimary)
                    : theme.textTheme.bodyLarge,
              ),
            ],
            const SizedBox(height: 24),
            Row(children: [
              Icon(Icons.location_on_outlined, size: 18, color: p.primary),
              const SizedBox(width: 8),
              Flexible(
                child: Text(profile.location,
                    style: TextStyle(fontFamily: AppFonts.mono, fontSize: 13, color: p.textMuted)),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class _FactsColumn extends StatelessWidget {
  const _FactsColumn();

  @override
  Widget build(BuildContext context) {
    return Reveal(
      delay: 120.ms,
      child: GlassCard(
        padding: EdgeInsets.all(context.isMobile ? 24 : 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _FactHeading(icon: Icons.school_outlined, label: 'Education'),
            for (final e in PortfolioData.education) _EducationTile(education: e),
            const SizedBox(height: 20),
            const _FactHeading(icon: Icons.workspace_premium_outlined, label: 'Certifications'),
            for (final c in PortfolioData.certifications) _CertificationTile(certification: c),
            const SizedBox(height: 20),
            const _FactHeading(icon: Icons.translate_rounded, label: 'Languages'),
            for (final l in PortfolioData.languages) _LanguageBar(language: l),
          ],
        ),
      ),
    );
  }
}

class _FactHeading extends StatelessWidget {
  const _FactHeading({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        Icon(icon, size: 16, color: p.primary),
        const SizedBox(width: 8),
        Text(label.toUpperCase(),
            style: TextStyle(fontFamily: AppFonts.mono, fontSize: 12, letterSpacing: 2, color: p.primary)),
      ]),
    );
  }
}

class _EducationTile extends StatelessWidget {
  const _EducationTile({required this.education});

  final Education education;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(education.degree, style: TextStyle(fontWeight: FontWeight.w700, color: p.textPrimary, fontSize: 15.5)),
          const SizedBox(height: 2),
          Text(education.institution, style: TextStyle(color: p.textMuted, fontSize: 14)),
          Text(education.period, style: TextStyle(fontFamily: AppFonts.mono, color: p.textMuted, fontSize: 12)),
        ],
      ),
    );
  }
}

class _CertificationTile extends StatelessWidget {
  const _CertificationTile({required this.certification});

  final Certification certification;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Text('▹', style: TextStyle(fontFamily: AppFonts.mono, color: p.primary)),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(certification.name, style: TextStyle(color: p.textPrimary, fontSize: 14.5, height: 1.4))),
        ],
      ),
    );
  }
}

class _LanguageBar extends StatelessWidget {
  const _LanguageBar({required this.language});

  final SpokenLanguage language;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(language.name, style: TextStyle(color: p.textPrimary, fontSize: 14.5)),
            const Spacer(),
            Text(language.level, style: TextStyle(fontFamily: AppFonts.mono, color: p.textMuted, fontSize: 12)),
          ]),
          const SizedBox(height: 6),
          Container(
            height: 4,
            decoration: BoxDecoration(color: p.glassBorder, borderRadius: BorderRadius.circular(4)),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: language.proficiency,
              child: Container(
                decoration: BoxDecoration(
                  gradient: p.accentGradient,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [BoxShadow(color: p.primary.withValues(alpha: .5), blurRadius: 6)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FocusCard extends StatelessWidget {
  const _FocusCard({required this.area});

  final FocusArea area;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return GlassCard(
      hoverGlow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBadge(icon: area.icon),
          const SizedBox(height: 18),
          Text(area.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(area.body, style: TextStyle(color: p.textMuted, height: 1.6)),
        ],
      ),
    );
  }
}
