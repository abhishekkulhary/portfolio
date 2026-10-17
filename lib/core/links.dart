import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/portfolio_data.dart';

/// Opens [url] in a new tab on web and in the default app elsewhere.
Future<void> openLink(String url) async {
  final uri = Uri.parse(url);
  if (uri.scheme == 'mailto') {
    await launchUrl(uri);
    return;
  }
  await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
    webOnlyWindowName: '_blank',
  );
}

/// The CV is bundled as an asset. The web build serves it next to the page;
/// the native apps link to the copy on GitHub Pages.
String resumeUrl() {
  const path = 'assets/${PortfolioData.resumeAsset}';
  return kIsWeb
      ? Uri.base.resolve(path).toString()
      : '${PortfolioData.repo.siteUrl}$path';
}
