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
| `portfolio-android.apk` | Signed with your release key when the four `ANDROID_*` secrets are set, so each release installs over the last one (see [Android signing](#android-signing)). Without them CI signs with a throwaway debug key and logs a warning; users then have to uninstall before updating. |
| `portfolio-windows-x64.zip` | Includes the MSVC runtime DLLs; unzip and run `portfolio.exe`. |
| `portfolio-macos.dmg` | Universal, ad-hoc signed (no Apple Developer ID): allow it under *System Settings → Privacy & Security* on first launch. |
| `portfolio-linux-x64.tar.gz` | Built on Ubuntu 24.04; extract and run `./portfolio`. |

### Android signing

Android only lets an APK replace an installed app if both are signed with the same key. Create the key once and keep it safe: **if you lose it, users cannot update in place again.** Never commit it. `android/key.properties`, `*.jks` and `*.keystore` are git-ignored.

1. **Create the keystore** (outside the repo; `keytool` comes with any JDK):

   ```bash
   keytool -genkeypair -v -keystore ~/portfolio-release.jks -storetype PKCS12 \
     -keyalg RSA -keysize 4096 -validity 10000 -alias portfolio
   ```

   It asks for a password and your name/organisation. PKCS12 uses one password for both the store and the key. Avoid backslashes in it, because `key.properties` is a Java properties file.

2. **Base64-encode it** for the secret:

   ```bash
   base64 -i ~/portfolio-release.jks | pbcopy        # macOS; Linux: base64 -w0 ~/portfolio-release.jks
   ```

3. **Add four repository secrets** under *Settings → Secrets and variables → Actions → New repository secret*:

   | Secret | Value |
   | --- | --- |
   | `ANDROID_KEYSTORE_BASE64` | the base64 text from step 2 |
   | `ANDROID_KEYSTORE_PASSWORD` | the keystore password |
   | `ANDROID_KEY_ALIAS` | `portfolio` (the `-alias` above) |
   | `ANDROID_KEY_PASSWORD` | the same password (PKCS12) |

   Or, with the GitHub CLI: `base64 -i ~/portfolio-release.jks | gh secret set ANDROID_KEYSTORE_BASE64`, and `gh secret set <NAME>` for the other three (it prompts for the value).

4. **Optional: sign local release builds too.** Create `android/key.properties`:

   ```properties
   storeFile=/Users/you/portfolio-release.jks
   storePassword=…
   keyAlias=portfolio
   keyPassword=…
   ```

   `storeFile` can be absolute or relative to `android/`. Without this file, `flutter build apk --release` uses the debug key.

The release log prints the APK's certificate SHA-256 after each build; it should be the same every time. The first release signed with the new key still needs a one-time uninstall on devices that have a debug-signed build.

## Implementation notes

- **No third-party requests from the page.** Fonts (Space Grotesk, JetBrains Mono — both OFL, licences in `assets/fonts/`) are bundled and CanvasKit is self-hosted (`--no-web-resources-cdn`). The only external call is the GitHub API for the latest release.
- **`--no-tree-shake-icons`** is passed to every build: Flutter's icon tree-shaker misses Font Awesome icons referenced from const data, which would otherwise render as empty boxes.
- Responsive breakpoints: < 720 px mobile, < 1100 px tablet, desktop above. Animations respect the OS *reduce motion* setting.
