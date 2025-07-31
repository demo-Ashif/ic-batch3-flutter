import 'package:flutter/material.dart';
import 'responsive_helper.dart';
import 'responsive_widget.dart';

/// Comprehensive example showing best practices for responsive design
/// This demonstrates real-world patterns and techniques
class BestPracticesExample extends StatelessWidget {
  const BestPracticesExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ResponsiveText(
          text: 'Responsive Design Best Practices',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: ResponsiveHelper.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mobile-First Approach
            _buildMobileFirstSection(context),

            const SizedBox(height: 24),

            // Flexible Layouts
            _buildFlexibleLayoutsSection(context),

            const SizedBox(height: 24),

            // Content Prioritization
            _buildContentPrioritizationSection(context),

            const SizedBox(height: 24),

            // Touch-Friendly Design
            _buildTouchFriendlySection(context),

            const SizedBox(height: 24),

            // Performance Considerations
            _buildPerformanceSection(context),

            const SizedBox(height: 24),

            // Testing Strategy
            _buildTestingStrategySection(context),
          ],
        ),
      ),
    );
  }

  /// Mobile-First Approach Section
  Widget _buildMobileFirstSection(BuildContext context) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResponsiveText(
            text: '1. Mobile-First Approach',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 8),
          const ResponsiveText(
            text:
                'Start with mobile layout and progressively enhance for larger screens',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Mobile-first example
          ResponsiveWidget(
            // Mobile: Simple, focused layout
            mobile: Column(
              children: [
                _buildMobileFirstItem(
                  'Core Feature 1',
                  'Essential functionality',
                  Icons.star,
                  Colors.green,
                ),
                const SizedBox(height: 8),
                _buildMobileFirstItem(
                  'Core Feature 2',
                  'Primary action',
                  Icons.favorite,
                  Colors.red,
                ),
                const SizedBox(height: 8),
                _buildMobileFirstItem(
                  'Core Feature 3',
                  'Main content',
                  Icons.home,
                  Colors.blue,
                ),
              ],
            ),
            // Tablet: Enhanced with secondary features
            tablet: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildMobileFirstItem(
                        'Core Feature 1',
                        'Essential functionality',
                        Icons.star,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMobileFirstItem(
                        'Core Feature 2',
                        'Primary action',
                        Icons.favorite,
                        Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildMobileFirstItem(
                        'Core Feature 3',
                        'Main content',
                        Icons.home,
                        Colors.blue,
                      ),
                    ),
                    Expanded(
                      child: _buildMobileFirstItem(
                        'Secondary Feature',
                        'Enhanced experience',
                        Icons.settings,
                        Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Desktop: Full feature set
            desktop: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildMobileFirstItem(
                        'Core Feature 1',
                        'Essential functionality',
                        Icons.star,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMobileFirstItem(
                        'Core Feature 2',
                        'Primary action',
                        Icons.favorite,
                        Colors.red,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMobileFirstItem(
                        'Core Feature 3',
                        'Main content',
                        Icons.home,
                        Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildMobileFirstItem(
                        'Secondary Feature',
                        'Enhanced experience',
                        Icons.settings,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMobileFirstItem(
                        'Advanced Feature',
                        'Power user tools',
                        Icons.tune,
                        Colors.purple,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMobileFirstItem(
                        'Premium Feature',
                        'Extra capabilities',
                        Icons.diamond,
                        Colors.indigo,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileFirstItem(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
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
          const SizedBox(height: 4),
          ResponsiveText(
            text: description,
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Flexible Layouts Section
  Widget _buildFlexibleLayoutsSection(BuildContext context) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResponsiveText(
            text: '2. Flexible Layouts',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 8),
          const ResponsiveText(
            text: 'Use flexible widgets and avoid fixed dimensions',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Flexible layout examples
          Column(
            children: [
              // Flexible Row
              Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.withOpacity(0.3)),
                      ),
                      child: const Center(
                        child: ResponsiveText(
                          text: 'Flexible (2)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                        ),
                      ),
                      child: const Center(
                        child: ResponsiveText(
                          text: 'Flexible (1)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Expanded example
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.3),
                        ),
                      ),
                      child: const Center(
                        child: ResponsiveText(
                          text: 'Expanded',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.purple.withOpacity(0.3),
                        ),
                      ),
                      child: const Center(
                        child: ResponsiveText(
                          text: 'Expanded',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // FractionallySizedBox example
              FractionallySizedBox(
                widthFactor: 0.8,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: const Center(
                    child: ResponsiveText(
                      text: '80% of parent width',
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

  /// Content Prioritization Section
  Widget _buildContentPrioritizationSection(BuildContext context) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResponsiveText(
            text: '3. Content Prioritization',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 8),
          const ResponsiveText(
            text:
                'Show most important content first, hide secondary content on small screens',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Content prioritization example
          ResponsiveWidget(
            // Mobile: Only essential content
            mobile: Column(
              children: [
                _buildPriorityItem(
                  'Primary Content',
                  'Most important',
                  Colors.green,
                  Icons.priority_high,
                ),
                const SizedBox(height: 8),
                _buildPriorityItem(
                  'Secondary Content',
                  'Important but not critical',
                  Colors.orange,
                  Icons.info,
                ),
              ],
            ),
            // Tablet: Add some secondary content
            tablet: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildPriorityItem(
                        'Primary Content',
                        'Most important',
                        Colors.green,
                        Icons.priority_high,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildPriorityItem(
                        'Secondary Content',
                        'Important but not critical',
                        Colors.orange,
                        Icons.info,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildPriorityItem(
                  'Tertiary Content',
                  'Nice to have',
                  Colors.blue,
                  Icons.star_border,
                ),
              ],
            ),
            // Desktop: Show all content
            desktop: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildPriorityItem(
                        'Primary Content',
                        'Most important',
                        Colors.green,
                        Icons.priority_high,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildPriorityItem(
                        'Secondary Content',
                        'Important but not critical',
                        Colors.orange,
                        Icons.info,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildPriorityItem(
                        'Tertiary Content',
                        'Nice to have',
                        Colors.blue,
                        Icons.star_border,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildPriorityItem(
                        'Advanced Content',
                        'Power user features',
                        Colors.purple,
                        Icons.tune,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildPriorityItem(
                        'Premium Content',
                        'Extra capabilities',
                        Colors.indigo,
                        Icons.diamond,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityItem(
    String title,
    String description,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          ResponsiveText(
            text: title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          ResponsiveText(
            text: description,
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Touch-Friendly Design Section
  Widget _buildTouchFriendlySection(BuildContext context) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResponsiveText(
            text: '4. Touch-Friendly Design',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 8),
          const ResponsiveText(
            text: 'Minimum 44x44 dp touch targets with adequate spacing',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Touch-friendly examples
          Column(
            children: [
              // Good touch targets
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48, // Good touch target size
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                        ),
                      ),
                      child: const Center(
                        child: ResponsiveText(
                          text: 'Good Touch Target (48dp)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16), // Adequate spacing
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                        ),
                      ),
                      child: const Center(
                        child: ResponsiveText(
                          text: 'Good Touch Target (48dp)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Thumb reach zones
              ResponsiveText(
                text: 'Consider thumb reach zones for mobile',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),

              const SizedBox(height: 8),

              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Stack(
                  children: [
                    // Easy reach zone
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.green),
                        ),
                        child: const Center(
                          child: ResponsiveText(
                            text: 'Easy\nReach',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    // Hard reach zone
                    Positioned(
                      top: 20,
                      left: 20,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.red),
                        ),
                        child: const Center(
                          child: ResponsiveText(
                            text: 'Hard\nReach',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Performance Considerations Section
  Widget _buildPerformanceSection(BuildContext context) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResponsiveText(
            text: '5. Performance Considerations',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 8),
          const ResponsiveText(
            text: 'Optimize for different screen densities and performance',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Performance tips
          Column(
            children: [
              _buildPerformanceTip(
                'Use const constructors',
                'Reduces widget rebuilds',
                Icons.speed,
                Colors.green,
              ),
              const SizedBox(height: 8),
              _buildPerformanceTip(
                'Optimize images for density',
                'Use appropriate image resolutions',
                Icons.image,
                Colors.blue,
              ),
              const SizedBox(height: 8),
              _buildPerformanceTip(
                'Implement lazy loading',
                'Load content as needed',
                Icons.download,
                Colors.orange,
              ),
              const SizedBox(height: 8),
              _buildPerformanceTip(
                'Use ListView.builder',
                'Efficient list rendering',
                Icons.list,
                Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceTip(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
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
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
                const SizedBox(height: 2),
                ResponsiveText(
                  text: description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Testing Strategy Section
  Widget _buildTestingStrategySection(BuildContext context) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResponsiveText(
            text: '6. Testing Strategy',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 8),
          const ResponsiveText(
            text: 'Test on multiple device sizes and configurations',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Testing checklist
          Column(
            children: [
              _buildTestingItem(
                'Test on multiple device sizes',
                Icons.phone_android,
                Colors.green,
              ),
              const SizedBox(height: 8),
              _buildTestingItem(
                'Test both orientations',
                Icons.screen_rotation,
                Colors.blue,
              ),
              const SizedBox(height: 8),
              _buildTestingItem(
                'Test with different text sizes',
                Icons.text_fields,
                Colors.orange,
              ),
              const SizedBox(height: 8),
              _buildTestingItem(
                'Test with different screen densities',
                Icons.high_quality,
                Colors.purple,
              ),
              const SizedBox(height: 8),
              _buildTestingItem(
                'Test accessibility features',
                Icons.accessibility,
                Colors.indigo,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Device testing info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.amber[700]),
                const SizedBox(width: 8),
                Expanded(
                  child: ResponsiveText(
                    text:
                        'Use device simulators and real devices for comprehensive testing',
                    style: TextStyle(
                      color: Colors.amber[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestingItem(String text, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: ResponsiveText(
            text: text,
            style: TextStyle(fontWeight: FontWeight.w500, color: color),
          ),
        ),
        Icon(Icons.check_circle, color: color, size: 16),
      ],
    );
  }
}
