# Abhishek Choudhary — Portfolio

A futuristic, single-codebase portfolio built with **Flutter**. The same app is

- **the website** — deployed to GitHub Pages at <https://abhishekkulhary.github.io/portfolio/>, and
- **native apps** — Android, Windows, macOS and Linux builds attached to every GitHub Release and linked from the site's *Downloads* section.

## Editing content

Everything shown on the site lives in **[`lib/data/portfolio_data.dart`](lib/data/portfolio_data.dart)** — profile, stats, skills, experience, education, certifications, languages and projects. Append to a list and the UI picks it up; no widget changes needed.

```dart
Project(
  title: 'My new project',
  tagline: 'One-line pitch',
  kind: 'Personal app',
  description: 'What it is and why it matters.',
  highlights: ['A concrete result', 'An interesting technical decision'],
  stack: ['Flutter', 'Spring Boot'],
  categories: {ProjectCategory.fullStack},
  icon: Icons.rocket_launch_rounded,
  links: [ProjectLink(label: 'Source', url: 'https://github.com/…', icon: FontAwesomeIcons.github)],
),
```

Other assets: `assets/images/profile.jpg` (hero photo), `assets/resume/Abhishek-Choudhary-CV.pdf` (the *Download CV* button). Colours are tokens in [`lib/theme/app_colors.dart`](lib/theme/app_colors.dart).

## Run locally

```bash
flutter pub get
flutter run -d chrome        # or: -d macos
flutter analyze && flutter test
```

## Deploy

### Website (automatic)
[`.github/workflows/deploy-web.yml`](.github/workflows/deploy-web.yml) runs on every push to `main`: analyze → test → `flutter build web` → GitHub Pages.

One-time setup: **Settings → Pages → Build and deployment → Source: GitHub Actions**.

### Native apps (on a version tag)
[`.github/workflows/release.yml`](.github/workflows/release.yml) builds all four platforms in parallel and publishes a GitHub Release:

```bash
git tag v1.0.0
git push origin v1.0.0
```

It can also be started from the **Actions** tab with a tag name. The site reads the latest release from the GitHub API, so download buttons update automatically.

| Asset | Notes |
| --- | --- |
| `portfolio-android.apk` | Signed with a CI-generated debug key — installable, but each release needs an uninstall before updating until a release keystore is configured. |
| `portfolio-windows-x64.zip` | Includes the MSVC runtime DLLs; unzip and run `portfolio.exe`. |
| `portfolio-macos.dmg` | Universal, ad-hoc signed (no Apple Developer ID): allow it under *System Settings → Privacy & Security* on first launch. |
| `portfolio-linux-x64.tar.gz` | Built on Ubuntu 24.04; extract and run `./portfolio`. |

## Implementation notes

- **No third-party requests from the page.** Fonts (Space Grotesk, JetBrains Mono — both OFL, licences in `assets/fonts/`) are bundled and CanvasKit is self-hosted (`--no-web-resources-cdn`). The only external call is the GitHub API for the latest release.
- **`--no-tree-shake-icons`** is passed to every build: Flutter's icon tree-shaker misses Font Awesome icons referenced from const data, which would otherwise render as empty boxes.
- Responsive breakpoints: < 720 px mobile, < 1100 px tablet, desktop above. Animations respect the OS *reduce motion* setting.
