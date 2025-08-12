import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// User Model
class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String avatar;
  final String bio;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.bio,
  });

  @override
  List<Object?> get props => [id, name, email, avatar, bio];
}

// Navigation State
class NavigationState extends Equatable {
  final User? selectedUser;
  final List<User> users;
  final bool isLoading;

  const NavigationState({
    this.selectedUser,
    this.users = const [],
    this.isLoading = false,
  });

  NavigationState copyWith({
    User? selectedUser,
    List<User>? users,
    bool? isLoading,
  }) {
    return NavigationState(
      selectedUser: selectedUser ?? this.selectedUser,
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [selectedUser, users, isLoading];
}

// Navigation Cubit
class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState()) {
    _loadUsers();
  }

  void _loadUsers() {
    emit(state.copyWith(isLoading: true));

    // Simulate loading users
    Future.delayed(const Duration(seconds: 1), () {
      final users = [
        const User(
          id: 1,
          name: 'John Doe',
          email: 'john@example.com',
          avatar: '👨‍💼',
          bio:
              'Flutter Developer with 3 years of experience. Passionate about creating beautiful and functional mobile apps.',
        ),
        const User(
          id: 2,
          name: 'Jane Smith',
          email: 'jane@example.com',
          avatar: '👩‍💼',
          bio:
              'UI/UX Designer specializing in mobile app design. Love creating intuitive user experiences.',
        ),
        const User(
          id: 3,
          name: 'Bob Johnson',
          email: 'bob@example.com',
          avatar: '👨‍💻',
          bio:
              'Backend Developer working with Node.js and Python. Building robust APIs for mobile applications.',
        ),
        const User(
          id: 4,
          name: 'Alice Brown',
          email: 'alice@example.com',
          avatar: '👩‍💻',
          bio:
              'Full-stack developer with expertise in React, Flutter, and cloud technologies.',
        ),
      ];

      emit(state.copyWith(users: users, isLoading: false));
    });
  }

  void selectUser(User user) {
    emit(state.copyWith(selectedUser: user));
  }

  void clearSelection() {
    emit(state.copyWith(selectedUser: null));
  }
}

class ScreenNavigationScreen extends StatelessWidget {
  const ScreenNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('08. Screen Navigation with BLoC'),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Data Passing Between Screens',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'This example shows how to pass data between screens using BLoC/Cubit. The selected user data is shared across screens.',
                    style: TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 24),

                  // Users List
                  const Text(
                    'Select a user to view details:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  Expanded(
                    child:
                        state.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                              itemCount: state.users.length,
                              itemBuilder: (context, index) {
                                final user = state.users[index];
                                final isSelected =
                                    state.selectedUser?.id == user.id;

                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  color:
                                      isSelected
                                          ? Colors.amber.withOpacity(0.1)
                                          : null,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      child: Text(user.avatar),
                                    ),
                                    title: Text(
                                      user.name,
                                      style: TextStyle(
                                        fontWeight:
                                            isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                      ),
                                    ),
                                    subtitle: Text(user.email),
                                    trailing:
                                        isSelected
                                            ? const Icon(
                                              Icons.check_circle,
                                              color: Colors.amber,
                                            )
                                            : const Icon(
                                              Icons.arrow_forward_ios,
                                            ),
                                    onTap: () {
                                      context
                                          .read<NavigationCubit>()
                                          .selectUser(user);
                                    },
                                  ),
                                );
                              },
                            ),
                  ),

                  const SizedBox(height: 16),

                  // Navigation Button
                  if (state.selectedUser != null)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => UserDetailScreen(
                                    user: state.selectedUser!,
                                  ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.visibility),
                        label: const Text('View User Details'),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Clear Selection Button
                  if (state.selectedUser != null)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context.read<NavigationCubit>().clearSelection();
                        },
                        icon: const Icon(Icons.clear),
                        label: const Text('Clear Selection'),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // How it works explanation
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How Data Passing Works:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text('1. User selects a user from the list'),
                        Text('2. NavigationCubit stores the selected user'),
                        Text(
                          '3. When navigating to detail screen, user data is passed',
                        ),
                        Text('4. Both screens share the same Cubit instance'),
                        Text(
                          '5. Data flows through the Cubit, not through constructors',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${user.name}\'s Profile'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Avatar and Basic Info
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        child: Text(
                          user.avatar,
                          style: const TextStyle(fontSize: 40),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.email,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // User Bio
                const Text(
                  'Bio:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Text(user.bio, style: const TextStyle(fontSize: 16)),
                ),

                const SizedBox(height: 32),

                // Current Selection Info
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Selection:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Selected User: ${state.selectedUser?.name ?? 'None'}',
                      ),
                      Text('User ID: ${state.selectedUser?.id ?? 'None'}'),
                      Text(
                        'User Email: ${state.selectedUser?.email ?? 'None'}',
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Navigate back
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Go Back'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Clear selection and go back
                          context.read<NavigationCubit>().clearSelection();
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.clear),
                        label: const Text('Clear & Go Back'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
