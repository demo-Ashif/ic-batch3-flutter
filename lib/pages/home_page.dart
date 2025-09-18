import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import 'add_task_page.dart';
import 'task_details_page.dart';

/// HomePage demonstrates StreamBuilder for real-time data reading
/// This page shows how to display Firestore data in real-time
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskService _taskService = TaskService();
  String _selectedFilter = 'all'; // 'all', 'completed', 'pending'
  String _selectedCategory = 'all'; // 'all', 'work', 'personal', etc.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Filter dropdown
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(value: 'all', child: Text('All Tasks')),
                  const PopupMenuItem(
                    value: 'completed',
                    child: Text('Completed'),
                  ),
                  const PopupMenuItem(value: 'pending', child: Text('Pending')),
                ],
          ),
          // Category filter
          PopupMenuButton<String>(
            icon: const Icon(Icons.category),
            onSelected: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'all',
                    child: Text('All Categories'),
                  ),
                  const PopupMenuItem(value: 'work', child: Text('Work')),
                  const PopupMenuItem(
                    value: 'personal',
                    child: Text('Personal'),
                  ),
                  const PopupMenuItem(
                    value: 'shopping',
                    child: Text('Shopping'),
                  ),
                  const PopupMenuItem(value: 'health', child: Text('Health')),
                ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Statistics Card
          _buildStatisticsCard(),

          // Task List
          Expanded(child: _buildTaskList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddTask(),
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Build statistics card showing task counts
  Widget _buildStatisticsCard() {
    return FutureBuilder<Map<String, int>>(
      future: _taskService.getTaskStatistics(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError) {
          return Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Error loading statistics: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        final stats =
            snapshot.data ?? {'total': 0, 'completed': 0, 'pending': 0};

        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Total', stats['total']!, Colors.blue),
                _buildStatItem('Completed', stats['completed']!, Colors.green),
                _buildStatItem('Pending', stats['pending']!, Colors.orange),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  /// Build task list using StreamBuilder for real-time data
  Widget _buildTaskList() {
    // Get the appropriate stream based on filters
    Stream<List<Task>> taskStream = _getFilteredTaskStream();

    return StreamBuilder<List<Task>>(
      stream: taskStream,
      builder: (context, snapshot) {
        // Handle different connection states
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading tasks...'),
              ],
            ),
          );
        }

        // Handle errors
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Handle empty state
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.task_alt, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No tasks found',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Tap the + button to add your first task',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Display tasks
        final tasks = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return _buildTaskCard(task);
          },
        );
      },
    );
  }

  /// Get filtered task stream based on current filters
  Stream<List<Task>> _getFilteredTaskStream() {
    if (_selectedCategory != 'all') {
      return _taskService.getTasksByCategory(_selectedCategory);
    }

    if (_selectedFilter == 'completed') {
      return _taskService.getCompletedTasks();
    }

    if (_selectedFilter == 'pending') {
      return _taskService.getAllTasks().map(
        (tasks) => tasks.where((task) => !task.isCompleted).toList(),
      );
    }

    return _taskService.getAllTasks();
  }

  /// Build individual task card
  Widget _buildTaskCard(Task task) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) => _toggleTaskCompletion(task),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted ? Colors.grey : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description.isNotEmpty)
              Text(
                task.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: task.isCompleted ? Colors.grey : null),
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildPriorityChip(task.priority),
                const SizedBox(width: 8),
                _buildCategoryChip(task.category),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleTaskAction(value, task),
          itemBuilder:
              (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
        ),
        onTap: () => _navigateToTaskDetails(task),
      ),
    );
  }

  Widget _buildPriorityChip(String priority) {
    Color color;
    switch (priority) {
      case 'high':
        color = Colors.red;
        break;
      case 'medium':
        color = Colors.orange;
        break;
      case 'low':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(
        priority.toUpperCase(),
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
      backgroundColor: color,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildCategoryChip(String category) {
    return Chip(
      label: Text(category, style: const TextStyle(fontSize: 10)),
      backgroundColor: Colors.blue.shade100,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  /// Handle task actions (edit, delete)
  void _handleTaskAction(String action, Task task) {
    switch (action) {
      case 'edit':
        _navigateToEditTask(task);
        break;
      case 'delete':
        _showDeleteConfirmation(task);
        break;
    }
  }

  /// Toggle task completion status
  void _toggleTaskCompletion(Task task) async {
    try {
      await _taskService.toggleTaskCompletion(task.id, !task.isCompleted);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              task.isCompleted ? 'Task marked as pending' : 'Task completed!',
            ),
            backgroundColor: task.isCompleted ? Colors.orange : Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${_taskService.handleFirestoreError(e)}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Show delete confirmation dialog
  void _showDeleteConfirmation(Task task) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Task'),
            content: Text('Are you sure you want to delete "${task.title}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _deleteTask(task);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  /// Delete task
  void _deleteTask(Task task) async {
    try {
      await _taskService.deleteTask(task.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${_taskService.handleFirestoreError(e)}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Navigate to add task page
  void _navigateToAddTask() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskPage()),
    );
  }

  /// Navigate to edit task page
  void _navigateToEditTask(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskPage(task: task)),
    );
  }

  /// Navigate to task details page
  void _navigateToTaskDetails(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailsPage(task: task)),
    );
  }
}
