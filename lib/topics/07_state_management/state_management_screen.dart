import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Task Model
class Task extends Equatable {
  final int id;
  final String title;
  final String description;
  final bool isCompleted;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id, title, description, isCompleted];
}

// Task State
class TaskState extends Equatable {
  final List<Task> tasks;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final String? successMessage;

  const TaskState({
    this.tasks = const [],
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.successMessage,
  });

  TaskState copyWith({
    List<Task>? tasks,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    String? successMessage,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
    tasks,
    isLoading,
    isSuccess,
    errorMessage,
    successMessage,
  ];
}

// Task Cubit
class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(const TaskState());

  // Simulate loading tasks
  Future<void> loadTasks() async {
    emit(
      state.copyWith(isLoading: true, errorMessage: null, successMessage: null),
    );

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Simulate API response
      final tasks = [
        const Task(
          id: 1,
          title: 'Learn Flutter',
          description: 'Study Flutter basics and widgets',
        ),
        const Task(
          id: 2,
          title: 'Understand BLoC',
          description: 'Learn state management with BLoC pattern',
        ),
        const Task(
          id: 3,
          title: 'Build Sample App',
          description: 'Create a simple app using BLoC',
        ),
      ];

      emit(
        state.copyWith(
          tasks: tasks,
          isLoading: false,
          isSuccess: true,
          successMessage: 'Successfully loaded ${tasks.length} tasks',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load tasks: ${e.toString()}',
        ),
      );
    }
  }

  // Simulate adding a task
  Future<void> addTask(String title, String description) async {
    if (title.isEmpty || description.isEmpty) {
      emit(state.copyWith(errorMessage: 'Title and description are required'));
      return;
    }

    emit(
      state.copyWith(isLoading: true, errorMessage: null, successMessage: null),
    );

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      final newTask = Task(
        id: state.tasks.length + 1,
        title: title,
        description: description,
      );

      final updatedTasks = [...state.tasks, newTask];

      emit(
        state.copyWith(
          tasks: updatedTasks,
          isLoading: false,
          isSuccess: true,
          successMessage: 'Task "${newTask.title}" added successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to add task: ${e.toString()}',
        ),
      );
    }
  }

  // Toggle task completion
  void toggleTaskCompletion(int taskId) {
    final updatedTasks =
        state.tasks.map((task) {
          if (task.id == taskId) {
            return task.copyWith(isCompleted: !task.isCompleted);
          }
          return task;
        }).toList();

    emit(
      state.copyWith(
        tasks: updatedTasks,
        successMessage: 'Task updated successfully',
      ),
    );
  }

  // Clear messages
  void clearMessages() {
    emit(state.copyWith(errorMessage: null, successMessage: null));
  }
}

class StateManagementScreen extends StatelessWidget {
  const StateManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('07. State Management & UI Updates'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocProvider(
        create: (context) => TaskCubit(),
        child: BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Task Management with State',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
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
                              context.read<TaskCubit>().clearMessages();
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
                              context.read<TaskCubit>().clearMessages();
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
                                    context.read<TaskCubit>().loadTasks();
                                  },
                          icon: const Icon(Icons.download),
                          label: const Text('Load Tasks'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showAddTaskDialog(context);
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add Task'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Tasks List
                  const Text(
                    'Tasks:',
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
                                  Text('Loading tasks...'),
                                  SizedBox(height: 8),
                                  Text(
                                    'This simulates an API call',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : state.tasks.isEmpty
                            ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.task_alt,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No tasks found',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Click "Load Tasks" to fetch tasks',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                            : ListView.builder(
                              itemCount: state.tasks.length,
                              itemBuilder: (context, index) {
                                final task = state.tasks[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    leading: Checkbox(
                                      value: task.isCompleted,
                                      onChanged: (value) {
                                        context
                                            .read<TaskCubit>()
                                            .toggleTaskCompletion(task.id);
                                      },
                                    ),
                                    title: Text(
                                      task.title,
                                      style: TextStyle(
                                        decoration:
                                            task.isCompleted
                                                ? TextDecoration.lineThrough
                                                : null,
                                        color:
                                            task.isCompleted
                                                ? Colors.grey
                                                : null,
                                      ),
                                    ),
                                    subtitle: Text(
                                      task.description,
                                      style: TextStyle(
                                        decoration:
                                            task.isCompleted
                                                ? TextDecoration.lineThrough
                                                : null,
                                        color:
                                            task.isCompleted
                                                ? Colors.grey
                                                : null,
                                      ),
                                    ),
                                    trailing: Icon(
                                      task.isCompleted
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      color:
                                          task.isCompleted
                                              ? Colors.green
                                              : Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),

                  const SizedBox(height: 16),

                  // State Information
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current State:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Loading: ${state.isLoading}'),
                        Text('Success: ${state.isSuccess}'),
                        Text('Tasks Count: ${state.tasks.length}'),
                        Text('Has Error: ${state.errorMessage != null}'),
                        Text(
                          'Has Success Message: ${state.successMessage != null}',
                        ),
                      ],
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

  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New Task'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Task Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Task Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
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
                  context.read<TaskCubit>().addTask(
                    titleController.text,
                    descriptionController.text,
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
