import 'package:flutter/material.dart';
import 'responsive_helper.dart';
import 'responsive_widget.dart';

/// Comprehensive examples of MediaQuery usage and responsive design patterns
/// This demonstrates various techniques for creating responsive layouts
class MediaQueryExamples extends StatelessWidget {
  const MediaQueryExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ResponsiveText(
          text: 'MediaQuery & Responsive Patterns',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: ResponsiveHelper.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MediaQuery Information
            _buildMediaQueryInfo(context),

            const SizedBox(height: 24),

            // Responsive Layout Patterns
            _buildResponsivePatterns(context),

            const SizedBox(height: 24),

            // Orientation Examples
            _buildOrientationExamples(context),

            const SizedBox(height: 24),

            // Responsive Typography
            _buildResponsiveTypography(context),

            const SizedBox(height: 24),

            // Responsive Spacing
            _buildResponsiveSpacing(context),

            const SizedBox(height: 24),

            // Responsive Images
            _buildResponsiveImages(context),
          ],
        ),
      ),
    );
  }

  /// Display current MediaQuery information
  Widget _buildMediaQueryInfo(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final orientation = mediaQuery.orientation;
    final pixelRatio = mediaQuery.devicePixelRatio;
    final padding = mediaQuery.padding;
    final viewInsets = mediaQuery.viewInsets;

    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResponsiveText(
            text: 'MediaQuery Information',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),

          _buildInfoRow('Screen Width', '${size.width.toStringAsFixed(1)} px'),
          _buildInfoRow(
            'Screen Height',
            '${size.height.toStringAsFixed(1)} px',
          ),
          _buildInfoRow(
            'Aspect Ratio',
            '${(size.width / size.height).toStringAsFixed(2)}',
          ),
          _buildInfoRow('Orientation', orientation.name),
          _buildInfoRow('Pixel Ratio', pixelRatio.toStringAsFixed(2)),
          _buildInfoRow('Top Padding', '${padding.top.toStringAsFixed(1)} px'),
          _buildInfoRow(
            'Bottom Padding',
            '${padding.bottom.toStringAsFixed(1)} px',
          ),
          _buildInfoRow(
            'View Insets Bottom',
            '${viewInsets.bottom.toStringAsFixed(1)} px',
          ),

          const SizedBox(height: 16),

          // Device type detection
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getDeviceTypeColor(context).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _getDeviceTypeColor(context).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getDeviceTypeIcon(context),
                  color: _getDeviceTypeColor(context),
                ),
                const SizedBox(width: 8),
                ResponsiveText(
                  text: 'Device Type: ${_getDeviceTypeText(context)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getDeviceTypeColor(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ResponsiveText(
            text: label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          ResponsiveText(
            text: value,
            style: TextStyle(color: Colors.grey[600], fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }

  Color _getDeviceTypeColor(BuildContext context) {
    if (ResponsiveHelper.isMobile(context)) return Colors.green;
    if (ResponsiveHelper.isTablet(context)) return Colors.orange;
    return Colors.blue;
  }

  IconData _getDeviceTypeIcon(BuildContext context) {
    if (ResponsiveHelper.isMobile(context)) return Icons.phone_android;
    if (ResponsiveHelper.isTablet(context)) return Icons.tablet_android;
    return Icons.desktop_windows;
  }

  String _getDeviceTypeText(BuildContext context) {
    if (ResponsiveHelper.isMobile(context)) return 'Mobile';
    if (ResponsiveHelper.isTablet(context)) return 'Tablet';
    return 'Desktop';
  }

  /// Responsive Layout Patterns
  Widget _buildResponsivePatterns(BuildContext context) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResponsiveText(
            text: 'Responsive Layout Patterns',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),

          // Pattern 1: Flexible Sizing
          _buildPatternExample(
            context,
            'Flexible Sizing',
            'Container width adapts to screen size',
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: const Center(
                child: ResponsiveText(
                  text: '80% of screen width',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Pattern 2: Conditional Layout
          _buildPatternExample(
            context,
            'Conditional Layout',
            'Different layouts based on screen size',
            ResponsiveWidget(
              mobile: _buildLayoutItem(
                'Mobile Layout',
                Colors.green,
                Icons.phone_android,
              ),
              tablet: Row(
                children: [
                  Expanded(
                    child: _buildLayoutItem(
                      'Tablet Left',
                      Colors.orange,
                      Icons.tablet_android,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildLayoutItem(
                      'Tablet Right',
                      Colors.orange,
                      Icons.tablet,
                    ),
                  ),
                ],
              ),
              desktop: Row(
                children: [
                  Expanded(
                    child: _buildLayoutItem(
                      'Desktop Left',
                      Colors.blue,
                      Icons.desktop_windows,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildLayoutItem(
                      'Desktop Center',
                      Colors.blue,
                      Icons.web,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildLayoutItem(
                      'Desktop Right',
                      Colors.blue,
                      Icons.desktop_mac,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Pattern 3: Aspect Ratio
          _buildPatternExample(
            context,
            'Aspect Ratio',
            'Maintains 16:9 aspect ratio',
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple.withOpacity(0.6),
                      Colors.pink.withOpacity(0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: ResponsiveText(
                    text: '16:9 Aspect Ratio',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatternExample(
    BuildContext context,
    String title,
    String description,
    Widget example,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveText(
          text: title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        ResponsiveText(
          text: description,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        const SizedBox(height: 8),
        example,
      ],
    );
  }

  Widget _buildLayoutItem(String title, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          ResponsiveText(
            text: title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Orientation Examples
  Widget _buildOrientationExamples(BuildContext context) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResponsiveText(
            text: 'Orientation Examples',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),

          // Orientation Builder
          OrientationBuilder(
            builder: (context, orientation) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      orientation == Orientation.portrait
                          ? Colors.green.withOpacity(0.1)
                          : Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        orientation == Orientation.portrait
                            ? Colors.green.withOpacity(0.3)
                            : Colors.blue.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      orientation == Orientation.portrait
                          ? Icons.screen_lock_portrait
                          : Icons.screen_lock_landscape,
                      color:
                          orientation == Orientation.portrait
                              ? Colors.green
                              : Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ResponsiveText(
                        text: 'Current Orientation: ${orientation.name}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              orientation == Orientation.portrait
                                  ? Colors.green
                                  : Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Responsive layout based on orientation
          ResponsiveWidget(
            mobile: Column(
              children: [
                _buildOrientationItem(
                  'Portrait Layout',
                  Colors.green,
                  Icons.screen_lock_portrait,
                ),
                const SizedBox(height: 8),
                _buildOrientationItem(
                  'Stacked Items',
                  Colors.green,
                  Icons.view_column,
                ),
              ],
            ),
            tablet: Row(
              children: [
                Expanded(
                  child: _buildOrientationItem(
                    'Landscape Left',
                    Colors.blue,
                    Icons.screen_lock_landscape,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildOrientationItem(
                    'Landscape Right',
                    Colors.blue,
                    Icons.screen_rotation,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrientationItem(String title, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          ResponsiveText(
            text: title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Responsive Typography
  Widget _buildResponsiveTypography(BuildContext context) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResponsiveText(
            text: 'Responsive Typography',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),

          // Different font sizes based on screen size
          ResponsiveText(
            text: 'This text adapts to screen size',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context),
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          ResponsiveText(
            text: 'Mobile: 14px, Tablet: 16px, Desktop: 18px',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobileSize: 12,
                tabletSize: 14,
                desktopSize: 16,
              ),
              color: Colors.grey[600],
            ),
          ),

          const SizedBox(height: 16),

          // Responsive text alignment
          ResponsiveWidget(
            mobile: const ResponsiveText(
              text: 'Mobile: Centered text for better readability',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            tablet: const ResponsiveText(
              text: 'Tablet: Left-aligned text with more space',
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            desktop: const ResponsiveText(
              text: 'Desktop: Justified text for professional look',
              textAlign: TextAlign.justify,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  /// Responsive Spacing
  Widget _buildResponsiveSpacing(BuildContext context) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResponsiveText(
            text: 'Responsive Spacing',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),

          // Responsive padding
          Container(
            padding: ResponsiveHelper.getResponsivePadding(context),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: const ResponsiveText(
              text: 'Container with responsive padding',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),

          const SizedBox(height: 16),

          // Responsive margin
          Container(
            margin: ResponsiveHelper.getResponsiveMargin(context),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.teal.withOpacity(0.3)),
            ),
            child: const ResponsiveText(
              text: 'Container with responsive margin',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),

          const SizedBox(height: 16),

          // Responsive spacing between elements
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: const Center(
                    child: ResponsiveText(
                      text: 'Item 1',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context)),
              Expanded(
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: const Center(
                    child: ResponsiveText(
                      text: 'Item 2',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Responsive Images
  Widget _buildResponsiveImages(BuildContext context) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResponsiveText(
            text: 'Responsive Images',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),

          // Responsive image container
          ResponsiveContainer(
            widthPercentage: ResponsiveHelper.isMobile(context) ? 1.0 : 0.8,
            heightPercentage: 0.3,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: ResponsiveText(
                text: 'Responsive Image Placeholder\nAdapts to screen size',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Responsive grid of images
          ResponsiveGrid(
            children: [
              _buildImagePlaceholder('Image 1', Colors.purple),
              _buildImagePlaceholder('Image 2', Colors.green),
              _buildImagePlaceholder('Image 3', Colors.orange),
              _buildImagePlaceholder('Image 4', Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder(String title, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Center(
        child: ResponsiveText(
          text: title,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
