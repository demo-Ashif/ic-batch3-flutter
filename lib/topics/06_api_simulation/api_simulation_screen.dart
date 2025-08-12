import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// User Model
class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String avatar;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
  });

  @override
  List<Object?> get props => [id, name, email, avatar];
}

// API State
class ApiState extends Equatable {
  final List<User> users;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final String? successMessage;

  const ApiState({
    this.users = const [],
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.successMessage,
  });

  ApiState copyWith({
    List<User>? users,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    String? successMessage,
  }) {
    return ApiState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
    users,
    isLoading,
    isSuccess,
    errorMessage,
    successMessage,
  ];
}

// API Cubit
class ApiCubit extends Cubit<ApiState> {
  ApiCubit() : super(const ApiState());

  // Simulate API call to fetch users
  Future<void> fetchUsers() async {
    emit(
      state.copyWith(isLoading: true, errorMessage: null, successMessage: null),
    );

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Simulate API response
      final users = [
        const User(
          id: 1,
          name: 'John Doe',
          email: 'john@example.com',
          avatar: '👨‍💼',
        ),
        const User(
          id: 2,
          name: 'Jane Smith',
          email: 'jane@example.com',
          avatar: '👩‍💼',
        ),
        const User(
          id: 3,
          name: 'Bob Johnson',
          email: 'bob@example.com',
          avatar: '👨‍💻',
        ),
        const User(
          id: 4,
          name: 'Alice Brown',
          email: 'alice@example.com',
          avatar: '👩‍💻',
        ),
      ];

      emit(
        state.copyWith(
          users: users,
          isLoading: false,
          isSuccess: true,
          successMessage: 'Successfully fetched ${users.length} users',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to fetch users: ${e.toString()}',
        ),
      );
    }
  }

  // Simulate API call to add a new user
  Future<void> addUser(String name, String email) async {
    if (name.isEmpty || email.isEmpty) {
      emit(state.copyWith(errorMessage: 'Name and email are required'));
      return;
    }

    emit(
      state.copyWith(isLoading: true, errorMessage: null, successMessage: null),
    );

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Simulate API response
      final newUser = User(
        id: state.users.length + 1,
        name: name,
        email: email,
        avatar: '👤',
      );

      final updatedUsers = [...state.users, newUser];

      emit(
        state.copyWith(
          users: updatedUsers,
          isLoading: false,
          isSuccess: true,
          successMessage: 'User ${newUser.name} added successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to add user: ${e.toString()}',
        ),
      );
    }
  }

  // Simulate API call to delete a user
  Future<void> deleteUser(int userId) async {
    emit(
      state.copyWith(isLoading: true, errorMessage: null, successMessage: null),
    );

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Simulate API response
      final updatedUsers =
          state.users.where((user) => user.id != userId).toList();

      emit(
        state.copyWith(
          users: updatedUsers,
          isLoading: false,
          isSuccess: true,
          successMessage: 'User deleted successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to delete user: ${e.toString()}',
        ),
      );
    }
  }

  // Clear messages
  void clearMessages() {
    emit(state.copyWith(errorMessage: null, successMessage: null));
  }
}

class ApiSimulationScreen extends StatelessWidget {
  const ApiSimulationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('06. API Simulation with Cubit'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocProvider(
        create: (context) => ApiCubit(),
        child: BlocBuilder<ApiCubit, ApiState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'API Simulation Demo',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Success Message
                  if (state.successMessage != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              state.successMessage!,
                              style: const TextStyle(color: Colors.green),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context.read<ApiCubit>().clearMessages();
                            },
                            icon: const Icon(Icons.close, color: Colors.green),
                          ),
                        ],
                      ),
                    ),

                  if (state.successMessage != null) const SizedBox(height: 16),

                  // Error Message
                  if (state.errorMessage != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              state.errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context.read<ApiCubit>().clearMessages();
                            },
                            icon: const Icon(Icons.close, color: Colors.red),
                          ),
                        ],
                      ),
                    ),

                  if (state.errorMessage != null) const SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed:
                              state.isLoading
                                  ? null
                                  : () {
                                    context.read<ApiCubit>().fetchUsers();
                                  },
                          icon: const Icon(Icons.download),
                          label: const Text('Fetch Users'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showAddUserDialog(context);
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add User'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Users List
                  const Text(
                    'Users List:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  Expanded(
                    child:
                        state.isLoading
                            ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 16),
                                  Text('Loading users...'),
                                ],
                              ),
                            )
                            : state.users.isEmpty
                            ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.people_outline,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No users found',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Click "Fetch Users" to load users',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                            : ListView.builder(
                              itemCount: state.users.length,
                              itemBuilder: (context, index) {
                                final user = state.users[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      child: Text(user.avatar),
                                    ),
                                    title: Text(user.name),
                                    subtitle: Text(user.email),
                                    trailing: IconButton(
                                      onPressed: () {
                                        context.read<ApiCubit>().deleteUser(
                                          user.id,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New User'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<ApiCubit>().addUser(
                    nameController.text,
                    emailController.text,
                  );
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }
}
