import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import '../data/models.dart';

/// Native targets published by `.github/workflows/release.yml`.
enum DownloadPlatform {
  android('Android', 'APK', FontAwesomeIcons.android),
  windows('Windows', 'x64 · ZIP', FontAwesomeIcons.windows),
  macos('macOS', 'Universal · DMG', FontAwesomeIcons.apple),
  linux('Linux', 'x64 · tar.gz', FontAwesomeIcons.linux);

  const DownloadPlatform(this.label, this.format, this.icon);

  final String label;
  final String format;
  final FaIconData icon;

  /// Maps a release asset file name (see release.yml) to its platform.
  static DownloadPlatform? fromAssetName(String fileName) {
    final name = fileName.toLowerCase();
    if (name.endsWith('.apk')) return android;
    if (name.contains('windows')) return windows;
    if (name.contains('macos') || name.endsWith('.dmg')) return macos;
    if (name.contains('linux')) return linux;
    return null;
  }

  /// The platform the visitor is on (on web this reflects the browser's OS).
  static DownloadPlatform? get current => switch (defaultTargetPlatform) {
        TargetPlatform.android => android,
        TargetPlatform.windows => windows,
        TargetPlatform.macOS => macos,
        TargetPlatform.linux => linux,
        _ => null,
      };
}

class ReleaseAsset {
  const ReleaseAsset({required this.name, required this.downloadUrl, required this.sizeBytes});

  final String name;
  final String downloadUrl;
  final int sizeBytes;

  String get sizeLabel => '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}

class LatestRelease {
  const LatestRelease({
    required this.tag,
    required this.pageUrl,
    required this.publishedAt,
    required this.assets,
  });

  final String tag;
  final String pageUrl;
  final DateTime? publishedAt;
  final Map<DownloadPlatform, ReleaseAsset> assets;

  factory LatestRelease.fromJson(Map<String, dynamic> json) {
    final assets = <DownloadPlatform, ReleaseAsset>{};
    for (final raw in (json['assets'] as List? ?? const [])) {
      final asset = raw as Map<String, dynamic>;
      final name = asset['name'] as String;
      final platform = DownloadPlatform.fromAssetName(name);
      if (platform == null) continue;
      assets[platform] = ReleaseAsset(
        name: name,
        downloadUrl: asset['browser_download_url'] as String,
        sizeBytes: (asset['size'] as num?)?.toInt() ?? 0,
      );
    }
    return LatestRelease(
      tag: json['tag_name'] as String? ?? '',
      pageUrl: json['html_url'] as String? ?? '',
      publishedAt: DateTime.tryParse(json['published_at'] as String? ?? ''),
      assets: assets,
    );
  }
}

class GitHubReleases {
  GitHubReleases(this.repo, {http.Client? client}) : _client = client ?? http.Client();

  final RepoConfig repo;
  final http.Client _client;

  /// Null when there is no release yet, the API is rate-limited, or the
  /// visitor is offline — the UI then links to the releases page instead.
  Future<LatestRelease?> fetchLatest() async {
    try {
      final response = await _client
          .get(
            Uri.parse(repo.latestReleaseApi),
            headers: const {'Accept': 'application/vnd.github+json'},
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return null;
      return LatestRelease.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Could not load latest release: $e');
      return null;
    }
  }
}
