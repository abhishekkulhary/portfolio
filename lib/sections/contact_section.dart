import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final theme = Theme.of(context);
    final email = PortfolioData.profile.email;

    return SectionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(index: 6, eyebrow: 'contact', title: 'Get in touch'),
          const SizedBox(height: 40),
          Reveal(
            child: GlassCard(
              blur: true,
              padding: EdgeInsets.all(context.responsive<double>(mobile: 26, desktop: 56)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GradientText(
                    'Let\'s build something reliable.',
                    style: (context.isMobile ? theme.textTheme.headlineLarge : theme.textTheme.displayMedium)!,
                  ),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: Text(
                      'Whether it\'s a back end that has to be right, an integration that has to hold, '
                      'or an app that has to run everywhere — my inbox is open.',
                      style: theme.textTheme.bodyLarge!.copyWith(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    children: [
                      AccentButton(
                        label: 'Say hello',
                        icon: const FaIcon(FontAwesomeIcons.paperPlane),
                        onPressed: () => openLink('mailto:$email'),
                      ),
                      AccentButton(
                        label: 'Copy email',
                        icon: const Icon(Icons.copy_rounded),
                        filled: false,
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: email));
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Copied $email'), duration: const Duration(seconds: 2)),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Divider(color: p.glassBorder, height: 1),
                  const SizedBox(height: 28),
                  ResponsiveGrid(
                    minItemWidth: 240,
                    maxColumns: 3,
                    spacing: 14,
                    children: [
                      for (var i = 0; i < PortfolioData.socials.length; i++)
                        Reveal(delay: (i * 80).ms, child: _SocialTile(link: PortfolioData.socials[i])),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialTile extends StatelessWidget {
  const _SocialTile({required this.link});

  final SocialLink link;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return GlassCard(
      hoverGlow: true,
      radius: AppRadii.md,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      semanticLabel: '${link.label}: ${link.handle}',
      onTap: () => openLink(link.url),
      child: Row(
        children: [
          FaIcon(link.icon, size: 22, color: p.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(link.label, style: TextStyle(fontWeight: FontWeight.w700, color: p.textPrimary)),
                Text(
                  link.handle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontFamily: AppFonts.mono, fontSize: 12, color: p.textMuted),
                ),
              ],
            ),
          ),
          Icon(Icons.north_east_rounded, size: 18, color: p.textMuted),
        ],
      ),
    );
  }
}
