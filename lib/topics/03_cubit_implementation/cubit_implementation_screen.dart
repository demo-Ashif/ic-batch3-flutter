import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Simple Counter Cubit
class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(const CounterState(count: 0));

  void increment() {
    emit(state.copyWith(count: state.count + 1));
  }

  void decrement() {
    emit(state.copyWith(count: state.count - 1));
  }

  void reset() {
    emit(const CounterState(count: 0));
  }
}

// Counter State
class CounterState extends Equatable {
  final int count;

  const CounterState({required this.count});

  CounterState copyWith({int? count}) {
    return CounterState(count: count ?? this.count);
  }

  @override
  List<Object?> get props => [count];
}

// Form Cubit
class FormCubit extends Cubit<FormState> {
  FormCubit() : super(const FormState());

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void updateEmail(String email) {
    emit(state.copyWith(email: email));
  }

  void updateAge(String age) {
    emit(state.copyWith(age: age));
  }

  void resetForm() {
    emit(const FormState());
  }
}

// Form State
class FormState extends Equatable {
  final String name;
  final String email;
  final String age;

  const FormState({this.name = '', this.email = '', this.age = ''});

  FormState copyWith({String? name, String? email, String? age}) {
    return FormState(
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
    );
  }

  @override
  List<Object?> get props => [name, email, age];
}

class CubitImplementationScreen extends StatelessWidget {
  const CubitImplementationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('03. How Cubit Works'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Understanding Cubit',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 16),

              // What is Cubit
              _buildInfoCard(
                'What is Cubit?',
                'Cubit is a simplified version of BLoC that uses functions to emit states instead of events.',
                Icons.info,
                Colors.blue,
              ),

              const SizedBox(height: 16),

              // How Cubit Works
              _buildInfoCard(
                'How Cubit Works',
                '1. Cubit has functions that emit states\n2. UI listens to state changes\n3. When function is called, new state is emitted\n4. UI rebuilds with new state',
                Icons.psychology,
                Colors.green,
              ),

              const SizedBox(height: 24),

              // Counter Example
              const Text(
                'Example 1: Simple Counter Cubit',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              BlocProvider(
                create: (context) => CounterCubit(),
                child: BlocBuilder<CounterCubit, CounterState>(
                  builder: (context, state) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'Count: ${state.count}',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<CounterCubit>().decrement();
                                  },
                                  child: const Text('-'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<CounterCubit>().reset();
                                  },
                                  child: const Text('Reset'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<CounterCubit>().increment();
                                  },
                                  child: const Text('+'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Form Example
              const Text(
                'Example 2: Form Cubit',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              BlocProvider(
                create: (context) => FormCubit(),
                child: BlocBuilder<FormCubit, FormState>(
                  builder: (context, state) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                context.read<FormCubit>().updateName(value);
                              },
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                context.read<FormCubit>().updateEmail(value);
                              },
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              decoration: const InputDecoration(
                                labelText: 'Age',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                context.read<FormCubit>().updateAge(value);
                              },
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<FormCubit>().resetForm();
                                  },
                                  child: const Text('Reset'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Show current state
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Name: ${state.name}, Email: ${state.email}, Age: ${state.age}',
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('Show State'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Cubit vs BLoC
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
                      'Cubit vs BLoC:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Cubit:'),
                    const Text('• Simpler to implement'),
                    const Text('• Uses functions instead of events'),
                    const Text('• Good for simple state management'),
                    const SizedBox(height: 8),
                    const Text('BLoC:'),
                    const Text('• More structured with events'),
                    const Text('• Better for complex state management'),
                    const Text('• More testable'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Key Points
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Key Points about Cubit:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text('✅ Simpler than BLoC'),
                    Text('✅ Functions emit states directly'),
                    Text('✅ Good for beginners'),
                    Text('✅ Easy to understand'),
                    Text('✅ Perfect for simple apps'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
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
}
