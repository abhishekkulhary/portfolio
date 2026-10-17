import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:portfolio/app.dart';
import 'package:portfolio/core/github_releases.dart';
import 'package:portfolio/data/portfolio_data.dart';

GitHubReleases _fakeReleases({int status = 404, Map<String, dynamic>? body}) => GitHubReleases(
      PortfolioData.repo,
      client: MockClient((_) async => http.Response(jsonEncode(body ?? {}), status)),
    );

Future<void> _pumpApp(WidgetTester tester, Size size, {GitHubReleases? releases}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(PortfolioApp(releases: releases ?? _fakeReleases()));
  // Endless decorative animations mean pumpAndSettle would never return.
  await tester.pump(const Duration(seconds: 2));
}

/// Fails with the full render diagnostics (which widget, which constraints).
void _expectNoLayoutErrors(WidgetTester tester) {
  final error = tester.takeException();
  expect(error, isNull, reason: error is FlutterError ? error.toStringDeep() : '$error');
}

void main() {
  testWidgets('renders hero and every section on desktop', (tester) async {
    await _pumpApp(tester, const Size(1440, 900));

    expect(find.text('Abhishek\nChoudhary'), findsOneWidget);
    for (final label in ['About', 'Skills', 'Experience', 'Projects', 'Downloads', 'Contact']) {
      expect(find.textContaining(label, findRichText: true), findsWidgets, reason: 'nav link $label');
    }
    expect(find.byType(Scrollable), findsWidgets);
    _expectNoLayoutErrors(tester);
  });

  testWidgets('lays out on a phone without overflow', (tester) async {
    await _pumpApp(tester, const Size(390, 844));

    expect(find.byTooltip('Menu'), findsOneWidget);
    await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -6000));
    await tester.pump(const Duration(seconds: 1));
    _expectNoLayoutErrors(tester);
  });

  testWidgets('theme toggle switches to light mode', (tester) async {
    await _pumpApp(tester, const Size(1440, 900));

    await tester.tap(find.byTooltip('Switch to light mode'));
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.byTooltip('Switch to dark mode'), findsOneWidget);
  });

  test('maps release assets to platforms', () {
    final release = LatestRelease.fromJson({
      'tag_name': 'v1.2.0',
      'html_url': 'https://github.com/abhishekkulhary/portfolio/releases/tag/v1.2.0',
      'published_at': '2026-10-17T12:00:00Z',
      'assets': [
        for (final name in [
          'portfolio-android.apk',
          'portfolio-windows-x64.zip',
          'portfolio-macos.dmg',
          'portfolio-linux-x64.tar.gz',
          'checksums.txt',
        ])
          {'name': name, 'browser_download_url': 'https://example.com/$name', 'size': 1048576},
      ],
    });

    expect(release.tag, 'v1.2.0');
    expect(release.assets.keys, unorderedEquals(DownloadPlatform.values));
    expect(release.assets[DownloadPlatform.macos]!.name, 'portfolio-macos.dmg');
    expect(release.assets[DownloadPlatform.android]!.sizeLabel, '1.0 MB');
  });

  test('missing release yields null instead of throwing', () async {
    expect(await _fakeReleases(status: 404).fetchLatest(), isNull);
  });
}
