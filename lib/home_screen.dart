import 'package:flutter/material.dart';
import 'app_typography.dart';
import 'responsive_grid.dart';
import 'responsive_grid_example.dart';
import 'figma_to_flutter_example.dart';
import 'responsive_vs_adaptive_example.dart';
import 'media_query_examples.dart';
import 'best_practices_example.dart';
import 'responsive_use_cases.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Responsive Design'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Today\'s Topics:', style: AppTypography.heading1),
              const SizedBox(height: 16),

              // Topic 1: Figma to Flutter UI
              _buildTopicCard(
                context,
                '1. Figma to Flutter UI',
                'Learn how to convert Figma designs to Flutter code',
                Icons.design_services,
                Colors.purple,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FigmaToFlutterExample(),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Topic 2: Responsive Design
              _buildTopicCard(
                context,
                '2. Responsive Design in Flutter',
                'Understanding responsive design principles and implementation',
                Icons.phone_android,
                Colors.green,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FigmaToFlutterExample(),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Topic 3: Responsive vs Adaptive
              _buildTopicCard(
                context,
                '3. Responsive vs Adaptive Design',
                'Understanding the difference and when to use each approach',
                Icons.compare_arrows,
                Colors.orange,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ResponsiveVsAdaptiveExample(),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Topic 4: Coding Structure
              _buildTopicCard(
                context,
                '4. Coding Structure for Responsive Design',
                'Best practices and patterns for responsive Flutter apps',
                Icons.code,
                Colors.blue,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MediaQueryExamples(),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Topic 5: ResponsiveGrid Examples
              _buildTopicCard(
                context,
                '5. ResponsiveGrid Examples',
                'Learn how to use the ResponsiveGrid widget effectively',
                Icons.grid_on,
                Colors.indigo,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ResponsiveGridExample(),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Topic 6: Use Cases
              _buildTopicCard(
                context,
                '6. Responsive Widget Use Cases',
                'Real-world examples of responsive design patterns',
                Icons.cases,
                Colors.teal,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ResponsiveUseCases(),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Topic 7: Best Practices
              _buildTopicCard(
                context,
                '7. Best Practices Example',
                'Comprehensive guide to responsive design best practices',
                Icons.book,
                Colors.deepPurple,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BestPracticesExample(),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Additional Resources
              const Text(
                'Additional Resources:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),

              _buildResourceCard(
                context,
                '📚 Read the Complete Guide',
                'Check the README.md file for comprehensive documentation',
                Icons.book,
                Colors.indigo,
              ),

              const SizedBox(height: 8),

              _buildResourceCard(
                context,
                '🔧 Responsive Helper Classes',
                'Use ResponsiveHelper and ResponsiveWidget for easy implementation',
                Icons.build,
                Colors.teal,
              ),

              const SizedBox(height: 8),

              _buildResourceCard(
                context,
                '📱 Test on Multiple Devices',
                'Use device simulators to test responsive behavior',
                Icons.phone_iphone,
                Colors.pink,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopicCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResourceCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
