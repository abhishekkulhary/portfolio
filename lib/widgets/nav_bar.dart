import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/responsive.dart';
import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';

/// Floating glass bar: logo, section links with an active indicator, and a
/// theme toggle. Collapses into a bottom-sheet menu below desktop width.
class PortfolioNavBar extends StatelessWidget {
  const PortfolioNavBar({
    super.key,
    required this.sections,
    required this.active,
    required this.onSelect,
    required this.onLogoTap,
  });

  final List<String> sections;
  final ValueListenable<int> active;
  final ValueChanged<int> onSelect;
  final VoidCallback onLogoTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final radius = BorderRadius.circular(18);

    return Padding(
      padding: EdgeInsets.fromLTRB(Layout.gutter(context) / 2, 12, Layout.gutter(context) / 2, 0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Layout.maxContentWidth),
          child: ClipRRect(
            borderRadius: radius,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: Layout.navHeight,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: p.background.withValues(alpha: .55),
                  borderRadius: radius,
                  border: Border.all(color: p.glassBorder),
                ),
                child: Row(
                  children: [
                    _Logo(onTap: onLogoTap),
                    const Spacer(),
                    if (context.isDesktop)
                      // Scales down rather than overflowing near the breakpoint
                      // or with large system text.
                      Flexible(
                        flex: 8,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: ValueListenableBuilder<int>(
                            valueListenable: active,
                            builder: (context, current, _) => Row(
                              children: [
                                for (var i = 0; i < sections.length; i++)
                                  _NavLink(
                                    index: i + 1,
                                    label: sections[i],
                                    selected: current == i,
                                    onTap: () => onSelect(i),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(width: 4),
                    const _ThemeToggle(),
                    if (!context.isDesktop)
                      IconButton(
                        tooltip: 'Menu',
                        icon: const Icon(Icons.menu_rounded),
                        onPressed: () => _openMenu(context),
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

  void _openMenu(BuildContext context) {
    final p = context.palette;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < sections.length; i++)
                ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.md)),
                  leading: Text(
                    (i + 1).toString().padLeft(2, '0'),
                    style: TextStyle(fontFamily: AppFonts.mono, color: p.primary),
                  ),
                  title: Text(sections[i], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  trailing: Icon(Icons.arrow_forward_rounded, color: p.textMuted, size: 18),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    onSelect(i);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      button: true,
      label: 'Back to top',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Text.rich(
            TextSpan(children: [
              TextSpan(text: '<', style: TextStyle(color: p.textMuted)),
              TextSpan(text: 'abhishek', style: TextStyle(color: p.textPrimary)),
              TextSpan(text: ' />', style: TextStyle(color: p.primary)),
            ]),
            style: const TextStyle(fontFamily: AppFonts.mono, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({required this.index, required this.label, required this.selected, required this.onTap});

  final int index;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final lit = widget.selected || _hovered;
    return InkWell(
      onTap: widget.onTap,
      onHover: (v) => setState(() => _hovered = v),
      borderRadius: BorderRadius.circular(10),
      hoverColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: '${widget.index.toString().padLeft(2, '0')} ',
                  style: TextStyle(fontFamily: AppFonts.mono, fontSize: 11.5, color: p.primary),
                ),
                TextSpan(text: widget.label),
              ]),
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                color: lit ? p.textPrimary : p.textMuted,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              height: 2,
              width: widget.selected ? 22 : 0,
              decoration: BoxDecoration(
                gradient: p.accentGradient,
                borderRadius: BorderRadius.circular(2),
                boxShadow: [BoxShadow(color: p.primary.withValues(alpha: .6), blurRadius: 8)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context) {
    final controller = ThemeScope.of(context);
    final dark = controller.isDark;
    return IconButton(
      tooltip: dark ? 'Switch to light mode' : 'Switch to dark mode',
      onPressed: controller.toggle,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => RotationTransition(
          turns: Tween(begin: .75, end: 1.0).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        ),
        child: Icon(
          dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          key: ValueKey(dark),
          color: context.palette.primary,
        ),
      ),
    );
  }
}
