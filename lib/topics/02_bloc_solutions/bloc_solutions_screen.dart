import 'package:flutter/material.dart';

class BlocSolutionsScreen extends StatelessWidget {
  const BlocSolutionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('02. How BLoC Solves Problems'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'BLoC Pattern Solutions',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),

              // Solution 1: Separation of Concerns
              _buildSolutionCard(
                'Solution 1: Separation of Concerns',
                'BLoC separates business logic from UI logic',
                Icons.architecture,
                Colors.green,
                [
                  '• Business logic is isolated in BLoC classes',
                  '• UI only handles presentation',
                  '• Easy to test business logic independently',
                  '• Clear responsibility boundaries',
                ],
              ),

              const SizedBox(height: 16),

              // Solution 2: Predictable State Changes
              _buildSolutionCard(
                'Solution 2: Predictable State Changes',
                'State changes follow a clear pattern: Event → BLoC → State',
                Icons.trending_up,
                Colors.blue,
                [
                  '• Events trigger state changes',
                  '• BLoC processes events and emits states',
                  '• UI rebuilds only when state changes',
                  '• Unidirectional data flow',
                ],
              ),

              const SizedBox(height: 16),

              // Solution 3: State Management
              _buildSolutionCard(
                'Solution 3: Centralized State Management',
                'All state is managed in one place, accessible to multiple widgets',
                Icons.center_focus_strong,
                Colors.purple,
                [
                  '• Single source of truth for state',
                  '• Multiple widgets can access the same state',
                  '• No need to pass state through constructors',
                  '• Easy to share state between screens',
                ],
              ),

              const SizedBox(height: 16),

              // Solution 4: Testing
              _buildSolutionCard(
                'Solution 4: Easy Testing',
                'Business logic can be tested independently of UI',
                Icons.science,
                Colors.orange,
                [
                  '• Test BLoC logic without UI',
                  '• Mock dependencies easily',
                  '• Test state transitions',
                  '• High test coverage possible',
                ],
              ),

              const SizedBox(height: 16),

              // Solution 5: Performance
              _buildSolutionCard(
                'Solution 5: Performance Optimization',
                'Widgets rebuild only when their specific state changes',
                Icons.speed,
                Colors.teal,
                [
                  '• Selective widget rebuilding',
                  '• No unnecessary UI updates',
                  '• Efficient memory usage',
                  '• Smooth user experience',
                ],
              ),

              const SizedBox(height: 24),

              // BLoC Architecture Diagram
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'BLoC Architecture:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildArchitectureStep(
                            'UI',
                            'User Interaction',
                            Icons.touch_app,
                          ),
                          const Icon(Icons.arrow_forward, color: Colors.grey),
                          _buildArchitectureStep(
                            'Event',
                            'Action Triggered',
                            Icons.event,
                          ),
                          const Icon(Icons.arrow_forward, color: Colors.grey),
                          _buildArchitectureStep(
                            'BLoC',
                            'Business Logic',
                            Icons.build,
                          ),
                          const Icon(Icons.arrow_forward, color: Colors.grey),
                          _buildArchitectureStep(
                            'State',
                            'New State',
                            Icons.data_usage,
                          ),
                          const Icon(Icons.arrow_forward, color: Colors.grey),
                          _buildArchitectureStep(
                            'UI',
                            'Rebuild',
                            Icons.refresh,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Key Benefits Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Key Benefits of BLoC:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text('✅ Clean separation of concerns'),
                    Text('✅ Predictable state management'),
                    Text('✅ Easy testing and debugging'),
                    Text('✅ Reusable business logic'),
                    Text('✅ Better performance'),
                    Text('✅ Scalable architecture'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSolutionCard(
    String title,
    String description,
    IconData icon,
    Color color,
    List<String> benefits,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            ...benefits.map(
              (benefit) => Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 4),
                child: Text(benefit),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArchitectureStep(String title, String subtitle, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.blue, size: 24),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
