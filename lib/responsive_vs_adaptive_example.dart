import 'package:flutter/material.dart';
import 'responsive_helper.dart';
import 'responsive_widget.dart';

/// Example demonstrating the difference between Responsive and Adaptive design
/// This shows both approaches side by side for comparison
class ResponsiveVsAdaptiveExample extends StatelessWidget {
  const ResponsiveVsAdaptiveExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ResponsiveText(
          text: 'Responsive vs Adaptive Design',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: ResponsiveHelper.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Explanation Section
            _buildExplanationSection(context),

            const SizedBox(height: 32),

            // Responsive Design Example
            _buildResponsiveExample(context),

            const SizedBox(height: 32),

            // Adaptive Design Example
            _buildAdaptiveExample(context),

            const SizedBox(height: 32),

            // Comparison Table
            _buildComparisonTable(context),
          ],
        ),
      ),
    );
  }

  /// Explanation of the difference between Responsive and Adaptive
  Widget _buildExplanationSection(BuildContext context) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResponsiveText(
            text: 'Understanding Responsive vs Adaptive Design',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 16),
          const ResponsiveText(
            text:
                'Many developers confuse these two approaches. Here\'s the key difference:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          _buildDefinitionCard(
            context,
            'Responsive Design',
            'Single layout that fluidly adapts to any screen size using flexible grids and relative units.',
            Colors.blue,
            Icons.tune,
          ),
          const SizedBox(height: 16),
          _buildDefinitionCard(
            context,
            'Adaptive Design',
            'Multiple fixed layouts designed for specific screen sizes with discrete breakpoints.',
            Colors.orange,
            Icons.devices,
          ),
        ],
      ),
    );
  }

  Widget _buildDefinitionCard(
    BuildContext context,
    String title,
    String description,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveText(
                  text: title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                ResponsiveText(
                  text: description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Responsive Design Example - Fluid scaling
  Widget _buildResponsiveExample(BuildContext context) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResponsiveText(
            text: 'Responsive Design Example',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          const ResponsiveText(
            text: 'This layout fluidly scales across all screen sizes',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Responsive container that scales with screen size
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.8),
                  Colors.purple.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: ResponsiveText(
                text:
                    'Fluid Container\n${MediaQuery.of(context).size.width.toStringAsFixed(0)} x ${MediaQuery.of(context).size.height.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Responsive grid that adapts columns
          ResponsiveGrid(
            children: [
              _buildGridItem('Item 1', Colors.red),
              _buildGridItem('Item 2', Colors.green),
              _buildGridItem('Item 3', Colors.blue),
              _buildGridItem('Item 4', Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  /// Adaptive Design Example - Different layouts per breakpoint
  Widget _buildAdaptiveExample(BuildContext context) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResponsiveText(
            text: 'Adaptive Design Example',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          const ResponsiveText(
            text: 'This layout changes completely at different breakpoints',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Adaptive layout using ResponsiveWidget
          ResponsiveWidget(
            // Mobile Layout - Vertical stack
            mobile: Column(
              children: [
                _buildAdaptiveItem(
                  'Mobile Layout',
                  Colors.green,
                  Icons.phone_android,
                ),
                const SizedBox(height: 12),
                _buildAdaptiveItem(
                  'Single Column',
                  Colors.green,
                  Icons.view_column,
                ),
                const SizedBox(height: 12),
                _buildAdaptiveItem(
                  'Touch Optimized',
                  Colors.green,
                  Icons.touch_app,
                ),
              ],
            ),
            // Tablet Layout - Two columns
            tablet: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildAdaptiveItem(
                        'Tablet Layout',
                        Colors.orange,
                        Icons.tablet_android,
                      ),
                      const SizedBox(height: 12),
                      _buildAdaptiveItem(
                        'Two Columns',
                        Colors.orange,
                        Icons.view_column,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      _buildAdaptiveItem(
                        'Landscape',
                        Colors.orange,
                        Icons.screen_rotation,
                      ),
                      const SizedBox(height: 12),
                      _buildAdaptiveItem(
                        'Medium Size',
                        Colors.orange,
                        Icons.tablet,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Desktop Layout - Three columns with sidebar
            desktop: Row(
              children: [
                // Sidebar
                Container(
                  width: 200,
                  child: Column(
                    children: [
                      _buildAdaptiveItem(
                        'Desktop Layout',
                        Colors.blue,
                        Icons.desktop_windows,
                      ),
                      const SizedBox(height: 12),
                      _buildAdaptiveItem('Sidebar', Colors.blue, Icons.menu),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Main content
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildAdaptiveItem(
                              'Main Content',
                              Colors.blue,
                              Icons.web,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildAdaptiveItem(
                              'Three Columns',
                              Colors.blue,
                              Icons.view_column,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildAdaptiveItem(
                              'Large Screen',
                              Colors.blue,
                              Icons.desktop_mac,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildAdaptiveItem(
                              'Mouse Optimized',
                              Colors.blue,
                              Icons.mouse,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdaptiveItem(String title, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          ResponsiveText(
            text: title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(String title, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Center(
        child: ResponsiveText(
          text: title,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }

  /// Comparison table showing when to use each approach
  Widget _buildComparisonTable(BuildContext context) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResponsiveText(
            text: 'When to Use Each Approach',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),

          // Responsive design use cases
          _buildUseCaseSection(context, 'Use Responsive Design When:', [
            'You want smooth scaling across all devices',
            'Content is similar across screen sizes',
            'You prefer fluid, continuous adaptation',
            'Development time is limited',
            'You want a single codebase',
          ], Colors.blue),

          const SizedBox(height: 16),

          // Adaptive design use cases
          _buildUseCaseSection(context, 'Use Adaptive Design When:', [
            'You need completely different experiences per device',
            'Content varies significantly by screen size',
            'You want to optimize for specific device capabilities',
            'You have time for multiple layout designs',
            'You need device-specific features',
          ], Colors.orange),

          const SizedBox(height: 16),

          // Hybrid approach
          _buildUseCaseSection(context, 'Hybrid Approach (Recommended):', [
            'Combine responsive base layout with adaptive components',
            'Use responsive design for the overall structure',
            'Use adaptive design for specific components',
            'Progressive enhancement from mobile to desktop',
            'Best of both worlds',
          ], Colors.green),
        ],
      ),
    );
  }

  Widget _buildUseCaseSection(
    BuildContext context,
    String title,
    List<String> points,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveText(
          text: title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        ...points
            .map(
              (point) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle, color: color, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ResponsiveText(
                        text: point,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }
}
