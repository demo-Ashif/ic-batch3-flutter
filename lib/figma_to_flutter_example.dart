import 'package:flutter/material.dart';
import 'responsive_helper.dart';
import 'responsive_widget.dart';

/// Example showing how to convert a Figma design to Flutter code
/// This demonstrates the complete process from design analysis to implementation
class FigmaToFlutterExample extends StatelessWidget {
  const FigmaToFlutterExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ResponsiveText(
          text: 'Figma to Flutter Example',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: ResponsiveHelper.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section - Responsive Design
            _buildHeroSection(context),

            const SizedBox(height: 32),

            // Features Grid - Adaptive Design
            _buildFeaturesSection(context),

            const SizedBox(height: 32),

            // Contact Form - Responsive Form
            _buildContactForm(context),
          ],
        ),
      ),
    );
  }

  /// Hero Section - Demonstrates responsive design
  Widget _buildHeroSection(BuildContext context) {
    return ResponsiveContainer(
      widthPercentage: 1.0,
      heightPercentage: 0.4,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ResponsiveWidget(
        // Mobile Layout - Stacked vertically
        mobile: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.flutter_dash, size: 80, color: Colors.white),
            const SizedBox(height: 16),
            const ResponsiveText(
              text: 'Flutter Development',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const ResponsiveText(
              text: 'Build beautiful, responsive apps',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ResponsiveButton(
              text: 'Get Started',
              onPressed: () {},
              backgroundColor: Colors.white,
              textColor: Colors.blue,
              widthPercentage: 0.6,
            ),
          ],
        ),
        // Tablet Layout - Side by side
        tablet: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.flutter_dash,
                    size: 100,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  const ResponsiveText(
                    text: 'Flutter Development',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ResponsiveText(
                    text: 'Build beautiful, responsive apps',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 24),
                  ResponsiveButton(
                    text: 'Get Started',
                    onPressed: () {},
                    backgroundColor: Colors.white,
                    textColor: Colors.blue,
                    widthPercentage: 0.5,
                  ),
                ],
              ),
            ),
          ],
        ),
        // Desktop Layout - Enhanced with more content
        desktop: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.flutter_dash,
                    size: 120,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 24),
                  const ResponsiveText(
                    text: 'Flutter Development',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ResponsiveText(
                    text: 'Build beautiful, responsive apps',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  const ResponsiveText(
                    text:
                        'Create stunning user interfaces that work seamlessly across all devices',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      ResponsiveButton(
                        text: 'Get Started',
                        onPressed: () {},
                        backgroundColor: Colors.white,
                        textColor: Colors.blue,
                        widthPercentage: 0.3,
                      ),
                      const SizedBox(width: 16),
                      ResponsiveButton(
                        text: 'Learn More',
                        onPressed: () {},
                        backgroundColor: Colors.transparent,
                        textColor: Colors.white,
                        widthPercentage: 0.3,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Features Section - Demonstrates adaptive design with grid
  Widget _buildFeaturesSection(BuildContext context) {
    final features = [
      {
        'icon': Icons.phone_android,
        'title': 'Mobile First',
        'description': 'Optimized for mobile devices',
      },
      {
        'icon': Icons.tablet_android,
        'title': 'Tablet Ready',
        'description': 'Perfect for tablet experiences',
      },
      {
        'icon': Icons.desktop_windows,
        'title': 'Desktop Compatible',
        'description': 'Works great on desktop',
      },
      {
        'icon': Icons.touch_app,
        'title': 'Touch Friendly',
        'description': 'Built for touch interactions',
      },
      {
        'icon': Icons.speed,
        'title': 'High Performance',
        'description': 'Fast and smooth animations',
      },
      {
        'icon': Icons.palette,
        'title': 'Beautiful UI',
        'description': 'Material Design principles',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ResponsiveText(
          text: 'Features',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 16),
        ResponsiveGrid(
          children:
              features.map((feature) {
                return ResponsiveCard(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        feature['icon'] as IconData,
                        size: ResponsiveHelper.isMobile(context) ? 40 : 48,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 16),
                      ResponsiveText(
                        text: feature['title'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      ResponsiveText(
                        text: feature['description'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            mobileSize: 12,
                            tabletSize: 14,
                            desktopSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  /// Contact Form - Demonstrates responsive form design
  Widget _buildContactForm(BuildContext context) {
    return ResponsiveContainer(
      widthPercentage: ResponsiveHelper.isMobile(context) ? 1.0 : 0.8,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResponsiveText(
            text: 'Contact Us',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 24),

          // Responsive form layout
          ResponsiveWidget(
            // Mobile: Stacked form fields
            mobile: Column(
              children: [
                _buildTextField('Name', Icons.person),
                const SizedBox(height: 16),
                _buildTextField('Email', Icons.email),
                const SizedBox(height: 16),
                _buildTextField('Message', Icons.message, maxLines: 4),
                const SizedBox(height: 24),
                ResponsiveButton(
                  text: 'Send Message',
                  onPressed: () {},
                  widthPercentage: 1.0,
                ),
              ],
            ),
            // Tablet/Desktop: Side by side fields
            tablet: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildTextField('Name', Icons.person)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField('Email', Icons.email)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField('Message', Icons.message, maxLines: 4),
                const SizedBox(height: 24),
                ResponsiveButton(
                  text: 'Send Message',
                  onPressed: () {},
                  widthPercentage: 0.3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Helper method to build text fields
  Widget _buildTextField(String label, IconData icon, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
