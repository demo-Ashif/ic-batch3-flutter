import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

// Without Equatable
class UserWithoutEquatable {
  final String name;
  final int age;
  final String email;

  const UserWithoutEquatable({
    required this.name,
    required this.age,
    required this.email,
  });

  // Manual equality implementation
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserWithoutEquatable &&
        other.name == name &&
        other.age == age &&
        other.email == email;
  }

  @override
  int get hashCode => name.hashCode ^ age.hashCode ^ email.hashCode;
}

// With Equatable
class UserWithEquatable extends Equatable {
  final String name;
  final int age;
  final String email;

  const UserWithEquatable({
    required this.name,
    required this.age,
    required this.email,
  });

  @override
  List<Object?> get props => [name, age, email];
}

class EquatableExplanationScreen extends StatefulWidget {
  const EquatableExplanationScreen({super.key});

  @override
  State<EquatableExplanationScreen> createState() =>
      _EquatableExplanationScreenState();
}

class _EquatableExplanationScreenState
    extends State<EquatableExplanationScreen> {
  late UserWithoutEquatable user1WithoutEquatable;
  late UserWithoutEquatable user2WithoutEquatable;
  late UserWithEquatable user1WithEquatable;
  late UserWithEquatable user2WithEquatable;

  bool equalityResultWithoutEquatable = false;
  bool equalityResultWithEquatable = false;
  String explanation = '';

  @override
  void initState() {
    super.initState();
    _createUsers();
  }

  void _createUsers() {
    user1WithoutEquatable = const UserWithoutEquatable(
      name: 'John Doe',
      age: 25,
      email: 'john@example.com',
    );
    user2WithoutEquatable = const UserWithoutEquatable(
      name: 'John Doe',
      age: 25,
      email: 'john@example.com',
    );

    user1WithEquatable = const UserWithEquatable(
      name: 'John Doe',
      age: 25,
      email: 'john@example.com',
    );
    user2WithEquatable = const UserWithEquatable(
      name: 'John Doe',
      age: 25,
      email: 'john@example.com',
    );
  }

  void _testEquality() {
    setState(() {
      equalityResultWithoutEquatable =
          user1WithoutEquatable == user2WithoutEquatable;
      equalityResultWithEquatable = user1WithEquatable == user2WithEquatable;

      explanation = '''
Without Equatable:
• Manual implementation of == operator
• Manual implementation of hashCode
• Easy to forget or make mistakes
• More code to maintain

With Equatable:
• Automatic equality implementation
• Automatic hashCode implementation
• Less code, fewer bugs
• Easy to maintain
      ''';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('04. What Problem Equatable Solves'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'The Equatable Problem',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 16),

              // Problem Explanation
              _buildProblemCard(
                'The Problem:',
                'When comparing objects in Dart, the default == operator compares references, not values. This means two objects with identical data are not equal.',
                Icons.error,
                Colors.red,
              ),

              const SizedBox(height: 16),

              // Example Demonstration
              const Text(
                'Example: Comparing Two Users',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'User 1: John Doe, 25, john@example.com',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text('User 2: John Doe, 25, john@example.com'),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: _testEquality,
                            child: const Text('Test Equality'),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Without Equatable: ${equalityResultWithoutEquatable ? 'Equal' : 'Not Equal'}',
                            style: TextStyle(
                              color:
                                  equalityResultWithoutEquatable
                                      ? Colors.green
                                      : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'With Equatable: ${equalityResultWithEquatable ? 'Equal' : 'Not Equal'}',
                        style: TextStyle(
                          color:
                              equalityResultWithEquatable
                                  ? Colors.green
                                  : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Code Comparison
              const Text(
                'Code Comparison',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Without Equatable
              _buildCodeCard('Without Equatable (Manual Implementation):', '''
        class UserWithoutEquatable {
          final String name;
          final int age;
          final String email;
        
          const UserWithoutEquatable({
            required this.name,
            required this.age,
            required this.email,
          });
        
          @override
          bool operator ==(Object other) {
            if (identical(this, other)) return true;
            return other is UserWithoutEquatable &&
          other.name == name &&
          other.age == age &&
          other.email == email;
          }
        
          @override
          int get hashCode => name.hashCode ^ age.hashCode ^ email.hashCode;
        }
                ''', Colors.red),

              const SizedBox(height: 16),

              // With Equatable
              _buildCodeCard('With Equatable (Automatic Implementation):', '''
        class UserWithEquatable extends Equatable {
          final String name;
          final int age;
          final String email;
        
          const UserWithEquatable({
            required this.name,
            required this.age,
            required this.email,
          });
        
          // No need to implement == and hashCode!
        }
                ''', Colors.green),

              const SizedBox(height: 24),

              // Why Equatable is Important
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
                      'Why Equatable is Important:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('• Prevents unnecessary UI rebuilds'),
                    const Text('• Ensures proper state comparison'),
                    const Text('• Reduces bugs in state management'),
                    const Text('• Makes testing easier'),
                    const Text('• Cleaner, more maintainable code'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // When to Use Equatable
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'When to Use Equatable:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('✅ In BLoC/Cubit states'),
                    const Text('✅ In data models'),
                    const Text('✅ When comparing objects'),
                    const Text('✅ In collections (List, Set)'),
                    const Text('✅ For proper state management'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Explanation
              if (explanation.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Explanation:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(explanation),
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
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeCard(String title, String code, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: Text(
                code,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
