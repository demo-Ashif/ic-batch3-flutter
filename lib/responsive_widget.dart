import 'package:flutter/material.dart';
import 'responsive_helper.dart';

/// A widget that displays different layouts based on screen size
/// This is an example of adaptive design approach
class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveWidget({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use desktop layout if available and screen is desktop size
        if (constraints.maxWidth >= ResponsiveHelper.tabletBreakpoint) {
          return desktop ?? tablet ?? mobile;
        }
        // Use tablet layout if available and screen is tablet size
        else if (constraints.maxWidth >= ResponsiveHelper.mobileBreakpoint) {
          return tablet ?? mobile;
        }
        // Use mobile layout for smaller screens
        else {
          return mobile;
        }
      },
    );
  }
}

/// A responsive text widget that adjusts font size based on screen size
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ResponsiveText({
    Key? key,
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fontSize = ResponsiveHelper.getResponsiveFontSize(context);

    return Text(
      text,
      style:
          style?.copyWith(fontSize: fontSize) ?? TextStyle(fontSize: fontSize),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// A responsive container that adjusts its size based on screen dimensions
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? widthPercentage;
  final double? heightPercentage;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final AlignmentGeometry? alignment;

  const ResponsiveContainer({
    Key? key,
    required this.child,
    this.widthPercentage,
    this.heightPercentage,
    this.padding,
    this.margin,
    this.decoration,
    this.alignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? width;
    double? height;

    if (widthPercentage != null) {
      width = MediaQuery.of(context).size.width * widthPercentage!;
    }

    if (heightPercentage != null) {
      height = MediaQuery.of(context).size.height * heightPercentage!;
    }

    return Container(
      width: width,
      height: height,
      padding: padding ?? ResponsiveHelper.getResponsivePadding(context),
      margin: margin ?? ResponsiveHelper.getResponsiveMargin(context),
      decoration: decoration,
      alignment: alignment,
      child: child,
    );
  }
}

/// A responsive grid that adjusts column count based on screen size
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;

  const ResponsiveGrid({
    Key? key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = ResponsiveHelper.getResponsiveGridColumns(
      context,
      mobileColumns: mobileColumns ?? 1,
      tabletColumns: tabletColumns ?? 2,
      desktopColumns: desktopColumns ?? 3,
    );

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: runSpacing,
        childAspectRatio: 1.0,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// A responsive card that adjusts its appearance based on screen size
class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final Color? color;
  final BorderRadius? borderRadius;

  const ResponsiveCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.color,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double responsiveElevation = ResponsiveHelper.isMobile(context) ? 2.0 : 4.0;
    EdgeInsets responsivePadding = ResponsiveHelper.getResponsivePadding(
      context,
    );
    EdgeInsets responsiveMargin = ResponsiveHelper.getResponsiveMargin(context);

    return Card(
      elevation: elevation ?? responsiveElevation,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
      margin: margin ?? responsiveMargin,
      child: Padding(padding: padding ?? responsivePadding, child: child),
    );
  }
}

/// A responsive button that adjusts its size based on screen size
class ResponsiveButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? widthPercentage;
  final double? height;

  const ResponsiveButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.widthPercentage,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double buttonHeight =
        height ?? (ResponsiveHelper.isMobile(context) ? 48.0 : 56.0);
    double? buttonWidth =
        widthPercentage != null
            ? MediaQuery.of(context).size.width * widthPercentage!
            : null;

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[icon!, const SizedBox(width: 8)],
            ResponsiveText(
              text: text,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
