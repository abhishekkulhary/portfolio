import 'package:flutter/material.dart';

import 'core/github_releases.dart';
import 'pages/home_page.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key, this.releases});

  /// Overrides the GitHub releases client (used by tests).
  final GitHubReleases? releases;

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  final _theme = ThemeController();

  @override
  void dispose() {
    _theme.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeScope(
      controller: _theme,
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: _theme,
        builder: (context, mode, _) => MaterialApp(
          title: 'Abhishek Choudhary — Full-Stack Software Engineer',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: mode,
          home: HomePage(releases: widget.releases),
        ),
      ),
    );
  }
}
