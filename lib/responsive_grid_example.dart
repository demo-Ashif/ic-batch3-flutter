import 'package:flutter/material.dart';
import 'responsive_grid.dart';
import 'responsive_helper.dart';

/// Example demonstrating the ResponsiveGrid widget usage
class ResponsiveGridExample extends StatelessWidget {
  const ResponsiveGridExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ResponsiveGrid Examples'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: ResponsiveHelper.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Example 1: Basic ResponsiveGrid
            _buildBasicExample(context),

            const SizedBox(height: 32),

            // Example 2: Custom spacing
            _buildCustomSpacingExample(context),

            const SizedBox(height: 32),

            // Example 3: Different content types
            _buildContentTypesExample(context),

            const SizedBox(height: 32),

            // Example 4: Interactive grid
            _buildInteractiveExample(context),
          ],
        ),
      ),
    );
  }

  /// Example 1: Basic ResponsiveGrid usage
  Widget _buildBasicExample(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '1. Basic ResponsiveGrid',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Automatically adapts columns based on screen width:\n• Mobile (< 600px): 1 column\n• Tablet (600-900px): 2 columns\n• Desktop (> 900px): 3 columns',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            
            ResponsiveGrid(
              children: [
                _buildGridItem('Item 1', Colors.red),
                _buildGridItem('Item 2', Colors.green),
                _buildGridItem('Item 3', Colors.blue),
                _buildGridItem('Item 4', Colors.orange),
                _buildGridItem('Item 5', Colors.purple),
                _buildGridItem('Item 6', Colors.teal),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Example 2: Custom spacing
  Widget _buildCustomSpacingExample(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '2. Custom Spacing',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'ResponsiveGrid with custom spacing between items',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            
            ResponsiveGrid(
              spacing: 24.0, // Custom spacing
              children: [
                _buildGridItem('Card 1', Colors.indigo),
                _buildGridItem('Card 2', Colors.pink),
                _buildGridItem('Card 3', Colors.amber),
                _buildGridItem('Card 4', Colors.cyan),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Example 3: Different content types
  Widget _buildContentTypesExample(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '3. Different Content Types',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'ResponsiveGrid can contain any type of widgets',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            
            ResponsiveGrid(
              children: [
                // Text card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Text Content',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'This is a text card with some content that demonstrates how ResponsiveGrid can handle different types of widgets.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                
                // Image placeholder
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 32, color: Colors.green),
                        SizedBox(height: 8),
                        Text(
                          'Image Placeholder',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Button card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.touch_app, size: 32, color: Colors.orange),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Action Button'),
                      ),
                    ],
                  ),
                ),
                
                // Stats card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.purple.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.analytics, size: 32, color: Colors.purple),
                      const SizedBox(height: 8),
                      const Text(
                        '1,234',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.purple,
                        ),
                      ),
                      const Text(
                        'Total Views',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Example 4: Interactive grid
  Widget _buildInteractiveExample(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '4. Interactive Grid',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'ResponsiveGrid with interactive elements',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            
            ResponsiveGrid(
              children: [
                _buildInteractiveItem('Settings', Icons.settings, Colors.blue),
                _buildInteractiveItem('Profile', Icons.person, Colors.green),
                _buildInteractiveItem('Messages', Icons.message, Colors.orange),
                _buildInteractiveItem('Notifications', Icons.notifications, Colors.red),
                _buildInteractiveItem('Help', Icons.help, Colors.purple),
                _buildInteractiveItem('Logout', Icons.logout, Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(String title, Color color) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildInteractiveItem(String title, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        // Handle tap - using a global key or context would be better in real apps
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 