import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../core/links.dart';
import '../core/responsive.dart';
import '../data/models.dart';
import '../data/portfolio_data.dart';
import '../theme/app_colors.dart';
import '../widgets/accent_button.dart';
import '../widgets/glass_card.dart';
import '../widgets/reveal.dart';
import '../widgets/section_header.dart';
import '../widgets/tech_chip.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  /// Null shows everything.
  ProjectCategory? _filter;

  @override
  Widget build(BuildContext context) {
    const all = PortfolioData.projects;
    final visible = [for (final p in all) if (_filter == null || p.categories.contains(_filter)) p];

    return SectionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            index: 4,
            eyebrow: 'projects',
            title: 'Selected work',
            subtitle: 'Research, professional and personal projects — from robot mission control '
                'to privacy-first apps. Tap a card for the details.',
          ),
          const SizedBox(height: 32),
          Reveal(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _FilterPill(
                  label: 'All',
                  count: all.length,
                  selected: _filter == null,
                  onTap: () => setState(() => _filter = null),
                ),
                for (final category in ProjectCategory.values)
                  _FilterPill(
                    label: category.label,
                    count: all.where((p) => p.categories.contains(category)).length,
                    selected: _filter == category,
                    onTap: () => setState(() => _filter = category),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: ResponsiveGrid(
              key: ValueKey(_filter),
              minItemWidth: 330,
              maxColumns: 3,
              children: [
                for (var i = 0; i < visible.length; i++)
                  Reveal(
                    delay: ((i % 3) * 90).ms,
                    child: _ProjectCard(project: visible[i], index: all.indexOf(visible[i])),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({required this.label, required this.count, required this.selected, required this.onTap});

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: selected ? p.accentGradient : null,
            color: selected ? null : p.glass,
            border: Border.all(color: selected ? Colors.transparent : p.glassBorder),
          ),
          child: Text.rich(
            TextSpan(children: [
              TextSpan(text: label),
              TextSpan(
                text: '  ${count.toString().padLeft(2, '0')}',
                style: const TextStyle(fontFamily: AppFonts.mono, fontSize: 11.5),
              ),
            ]),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: selected ? p.onAccent : p.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project, required this.index});

  final Project project;
  final int index;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    const maxChips = 4;
    final extra = project.stack.length - maxChips;

    return GlassCard(
      hoverGlow: true,
      padding: EdgeInsets.zero,
      semanticLabel: 'Open details for ${project.title}',
      onTap: () => showProjectDetails(context, project, index),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProjectBanner(project: project, index: index, height: 132),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(project.title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text(project.tagline, style: TextStyle(fontFamily: AppFonts.mono, fontSize: 12.5, color: p.primary)),
                  const SizedBox(height: 12),
                  Text(
                    project.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: p.textMuted, height: 1.55, fontSize: 14.5),
                  ),
                  const SizedBox(height: 16),
                  Wrap(spacing: 6, runSpacing: 6, children: [
                    for (final s in project.stack.take(maxChips)) TechChip(s),
                    if (extra > 0) TechChip('+$extra', muted: true),
                  ]),
                  const Spacer(),
                  const SizedBox(height: 18),
                  Row(children: [
                    Text('Details', style: TextStyle(fontFamily: AppFonts.mono, fontSize: 13, color: p.primary)),
                    const SizedBox(width: 6),
                    Icon(Icons.arrow_forward_rounded, size: 16, color: p.primary),
                    const Spacer(),
                    for (final link in project.links)
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: FaIcon(link.icon, size: 16, color: p.textMuted),
                      ),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Generated cover art: an accent gradient, a grid, and the project icon.
class ProjectBanner extends StatelessWidget {
  const ProjectBanner({super.key, required this.project, required this.index, required this.height, this.radius = AppRadii.lg});

  final Project project;
  final int index;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final pairs = [
      (p.primary, p.secondary),
      (p.secondary, p.tertiary),
      (p.tertiary, p.primary),
    ];
    final (a, b) = pairs[index % pairs.length];

    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(radius - 1)),
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [a.withValues(alpha: .30), b.withValues(alpha: .10)],
                ),
              ),
            ),
            CustomPaint(painter: _BannerGridPainter(p.gridLine.withValues(alpha: p.gridLine.a * 1.6))),
            Positioned(
              right: -18,
              bottom: -26,
              child: Icon(project.icon, size: height * 1.05, color: a.withValues(alpha: .16)),
            ),
            Positioned(
              left: 20,
              bottom: 18,
              child: Icon(project.icon, size: 34, color: p.textPrimary),
            ),
            Positioned(
              left: 20,
              top: 16,
              child: LabelPill(project.kind, color: a),
            ),
            Positioned(
              right: 18,
              top: 16,
              child: Text(
                'P/${(index + 1).toString().padLeft(2, '0')}${project.year != null ? ' · ${project.year}' : ''}',
                style: TextStyle(fontFamily: AppFonts.mono, fontSize: 12, color: p.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerGridPainter extends CustomPainter {
  _BannerGridPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const step = 22.0;
    for (var x = step; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = step; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_BannerGridPainter oldDelegate) => oldDelegate.color != color;
}

Future<void> showProjectDetails(BuildContext context, Project project, int index) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close',
    barrierColor: Colors.black.withValues(alpha: .45),
    transitionDuration: const Duration(milliseconds: 320),
    pageBuilder: (context, _, _) => _ProjectDialog(project: project, index: index),
    transitionBuilder: (context, animation, _, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8 * animation.value, sigmaY: 8 * animation.value),
        child: FadeTransition(
          opacity: curved,
          child: ScaleTransition(scale: Tween(begin: .96, end: 1.0).animate(curved), child: child),
        ),
      );
    },
  );
}

class _ProjectDialog extends StatelessWidget {
  const _ProjectDialog({required this.project, required this.index});

  final Project project;
  final int index;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final theme = Theme.of(context);
    final pad = context.isMobile ? 22.0 : 32.0;

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Material(
              color: p.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadii.lg),
                side: BorderSide(color: p.primary.withValues(alpha: .35)),
              ),
              clipBehavior: Clip.antiAlias,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(children: [
                      ProjectBanner(project: project, index: index, height: 170),
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: IconButton(
                          tooltip: 'Close',
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded),
                          style: IconButton.styleFrom(backgroundColor: p.background.withValues(alpha: .6)),
                        ),
                      ),
                    ]),
                    Padding(
                      padding: EdgeInsets.all(pad),
                      child: SelectionArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(project.title, style: theme.textTheme.headlineMedium),
                            const SizedBox(height: 4),
                            Text(project.tagline,
                                style: TextStyle(fontFamily: AppFonts.mono, fontSize: 13.5, color: p.primary)),
                            const SizedBox(height: 18),
                            Text(project.description, style: theme.textTheme.bodyLarge),
                            const SizedBox(height: 24),
                            _DialogHeading('Highlights'),
                            for (final h in project.highlights)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('▹ ', style: TextStyle(fontFamily: AppFonts.mono, color: p.primary)),
                                    const SizedBox(width: 6),
                                    Expanded(child: Text(h, style: theme.textTheme.bodyMedium!.copyWith(fontSize: 15))),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 14),
                            _DialogHeading('Stack'),
                            Wrap(spacing: 8, runSpacing: 8, children: [for (final s in project.stack) TechChip(s)]),
                            if (project.links.isNotEmpty) ...[
                              const SizedBox(height: 28),
                              Wrap(spacing: 12, runSpacing: 12, children: [
                                for (final link in project.links)
                                  AccentButton(
                                    label: link.label,
                                    icon: FaIcon(link.icon),
                                    compact: true,
                                    onPressed: () => openLink(link.url),
                                  ),
                              ]),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogHeading extends StatelessWidget {
  const _DialogHeading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(fontFamily: AppFonts.mono, fontSize: 12, letterSpacing: 2, color: context.palette.textMuted),
      ),
    );
  }
}
