import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../core/github_releases.dart';
import '../core/links.dart';
import '../core/responsive.dart';
import '../data/portfolio_data.dart';
import '../theme/app_colors.dart';
import '../widgets/accent_button.dart';
import '../widgets/glass_card.dart';
import '../widgets/reveal.dart';
import '../widgets/section_header.dart';
import '../widgets/tech_chip.dart';

class DownloadsSection extends StatefulWidget {
  const DownloadsSection({super.key, this.releases});

  /// Injectable for tests; defaults to the live GitHub API.
  final GitHubReleases? releases;

  @override
  State<DownloadsSection> createState() => _DownloadsSectionState();
}

class _DownloadsSectionState extends State<DownloadsSection> {
  late final Future<LatestRelease?> _latest =
      (widget.releases ?? GitHubReleases(PortfolioData.repo)).fetchLatest();

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            index: 5,
            eyebrow: 'downloads',
            title: 'Take it with you',
            subtitle: 'This portfolio is a Flutter app — the same code ships to every platform. '
                'GitHub Actions builds the native versions on each release.',
          ),
          const SizedBox(height: 40),
          FutureBuilder<LatestRelease?>(
            future: _latest,
            builder: (context, snapshot) {
              final loading = snapshot.connectionState != ConnectionState.done;
              final release = snapshot.data;
              return Column(
                children: [
                  ResponsiveGrid(
                    minItemWidth: 230,
                    maxColumns: 4,
                    children: [
                      for (var i = 0; i < DownloadPlatform.values.length; i++)
                        Reveal(
                          delay: (i * 80).ms,
                          child: _PlatformCard(
                            platform: DownloadPlatform.values[i],
                            release: release,
                            loading: loading,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ResponsiveGrid(
                    minItemWidth: 340,
                    maxColumns: 2,
                    children: [
                      const Reveal(child: _ResumeCard()),
                      Reveal(delay: 80.ms, child: _ReleaseInfoCard(release: release, loading: loading)),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PlatformCard extends StatelessWidget {
  const _PlatformCard({required this.platform, required this.release, required this.loading});

  final DownloadPlatform platform;
  final LatestRelease? release;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final asset = release?.assets[platform];
    final isCurrent = DownloadPlatform.current == platform;

    final String status;
    if (loading) {
      status = 'checking latest release…';
    } else if (asset != null) {
      status = '${release!.tag} · ${asset.sizeLabel}';
    } else {
      status = 'not published yet';
    }

    return GlassCard(
      hoverGlow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (b) => p.accentGradient.createShader(Offset.zero & b.size),
                child: FaIcon(platform.icon, size: 34, color: Colors.white),
              ),
              const Spacer(),
              if (isCurrent) const LabelPill('Your device'),
            ],
          ),
          const SizedBox(height: 18),
          Text(platform.label, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 2),
          Text(platform.format, style: TextStyle(fontFamily: AppFonts.mono, fontSize: 12.5, color: p.textMuted)),
          const SizedBox(height: 10),
          Text(
            status,
            style: TextStyle(fontFamily: AppFonts.mono, fontSize: 12, color: asset != null ? p.primary : p.textMuted),
          ),
          if (platform == DownloadPlatform.macos) ...[
            const SizedBox(height: 8),
            Text(
              'Unsigned build — on first launch, allow it under System Settings › Privacy & Security.',
              style: TextStyle(fontSize: 12, color: p.textMuted, height: 1.45),
            ),
          ],
          const Spacer(),
          const SizedBox(height: 18),
          AccentButton(
            compact: true,
            filled: asset != null && isCurrent,
            label: asset != null ? 'Download' : 'View releases',
            icon: Icon(asset != null ? Icons.download_rounded : Icons.open_in_new_rounded),
            onPressed: loading ? null : () => openLink(asset?.downloadUrl ?? PortfolioData.repo.releasesUrl),
          ),
        ],
      ),
    );
  }
}

class _ResumeCard extends StatelessWidget {
  const _ResumeCard();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return GlassCard(
      hoverGlow: true,
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: p.accentGradient,
              borderRadius: BorderRadius.circular(AppRadii.md),
              boxShadow: [BoxShadow(color: p.primary.withValues(alpha: .35), blurRadius: 18, spreadRadius: -4)],
            ),
            child: Center(child: FaIcon(FontAwesomeIcons.filePdf, color: p.onAccent, size: 24)),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Curriculum vitae', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 2),
                Text('PDF · one page', style: TextStyle(fontFamily: AppFonts.mono, fontSize: 12.5, color: p.textMuted)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          AccentButton(
            compact: true,
            label: 'Get CV',
            icon: const Icon(Icons.download_rounded),
            onPressed: () => openLink(resumeUrl()),
          ),
        ],
      ),
    );
  }
}

class _ReleaseInfoCard extends StatelessWidget {
  const _ReleaseInfoCard({required this.release, required this.loading});

  final LatestRelease? release;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final published = release?.publishedAt;
    final detail = loading
        ? 'Asking GitHub for the latest build…'
        : release == null
            ? 'Builds appear here automatically once the first release is tagged.'
            : 'Latest: ${release!.tag}${published != null ? ' · ${_formatDate(published)}' : ''}';

    return GlassCard(
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: p.glass,
              border: Border.all(color: p.glassBorder),
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: Center(child: FaIcon(FontAwesomeIcons.github, color: p.textPrimary, size: 24)),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Built by GitHub Actions', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 2),
                Text(detail, style: TextStyle(fontFamily: AppFonts.mono, fontSize: 12.5, color: p.textMuted)),
              ],
            ),
          ),
          if (!context.isMobile) ...[
            const SizedBox(width: 12),
            AccentButton(
              compact: true,
              filled: false,
              label: 'All releases',
              icon: const Icon(Icons.open_in_new_rounded),
              onPressed: () => openLink(PortfolioData.repo.releasesUrl),
            ),
          ],
        ],
      ),
    );
  }

  static String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final local = date.toLocal();
    return '${local.day} ${months[local.month - 1]} ${local.year}';
  }
}
