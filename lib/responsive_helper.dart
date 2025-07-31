import 'package:flutter/material.dart';

/// Helper class for responsive design utilities
class ResponsiveHelper {
  // Breakpoints for different device types
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  /// Check if current screen is mobile size
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  /// Check if current screen is tablet size
  static bool isTablet(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  /// Check if current screen is desktop size
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint;

  /// Get current screen width
  static double getScreenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  /// Get current screen height
  static double getScreenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  /// Get current screen aspect ratio
  static double getAspectRatio(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width / size.height;
  }

  /// Check if device is in landscape orientation
  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  /// Check if device is in portrait orientation
  static bool isPortrait(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  /// Get responsive font size based on screen width
  static double getResponsiveFontSize(
    BuildContext context, {
    double mobileSize = 14,
    double tabletSize = 16,
    double desktopSize = 18,
  }) {
    if (isMobile(context)) return mobileSize;
    if (isTablet(context)) return tabletSize;
    return desktopSize;
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(
    BuildContext context, {
    double mobilePadding = 16,
    double tabletPadding = 24,
    double desktopPadding = 32,
  }) {
    double padding;
    if (isMobile(context)) {
      padding = mobilePadding;
    } else if (isTablet(context)) {
      padding = tabletPadding;
    } else {
      padding = desktopPadding;
    }
    return EdgeInsets.all(padding);
  }

  /// Get responsive margin based on screen size
  static EdgeInsets getResponsiveMargin(
    BuildContext context, {
    double mobileMargin = 8,
    double tabletMargin = 16,
    double desktopMargin = 24,
  }) {
    double margin;
    if (isMobile(context)) {
      margin = mobileMargin;
    } else if (isTablet(context)) {
      margin = tabletMargin;
    } else {
      margin = desktopMargin;
    }
    return EdgeInsets.all(margin);
  }

  /// Get responsive spacing between elements
  static double getResponsiveSpacing(
    BuildContext context, {
    double mobileSpacing = 8,
    double tabletSpacing = 16,
    double desktopSpacing = 24,
  }) {
    if (isMobile(context)) return mobileSpacing;
    if (isTablet(context)) return tabletSpacing;
    return desktopSpacing;
  }

  /// Get number of columns for grid based on screen size
  static int getResponsiveGridColumns(
    BuildContext context, {
    int mobileColumns = 1,
    int tabletColumns = 2,
    int desktopColumns = 3,
  }) {
    if (isMobile(context)) return mobileColumns;
    if (isTablet(context)) return tabletColumns;
    return desktopColumns;
  }

  /// Get responsive container width as percentage of screen width
  static double getResponsiveWidth(
    BuildContext context, {
    double mobilePercentage = 0.9,
    double tabletPercentage = 0.8,
    double desktopPercentage = 0.7,
  }) {
    double percentage;
    if (isMobile(context)) {
      percentage = mobilePercentage;
    } else if (isTablet(context)) {
      percentage = tabletPercentage;
    } else {
      percentage = desktopPercentage;
    }
    return MediaQuery.of(context).size.width * percentage;
  }

  /// Get responsive container height as percentage of screen height
  static double getResponsiveHeight(
    BuildContext context, {
    double mobilePercentage = 0.8,
    double tabletPercentage = 0.7,
    double desktopPercentage = 0.6,
  }) {
    double percentage;
    if (isMobile(context)) {
      percentage = mobilePercentage;
    } else if (isTablet(context)) {
      percentage = tabletPercentage;
    } else {
      percentage = desktopPercentage;
    }
    return MediaQuery.of(context).size.height * percentage;
  }
}
