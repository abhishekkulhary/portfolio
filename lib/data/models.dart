import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profile {
  const Profile({
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.rotatingRoles,
    required this.headline,
    required this.summary,
    required this.statusLine,
    required this.location,
    required this.email,
    this.photoAsset,
  });

  final String firstName;
  final String lastName;
  final String role;

  /// Cycled under the name in the hero.
  final List<String> rotatingRoles;

  /// One-liner under the hero title.
  final String headline;

  /// Paragraphs for the About section.
  final List<String> summary;

  /// Pill above the hero title, e.g. "Open to new roles".
  final String statusLine;
  final String location;
  final String email;

  /// Optional; falls back to initials when null.
  final String? photoAsset;

  String get fullName => '$firstName $lastName';
  String get initials => '${firstName[0]}${lastName[0]}';
}

class Stat {
  const Stat(this.value, this.label);
  final String value;
  final String label;
}

class SocialLink {
  const SocialLink({
    required this.label,
    required this.handle,
    required this.url,
    required this.icon,
  });

  final String label;
  final String handle;
  final String url;
  final FaIconData icon;
}

class FocusArea {
  const FocusArea({required this.title, required this.body, required this.icon});
  final String title;
  final String body;
  final IconData icon;
}

class SkillGroup {
  const SkillGroup({required this.title, required this.icon, required this.items});
  final String title;
  final IconData icon;
  final List<String> items;
}

class Experience {
  const Experience({
    required this.role,
    required this.company,
    required this.location,
    required this.start,
    this.end,
    required this.stack,
    required this.highlights,
  });

  final String role;
  final String company;
  final String location;
  final String start;

  /// Null means "Present".
  final String? end;
  final List<String> stack;
  final List<String> highlights;

  bool get isCurrent => end == null;
  String get period => '$start — ${end ?? 'Present'}';
}

class Education {
  const Education({required this.degree, required this.institution, required this.period});
  final String degree;
  final String institution;
  final String period;
}

class Certification {
  const Certification({required this.name, this.issuer});
  final String name;
  final String? issuer;
}

class SpokenLanguage {
  const SpokenLanguage({required this.name, required this.level, required this.proficiency});
  final String name;
  final String level;

  /// 0–1, drives the level bar.
  final double proficiency;
}

enum ProjectCategory {
  fullStack('Full-Stack'),
  flutter('Flutter'),
  research('Research');

  const ProjectCategory(this.label);
  final String label;
}

class ProjectLink {
  const ProjectLink({required this.label, required this.url, this.icon = FontAwesomeIcons.link});
  final String label;
  final String url;
  final FaIconData icon;
}

class Project {
  const Project({
    required this.title,
    required this.tagline,
    required this.kind,
    required this.description,
    required this.highlights,
    required this.stack,
    required this.categories,
    required this.icon,
    this.year,
    this.links = const [],
  });

  final String title;
  final String tagline;

  /// e.g. "Master's thesis", "Personal app".
  final String kind;
  final String description;
  final List<String> highlights;
  final List<String> stack;
  final Set<ProjectCategory> categories;
  final IconData icon;
  final String? year;
  final List<ProjectLink> links;
}

/// Where the site and its release builds live on GitHub.
class RepoConfig {
  const RepoConfig({required this.owner, required this.name});
  final String owner;
  final String name;

  String get sourceUrl => 'https://github.com/$owner/$name';
  String get releasesUrl => '$sourceUrl/releases';
  String get latestReleaseApi => 'https://api.github.com/repos/$owner/$name/releases/latest';
  String get siteUrl => 'https://$owner.github.io/$name/';
}
