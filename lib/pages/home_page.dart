import 'package:flutter/material.dart';

import '../core/github_releases.dart';
import '../core/responsive.dart';
import '../sections/about_section.dart';
import '../sections/contact_section.dart';
import '../sections/downloads_section.dart';
import '../sections/experience_section.dart';
import '../sections/footer.dart';
import '../sections/hero_section.dart';
import '../sections/projects_section.dart';
import '../sections/skills_section.dart';
import '../theme/app_colors.dart';
import '../widgets/aurora_background.dart';
import '../widgets/nav_bar.dart';
import '../widgets/section_header.dart';

/// Single scrolling page: fixed aurora backdrop, floating nav, sections.
class HomePage extends StatefulWidget {
  const HomePage({super.key, this.releases});

  /// Passed through to the downloads section (tests inject a fake).
  final GitHubReleases? releases;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _sections = ['About', 'Skills', 'Experience', 'Projects', 'Downloads', 'Contact'];
  static const _projectsIndex = 3;
  static const _downloadsIndex = 4;

  final _scroll = ScrollController();
  final _keys = List.generate(_sections.length, (_) => GlobalKey());
  final _active = ValueNotifier<int>(-1);
  final _showBackToTop = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.dispose();
    _active.dispose();
    _showBackToTop.dispose();
    super.dispose();
  }

  void _onScroll() {
    _showBackToTop.value = _scroll.offset > 600;

    // The active section is the last one whose top has passed 35% of the viewport.
    final threshold = MediaQuery.sizeOf(context).height * .35;
    var active = -1;
    for (var i = 0; i < _keys.length; i++) {
      final box = _keys[i].currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.attached) continue;
      if (box.localToGlobal(Offset.zero).dy <= threshold) active = i;
    }
    _active.value = active;
  }

  void _scrollToSection(int index) {
    final box = _keys[index].currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    // Land the section header just below the floating nav bar.
    final navClearance = MediaQuery.paddingOf(context).top + 12 + Layout.navHeight + 20;
    final sectionTop = box.localToGlobal(Offset.zero).dy + _scroll.offset;
    final target = sectionTop + SectionShell.verticalPadding(context) - navClearance;
    _scroll.animateTo(
      target.clamp(0, _scroll.position.maxScrollExtent),
      duration: const Duration(milliseconds: 850),
      curve: Curves.easeInOutCubic,
    );
  }

  void _scrollToTop() {
    _scroll.animateTo(0, duration: const Duration(milliseconds: 900), curve: Curves.easeInOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: AuroraBackground()),
          Positioned.fill(
            child: SelectionArea(
              child: Scrollbar(
                controller: _scroll,
                child: SingleChildScrollView(
                  controller: _scroll,
                  child: Column(
                    children: [
                      HeroSection(
                        onViewProjects: () => _scrollToSection(_projectsIndex),
                        onGetApp: () => _scrollToSection(_downloadsIndex),
                      ),
                      AboutSection(key: _keys[0]),
                      SkillsSection(key: _keys[1]),
                      ExperienceSection(key: _keys[2]),
                      ProjectsSection(key: _keys[3]),
                      DownloadsSection(key: _keys[4], releases: widget.releases),
                      ContactSection(key: _keys[5]),
                      const Footer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: PortfolioNavBar(
                sections: _sections,
                active: _active,
                onSelect: _scrollToSection,
                onLogoTap: _scrollToTop,
              ),
            ),
          ),
          Positioned(
            right: 24,
            bottom: 24,
            child: SafeArea(
              child: ValueListenableBuilder<bool>(
                valueListenable: _showBackToTop,
                builder: (context, visible, _) => _BackToTopButton(visible: visible, onPressed: _scrollToTop),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackToTopButton extends StatelessWidget {
  const _BackToTopButton({required this.visible, required this.onPressed});

  final bool visible;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 250),
        child: AnimatedScale(
          scale: visible ? 1 : .8,
          duration: const Duration(milliseconds: 250),
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: p.accentGradient,
              boxShadow: [BoxShadow(color: p.primary.withValues(alpha: .4), blurRadius: 20, spreadRadius: -4)],
            ),
            child: IconButton(
              tooltip: 'Back to top',
              onPressed: onPressed,
              icon: Icon(Icons.arrow_upward_rounded, color: p.onAccent),
            ),
          ),
        ),
      ),
    );
  }
}
