import 'package:flutter/material.dart';
import '../topics/01_why_state_management/why_state_management_screen.dart';
import '../topics/02_bloc_solutions/bloc_solutions_screen.dart';
import '../topics/03_cubit_implementation/cubit_implementation_screen.dart';
import '../topics/04_equatable_explanation/equatable_explanation_screen.dart';
import '../topics/05_form_handling/form_handling_screen.dart';
import '../topics/06_api_simulation/api_simulation_screen.dart';
import '../topics/07_state_management/state_management_screen.dart';
import '../topics/08_screen_navigation/screen_navigation_screen.dart';
import '../topics/09_separation_concerns/separation_concerns_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter State Management with BLoC'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'State Management Learning Path',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Learn state management concepts step by step with practical examples',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildTopicCard(
                    context,
                    '01',
                    'Why State Management?',
                    'Understanding the need for state management',
                    Icons.question_mark,
                    Colors.blue,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WhyStateManagementScreen(),
                      ),
                    ),
                  ),
                  _buildTopicCard(
                    context,
                    '02',
                    'BLoC Solutions',
                    'How BLoC solves state management problems',
                    Icons.lightbulb,
                    Colors.green,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BlocSolutionsScreen(),
                      ),
                    ),
                  ),
                  _buildTopicCard(
                    context,
                    '03',
                    'Cubit Implementation',
                    'Understanding Cubit and how it works',
                    Icons.build,
                    Colors.orange,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CubitImplementationScreen(),
                      ),
                    ),
                  ),
                  _buildTopicCard(
                    context,
                    '04',
                    'Equatable',
                    'What problem Equatable solves',
                    Icons.compare_arrows,
                    Colors.purple,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => const EquatableExplanationScreen(),
                      ),
                    ),
                  ),
                  _buildTopicCard(
                    context,
                    '05',
                    'Form Handling',
                    'Creating input forms with Cubit',
                    Icons.input,
                    Colors.teal,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FormHandlingScreen(),
                      ),
                    ),
                  ),
                  _buildTopicCard(
                    context,
                    '06',
                    'API Simulation',
                    'Simulating API calls with Cubit',
                    Icons.api,
                    Colors.indigo,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ApiSimulationScreen(),
                      ),
                    ),
                  ),
                  _buildTopicCard(
                    context,
                    '07',
                    'State Management',
                    'Loading, success, and error states',
                    Icons.sync,
                    Colors.red,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StateManagementScreen(),
                      ),
                    ),
                  ),
                  _buildTopicCard(
                    context,
                    '08',
                    'Screen Navigation',
                    'Passing data between screens using BLoC',
                    Icons.navigation,
                    Colors.amber,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScreenNavigationScreen(),
                      ),
                    ),
                  ),
                  _buildTopicCard(
                    context,
                    '09',
                    'Separation of Concerns',
                    'UI and business logic separation',
                    Icons.architecture,
                    Colors.brown,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SeparationConcernsScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicCard(
    BuildContext context,
    String number,
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 10),
              Text(
                number,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Flexible(
              //   child: Text(
              //     description,
              //     textAlign: TextAlign.center,
              //     style: const TextStyle(fontSize: 12, color: Colors.grey),
              //     maxLines: 3,
              //     overflow: TextOverflow.ellipsis,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
