import 'package:flutter/widgets.dart';

enum ScreenSize { mobile, tablet, desktop }

extension ResponsiveContext on BuildContext {
  ScreenSize get screenSize {
    final width = MediaQuery.sizeOf(this).width;
    if (width < 720) return ScreenSize.mobile;
    if (width < 1100) return ScreenSize.tablet;
    return ScreenSize.desktop;
  }

  bool get isMobile => screenSize == ScreenSize.mobile;
  bool get isDesktop => screenSize == ScreenSize.desktop;

  /// Picks a value per breakpoint; [tablet] falls back to [mobile].
  T responsive<T>({required T mobile, T? tablet, required T desktop}) =>
      switch (screenSize) {
        ScreenSize.mobile => mobile,
        ScreenSize.tablet => tablet ?? mobile,
        ScreenSize.desktop => desktop,
      };
}

abstract final class Layout {
  static const double maxContentWidth = 1160;
  static const double navHeight = 64;

  static double gutter(BuildContext context) =>
      context.responsive(mobile: 20, tablet: 32, desktop: 40);
}

/// Centres content at [Layout.maxContentWidth] with responsive side gutters.
class ContentWidth extends StatelessWidget {
  const ContentWidth({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Layout.maxContentWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Layout.gutter(context)),
          child: child,
        ),
      ),
    );
  }
}

/// Lays children out in equal-height rows, as many columns as fit
/// [minItemWidth]. Children must not contain a LayoutBuilder (rows use
/// IntrinsicHeight to equalise card heights).
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.minItemWidth = 300,
    this.maxColumns = 4,
    this.spacing = 20,
  });

  final List<Widget> children;
  final double minItemWidth;
  final int maxColumns;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final fit = ((constraints.maxWidth + spacing) / (minItemWidth + spacing)).floor();
      final columns = fit.clamp(1, maxColumns);
      final rows = <Widget>[];
      for (var i = 0; i < children.length; i += columns) {
        final cells = <Widget>[];
        for (var c = 0; c < columns; c++) {
          if (c > 0) cells.add(SizedBox(width: spacing));
          final index = i + c;
          cells.add(Expanded(
            child: index < children.length ? children[index] : const SizedBox.shrink(),
          ));
        }
        if (rows.isNotEmpty) rows.add(SizedBox(height: spacing));
        rows.add(IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: cells),
        ));
      }
      return Column(children: rows);
    });
  }
}
