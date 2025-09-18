import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import 'add_task_page.dart';

/// TaskDetailsPage demonstrates detailed task viewing and management
/// This page shows how to display individual task data
class TaskDetailsPage extends StatefulWidget {
  final Task task;

  const TaskDetailsPage({super.key, required this.task});

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  final TaskService _taskService = TaskService();
  late Task _currentTask;

  @override
  void initState() {
    super.initState();
    _currentTask = widget.task;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<String>(
            onSelected: _handleAction,
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
                  PopupMenuItem(
                    value: 'toggle',
                    child: Row(
                      children: [
                        Icon(
                          _currentTask.isCompleted ? Icons.undo : Icons.check,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _currentTask.isCompleted
                              ? 'Mark Pending'
                              : 'Mark Complete',
                        ),
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
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Status Card
            _buildStatusCard(),
            const SizedBox(height: 16),

            // Task Information Card
            _buildTaskInfoCard(),
            const SizedBox(height: 16),

            // Priority and Category Card
            _buildPriorityCategoryCard(),
            const SizedBox(height: 16),

            // Timestamps Card
            _buildTimestampsCard(),
            const SizedBox(height: 24),

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  /// Build task status card
  Widget _buildStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              _currentTask.isCompleted
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: _currentTask.isCompleted ? Colors.green : Colors.grey,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentTask.isCompleted ? 'COMPLETED' : 'PENDING',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color:
                          _currentTask.isCompleted
                              ? Colors.green
                              : Colors.orange,
                    ),
                  ),
                  Text(
                    _currentTask.isCompleted
                        ? 'This task has been completed'
                        : 'This task is still pending',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build task information card
  Widget _buildTaskInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Task Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Title', _currentTask.title),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Description',
              _currentTask.description.isEmpty
                  ? 'No description provided'
                  : _currentTask.description,
            ),
          ],
        ),
      ),
    );
  }

  /// Build priority and category card
  Widget _buildPriorityCategoryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Priority & Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildPriorityChip(_currentTask.priority)),
                const SizedBox(width: 16),
                Expanded(child: _buildCategoryChip(_currentTask.category)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build timestamps card
  Widget _buildTimestampsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Timestamps',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Created', _formatDateTime(_currentTask.createdAt)),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Last Updated',
              _formatDateTime(_currentTask.updatedAt),
            ),
          ],
        ),
      ),
    );
  }

  /// Build action buttons
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _toggleCompletion,
            icon: Icon(_currentTask.isCompleted ? Icons.undo : Icons.check),
            label: Text(
              _currentTask.isCompleted ? 'Mark Pending' : 'Mark Complete',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _currentTask.isCompleted ? Colors.orange : Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _editTask,
            icon: const Icon(Icons.edit),
            label: const Text('Edit Task'),
          ),
        ),
      ],
    );
  }

  /// Build info row widget
  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  /// Build priority chip
  Widget _buildPriorityChip(String priority) {
    Color color;
    IconData icon;

    switch (priority) {
      case 'high':
        color = Colors.red;
        icon = Icons.keyboard_arrow_up;
        break;
      case 'medium':
        color = Colors.orange;
        icon = Icons.remove;
        break;
      case 'low':
        color = Colors.green;
        icon = Icons.keyboard_arrow_down;
        break;
      default:
        color = Colors.grey;
        icon = Icons.remove;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            priority.toUpperCase(),
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// Build category chip
  Widget _buildCategoryChip(String category) {
    IconData icon;

    switch (category) {
      case 'work':
        icon = Icons.work;
        break;
      case 'personal':
        icon = Icons.person;
        break;
      case 'shopping':
        icon = Icons.shopping_cart;
        break;
      case 'health':
        icon = Icons.health_and_safety;
        break;
      case 'education':
        icon = Icons.school;
        break;
      default:
        icon = Icons.category;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.blue, size: 16),
          const SizedBox(width: 4),
          Text(
            category.toUpperCase(),
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Format DateTime for display
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Handle popup menu actions
  void _handleAction(String action) {
    switch (action) {
      case 'edit':
        _editTask();
        break;
      case 'toggle':
        _toggleCompletion();
        break;
      case 'delete':
        _showDeleteConfirmation();
        break;
    }
  }

  /// Edit task
  void _editTask() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskPage(task: _currentTask)),
    ).then((_) {
      // Refresh the task details if we come back from editing
      setState(() {
        // In a real app, you might want to fetch the updated task from Firestore
        // For now, we'll just refresh the UI
      });
    });
  }

  /// Toggle task completion
  void _toggleCompletion() async {
    try {
      await _taskService.toggleTaskCompletion(
        _currentTask.id,
        !_currentTask.isCompleted,
      );

      setState(() {
        _currentTask = _currentTask.copyWith(
          isCompleted: !_currentTask.isCompleted,
          updatedAt: DateTime.now(),
        );
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _currentTask.isCompleted
                  ? 'Task completed!'
                  : 'Task marked as pending',
            ),
            backgroundColor:
                _currentTask.isCompleted ? Colors.green : Colors.orange,
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
  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Task'),
            content: Text(
              'Are you sure you want to delete "${_currentTask.title}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _deleteTask();
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
  void _deleteTask() async {
    try {
      await _taskService.deleteTask(_currentTask.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Go back to home page
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
}
