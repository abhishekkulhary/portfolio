import 'package:flutter/material.dart';

import '../core/links.dart';
import '../core/responsive.dart';
import '../data/portfolio_data.dart';
import '../theme/app_colors.dart';

/// Set by CI: `--dart-define=APP_VERSION=<tag or commit>`.
const appVersion = String.fromEnvironment('APP_VERSION', defaultValue: 'dev');

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final muted = TextStyle(fontFamily: AppFonts.mono, fontSize: 12.5, color: p.textMuted);

    final items = <Widget>[
      Text('© ${DateTime.now().year} ${PortfolioData.profile.fullName}', style: muted),
      Text.rich(
        TextSpan(children: [
          const TextSpan(text: 'Built with Flutter · '),
          TextSpan(text: appVersion, style: TextStyle(color: p.primary)),
        ]),
        style: muted,
      ),
      InkWell(
        onTap: () => openLink(PortfolioData.repo.sourceUrl),
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Text('view source ↗', style: muted.copyWith(color: p.primary)),
        ),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: ContentWidth(
        child: Column(
          children: [
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [p.primary.withValues(alpha: 0), p.primary.withValues(alpha: .5), p.secondary.withValues(alpha: 0)]),
              ),
            ),
            const SizedBox(height: 28),
            if (context.isMobile)
              Column(children: [for (final w in items) Padding(padding: const EdgeInsets.only(bottom: 10), child: w)])
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: items,
              ),
          ],
        ),
      ),
    );
  }
}
