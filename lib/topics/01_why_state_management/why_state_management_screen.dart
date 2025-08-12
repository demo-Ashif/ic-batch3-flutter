import 'package:flutter/material.dart';

class WhyStateManagementScreen extends StatefulWidget {
  const WhyStateManagementScreen({super.key});

  @override
  State<WhyStateManagementScreen> createState() =>
      _WhyStateManagementScreenState();
}

class _WhyStateManagementScreenState extends State<WhyStateManagementScreen> {
  int _counter = 0;
  String _userName = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('01. Why State Management?'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Problems Without State Management',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 16),

              // Problem 1: Counter Example
              _buildProblemCard(
                'Problem 1: Simple State Management',
                'Managing a simple counter becomes messy with setState()',
                Icons.exposure_plus_1,
                Colors.red,
                Column(
                  children: [
                    Text(
                      'Counter: $_counter',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _counter++;
                            });
                          },
                          child: const Text('Increment'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _counter = 0;
                            });
                          },
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Problem 2: Form State
              _buildProblemCard(
                'Problem 2: Form State Management',
                'Managing form inputs and validation becomes complex',
                Icons.input,
                Colors.orange,
                Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'User Name',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _userName = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Text('Current value: $_userName'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Problem 3: Loading States
              _buildProblemCard(
                'Problem 3: Loading States',
                'Managing loading, success, and error states manually',
                Icons.sync,
                Colors.purple,
                Column(
                  children: [
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 48,
                      ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                        });

                        // Simulate some work
                        Future.delayed(const Duration(seconds: 2), () {
                          setState(() {
                            _isLoading = false;
                          });
                        });
                      },
                      child: const Text('Simulate Work'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Why State Management is Needed
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Why State Management is Needed:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('• Code becomes messy and hard to maintain'),
                    const Text('• State logic gets mixed with UI logic'),
                    const Text('• Difficult to test business logic'),
                    const Text('• Hard to share state between widgets'),
                    const Text('• No clear separation of concerns'),
                    const Text(
                      '• Performance issues with unnecessary rebuilds',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProblemCard(
    String title,
    String description,
    IconData icon,
    Color color,
    Widget example,
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
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: example,
            ),
          ],
        ),
      ),
    );
  }
}
