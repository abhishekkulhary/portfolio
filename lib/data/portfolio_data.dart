import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'models.dart';

/// ─────────────────────────────────────────────────────────────────────────
/// All portfolio content lives here. Add a project or a job by appending to
/// the lists below — the UI picks it up automatically.
/// ─────────────────────────────────────────────────────────────────────────
abstract final class PortfolioData {
  static const repo = RepoConfig(owner: 'abhishekkulhary', name: 'portfolio');

  /// Served from the web build and linked from the native apps.
  static const resumeAsset = 'assets/resume/Abhishek-Choudhary-CV.pdf';

  static const profile = Profile(
    firstName: 'Abhishek',
    lastName: 'Choudhary',
    role: 'Full-Stack Software Engineer',
    rotatingRoles: [
      'Full-Stack Software Engineer',
      'Java & Spring back ends',
      'Angular & Flutter front ends',
      'APIs, integrations & data',
    ],
    headline:
        'I build operational software — bookings, billing, integrations — '
        'where correctness and uptime matter more than feature count.',
    summary: [
      'I\'m a full-stack software engineer with 6+ years of building and '
          'modernising production systems in Java, Spring and Angular. Most of '
          'that work is operational software — booking management, invoicing and '
          'customer-maintenance workflows — where a wrong number costs real money '
          'and downtime is noticed immediately.',
      'Beyond enterprise platforms I\'ve built an operator interface for planning '
          'missions and controlling UAVs and ground robots, Python routing services '
          'for railway infrastructure planning, and a growing set of privacy-first '
          'Flutter apps that run on every platform from a single codebase — '
          'including the one you\'re looking at.',
    ],
    statusLine: 'Based in Gummersbach, Germany',
    location: 'Gummersbach, NRW, Germany',
    email: 'abhishekkulhary@gmail.com',
    photoAsset: 'assets/images/profile.jpg',
  );

  static List<Stat> get stats => [
        const Stat('6+', 'years in production'),
        const Stat('4', 'engineering roles'),
        const Stat('3', 'certifications'),
        Stat('${projects.length}', 'projects shown'),
      ];

  static const socials = [
    SocialLink(
      label: 'GitHub',
      handle: '@abhishekkulhary',
      url: 'https://github.com/abhishekkulhary',
      icon: FontAwesomeIcons.github,
    ),
    SocialLink(
      label: 'LinkedIn',
      handle: 'in/abhishekkulhary',
      url: 'https://www.linkedin.com/in/abhishekkulhary',
      icon: FontAwesomeIcons.linkedin,
    ),
    SocialLink(
      label: 'Email',
      handle: 'abhishekkulhary@gmail.com',
      url: 'mailto:abhishekkulhary@gmail.com',
      icon: FontAwesomeIcons.envelope,
    ),
  ];

  static const focusAreas = [
    FocusArea(
      title: 'Correctness first',
      body: 'Billing, invoicing and booking logic where mistakes are expensive. '
          'I trace defects to shared root causes and replace one-off patches '
          'with general fixes.',
      icon: Icons.verified_rounded,
    ),
    FocusArea(
      title: 'Systems that talk',
      body: 'REST and gRPC APIs, MuleSoft and Apigee integrations that move data '
          'between systems that never shared an interface.',
      icon: Icons.hub_rounded,
    ),
    FocusArea(
      title: 'One codebase, every screen',
      body: 'Angular for web platforms and Flutter for mobile and desktop — '
          'responsive, offline-friendly and pleasant to use.',
      icon: Icons.devices_rounded,
    ),
  ];

  static const skills = [
    SkillGroup(
      title: 'Languages',
      icon: Icons.code_rounded,
      items: ['Java', 'Python', 'TypeScript', 'JavaScript', 'SQL', 'Dart', 'HTML', 'CSS'],
    ),
    SkillGroup(
      title: 'Backend',
      icon: Icons.dns_rounded,
      items: ['Spring', 'REST API', 'WebSocket', 'gRPC', 'MuleSoft', 'Apigee', 'Maven'],
    ),
    SkillGroup(
      title: 'Frontend',
      icon: Icons.web_rounded,
      items: ['Angular', 'Flutter'],
    ),
    SkillGroup(
      title: 'Data',
      icon: Icons.storage_rounded,
      items: ['MSSQL', 'Oracle', 'PostgreSQL', 'PostGIS', 'MySQL'],
    ),
    SkillGroup(
      title: 'Tooling & practice',
      icon: Icons.terminal_rounded,
      items: ['Docker', 'Nginx', 'Apache', 'Git', 'GitHub Actions', 'Code review', 'Automated testing', 'Agile delivery'],
    ),
  ];

  static const experience = [
    Experience(
      role: 'Software Developer',
      company: 'Alpha Loop GmbH',
      location: 'Lindlar, Germany',
      start: 'May 2024',
      stack: ['Java', 'Spring', 'Angular', 'REST', 'MSSQL'],
      highlights: [
        'Develop and extend the logistics platform used to manage bookings and '
            'customer maintenance, across the Angular front end and the Java / Spring back end.',
        'Design REST APIs and reusable front-end and back-end components shared '
            'across several modules of the platform.',
        'Investigate and fix production defects and performance bottlenecks '
            'reported by operations staff, reducing recurring incidents.',
      ],
    ),
    Experience(
      role: 'Software Engineer',
      company: 'Kuehne+Nagel',
      location: 'Hamburg, Germany',
      start: 'Aug 2022',
      end: 'Feb 2024',
      stack: ['Java', 'Spring Boot', 'Angular', 'Oracle'],
      highlights: [
        'Rewrote booking-detection logic in the CASS airfreight billing system, '
            'cutting missed and incorrectly billed shipments.',
        'Built the first version of automatic invoice generation, removing a '
            'manual step from the airfreight invoicing process.',
        'Traced recurring profit-share defects to shared root causes and replaced '
            'one-off patches with generalised fixes.',
      ],
    ),
    Experience(
      role: 'Student Research Assistant',
      company: 'TU Braunschweig',
      location: 'Brunswick, Germany',
      start: 'Mar 2020',
      end: 'Mar 2022',
      stack: ['Python', 'REST', 'PostgreSQL', 'PostGIS'],
      highlights: [
        'Built Python REST services powering the planning tools used to route '
            'railway infrastructure.',
        'Implemented PostGIS-backed services that let planners generate and '
            'compare alternative routing variants across the spatial network graph.',
      ],
    ),
    Experience(
      role: 'System Engineer Trainee → System Engineer → Senior System Engineer',
      company: 'Infosys',
      location: 'Pune, India',
      start: 'Jun 2015',
      end: 'Jul 2018',
      stack: ['Java', 'MuleSoft', 'Apigee', 'Middleware'],
      highlights: [
        'Built enterprise integrations in Java, MuleSoft and Apigee to move data '
            'between client systems that had no shared interface.',
        'Ran production support for middleware applications against client SLAs, '
            'diagnosing integration failures to root cause.',
      ],
    ),
  ];

  static const education = [
    Education(
      degree: 'M.Sc. Web Science',
      institution: 'University of Koblenz and Landau',
      period: 'Oct 2018 — Feb 2024',
    ),
    Education(
      degree: 'B.Tech. Computer Science',
      institution: 'SRM University, India',
      period: 'Jun 2011 — Jun 2015',
    ),
  ];

  static const certifications = [
    Certification(name: 'MuleSoft Certified Developer — Integration & API Associate', issuer: 'MuleSoft'),
    Certification(name: 'Oracle Certified Associate — Java SE Programmer I', issuer: 'Oracle'),
    Certification(name: 'Android Application Development'),
  ];

  static const languages = [
    SpokenLanguage(name: 'English', level: 'Fluent', proficiency: .9),
    SpokenLanguage(name: 'German', level: 'A2', proficiency: .35),
    SpokenLanguage(name: 'Hindi', level: 'Native', proficiency: 1),
  ];

  /// To link a project, add e.g.
  /// `links: [ProjectLink(label: 'Source', url: 'https://github.com/…', icon: FontAwesomeIcons.github)]`.
  static const projects = [
    Project(
      title: 'Skyview',
      tagline: 'UAV & ground-robot mission control',
      kind: 'R&D MVP',
      description:
          'An operator interface for planning missions and controlling UAVs and '
          'ground-based robots, plus a cross-platform geocoding package built on '
          'the OpenStreetMap Nominatim API.',
      highlights: [
        'Mission planning and live control from a single operator screen.',
        'Reusable, cross-platform geocoding package on top of OpenStreetMap Nominatim.',
        'Flutter client talking to robot back ends over REST.',
      ],
      stack: ['Flutter', 'Dart', 'REST', 'OpenStreetMap', 'Nominatim'],
      categories: {ProjectCategory.flutter, ProjectCategory.research},
      icon: Icons.flight_takeoff_rounded,
    ),
    Project(
      title: 'IDOHA',
      tagline: 'Image database for humanities research',
      kind: 'Master\'s thesis',
      year: '2024',
      description:
          'A full-stack, annotated image database for humanities researchers, '
          'with a computer-vision pipeline that detects and anonymises people in '
          'uploaded images before they are stored.',
      highlights: [
        'YOLOv4 detection plus DeepPrivacy anonymisation for every uploaded image.',
        'Python services over gRPC and PostgreSQL, documented with Swagger and shipped with Docker Compose.',
        'Flutter web client for browsing, annotating and managing images, users and roles.',
      ],
      stack: ['Flutter', 'Python', 'gRPC', 'PostgreSQL', 'YOLOv4', 'DeepPrivacy', 'Docker'],
      categories: {ProjectCategory.fullStack, ProjectCategory.research},
      icon: Icons.image_search_rounded,
    ),
    Project(
      title: 'Luna',
      tagline: 'Private, on-device cycle tracker',
      kind: 'Personal app',
      description:
          'A privacy-first period and ovulation tracker for iOS, Android, web and '
          'desktop. No account and no server — all health data stays on the device.',
      highlights: [
        'Pure-Dart prediction engine for periods, fertile window and ovulation, independent of Flutter and the database.',
        'Reminders that reschedule themselves whenever predictions change.',
        'PIN (salted SHA-256 in the platform secure store) and biometric app lock.',
        'Insights with cycle-length charts, JSON export and a full data wipe.',
      ],
      stack: ['Flutter', 'Riverpod', 'go_router', 'Drift', 'fl_chart', 'local_auth'],
      categories: {ProjectCategory.flutter},
      icon: Icons.nightlight_round,
    ),
    Project(
      title: 'Chronoflux',
      tagline: 'A Pomodoro timer that never drifts',
      kind: 'Personal app',
      description:
          'A neon-glass Pomodoro timer for mobile, desktop and web. Intervals store '
          'an absolute end time instead of counting ticks, so throttled tabs, '
          'background suspension and sleep can\'t desynchronise the countdown.',
      highlights: [
        'Notifications scheduled with the OS for the end instant, so alerts arrive even when the app is suspended.',
        'Catch-up replays the real timeline: sessions that finished while away are recorded and backdated.',
        'Engine behind an injectable Clock/Ticker, unit-tested for suspension cases.',
      ],
      stack: ['Flutter', 'Riverpod', 'Hive', 'fl_chart', 'flutter_animate'],
      categories: {ProjectCategory.flutter},
      icon: Icons.timer_rounded,
    ),
    Project(
      title: 'Quiet Places',
      tagline: 'Location-aware phone silencer',
      kind: 'Personal app',
      description:
          'Mark the places where your phone should hush — a cinema, an office, a '
          'bedroom — and it silences itself when you arrive and restores the ringer '
          'when you leave.',
      highlights: [
        'Native geofencing, so silencing works while the app is in the background.',
        'Custom Flutter platform plugin (native_ringer) to control the ringer mode.',
        'Map-based place editor with cached map tiles for offline use.',
        'English and German localisation.',
      ],
      stack: ['Flutter', 'Riverpod', 'Drift', 'Geofencing', 'flutter_map', 'Platform channels'],
      categories: {ProjectCategory.flutter},
      icon: Icons.notifications_off_rounded,
    ),
    Project(
      title: 'Einbürgerungstest Trainer',
      tagline: 'Prep for the German citizenship test',
      kind: 'Personal app',
      description:
          'A practice app for the German naturalisation test, built on the official '
          'BAMF question catalogue.',
      highlights: [
        'All 300 general questions plus the 10 state-specific questions for your federal state.',
        'Unlimited mock exams of 33 random questions under real test conditions.',
        'Progress review to find weak areas.',
        'Multilingual interface and question translations; light and dark themes.',
      ],
      stack: ['Flutter', 'Provider', 'Hive', 'Lottie', 'i18n'],
      categories: {ProjectCategory.flutter},
      icon: Icons.school_rounded,
    ),
    Project(
      title: 'Electronic Voting System',
      tagline: 'Polling platform for a university',
      kind: 'University team project',
      description:
          'A polling platform that lets university staff and students run polls, '
          'then analyse, visualise and share the results.',
      highlights: [
        'Create polls and collect votes from staff and students.',
        'Result analysis and visualisation, shareable with participants.',
        'Java EE back end with JPA on Payara and MySQL.',
      ],
      stack: ['Java', 'JPA', 'Payara', 'MySQL', 'JavaScript'],
      categories: {ProjectCategory.fullStack},
      icon: Icons.how_to_vote_rounded,
    ),
    Project(
      title: 'Event Manager',
      tagline: 'Guest list & gift ledger for family events',
      kind: 'Personal app',
      description:
          'An offline app for organising large family events: guest lists grouped by '
          'place and relation, invitation-card distribution and a ledger of gifts '
          'and expenses.',
      highlights: [
        'Guests by place, relation and category, with invitation status.',
        'Money ledger with payment status for every item.',
        'CSV import and export; SQLite storage, no internet required.',
      ],
      stack: ['Flutter', 'SQLite', 'CSV'],
      categories: {ProjectCategory.flutter},
      icon: Icons.celebration_rounded,
    ),
    Project(
      title: 'This portfolio',
      tagline: 'One Flutter codebase, six platforms',
      kind: 'Open source',
      year: '2026',
      description:
          'The site you\'re on. Built with Flutter, deployed to GitHub Pages and '
          'released as native Android, Windows, macOS and Linux apps by GitHub Actions.',
      highlights: [
        'CI builds every platform on a version tag and publishes a GitHub Release.',
        'The Downloads section reads the latest release from the GitHub API at runtime.',
        'Self-hosted fonts and CanvasKit — no third-party requests from the page.',
      ],
      stack: ['Flutter', 'Dart', 'GitHub Actions', 'GitHub Pages'],
      categories: {ProjectCategory.flutter},
      icon: Icons.auto_awesome_rounded,
      links: [
        ProjectLink(
          label: 'Source',
          url: 'https://github.com/abhishekkulhary/portfolio',
          icon: FontAwesomeIcons.github,
        ),
      ],
    ),
  ];
}
