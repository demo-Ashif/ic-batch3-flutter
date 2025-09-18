import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

/// AddTaskPage demonstrates CREATE and UPDATE operations in Firestore
/// This page shows form validation and error handling
class AddTaskPage extends StatefulWidget {
  final Task? task; // If provided, we're editing; if null, we're creating

  const AddTaskPage({super.key, this.task});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final TaskService _taskService = TaskService();

  String _selectedPriority = 'medium';
  String _selectedCategory = 'personal';
  bool _isLoading = false;

  // Available options for dropdowns
  final List<String> _priorities = ['low', 'medium', 'high'];
  final List<String> _categories = [
    'work',
    'personal',
    'shopping',
    'health',
    'education',
  ];

  @override
  void initState() {
    super.initState();
    // If editing an existing task, populate the form
    if (widget.task != null) {
      _populateForm();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// Populate form fields when editing an existing task
  void _populateForm() {
    final task = widget.task!;
    _titleController.text = task.title;
    _descriptionController.text = task.description;
    _selectedPriority = task.priority;
    _selectedCategory = task.category;
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Add New Task'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Title Field
                      _buildTitleField(),
                      const SizedBox(height: 16),

                      // Description Field
                      _buildDescriptionField(),
                      const SizedBox(height: 16),

                      // Priority Dropdown
                      _buildPriorityDropdown(),
                      const SizedBox(height: 16),

                      // Category Dropdown
                      _buildCategoryDropdown(),
                      const SizedBox(height: 24),

                      // Action Buttons
                      _buildActionButtons(isEditing),
                    ],
                  ),
                ),
              ),
    );
  }

  /// Build title input field with validation
  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Task Title *',
        hintText: 'Enter task title',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.title),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Task title is required';
        }
        if (value.length > 100) {
          return 'Title cannot exceed 100 characters';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
    );
  }

  /// Build description input field with validation
  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Description',
        hintText: 'Enter task description (optional)',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.description),
      ),
      maxLines: 3,
      validator: (value) {
        if (value != null && value.length > 500) {
          return 'Description cannot exceed 500 characters';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
    );
  }

  /// Build priority dropdown
  Widget _buildPriorityDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedPriority,
      decoration: const InputDecoration(
        labelText: 'Priority *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.priority_high),
      ),
      items:
          _priorities.map((priority) {
            return DropdownMenuItem(
              value: priority,
              child: Row(
                children: [
                  _getPriorityIcon(priority),
                  const SizedBox(width: 8),
                  Text(priority.toUpperCase()),
                ],
              ),
            );
          }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedPriority = value!;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a priority';
        }
        return null;
      },
    );
  }

  /// Build category dropdown
  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: const InputDecoration(
        labelText: 'Category *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.category),
      ),
      items:
          _categories.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Row(
                children: [
                  _getCategoryIcon(category),
                  const SizedBox(width: 8),
                  Text(category.toUpperCase()),
                ],
              ),
            );
          }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategory = value!;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a category';
        }
        return null;
      },
    );
  }

  /// Build action buttons (Save/Update)
  Widget _buildActionButtons(bool isEditing) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveTask,
            child: Text(isEditing ? 'Update Task' : 'Create Task'),
          ),
        ),
      ],
    );
  }

  /// Get priority icon based on priority level
  Widget _getPriorityIcon(String priority) {
    IconData iconData;
    Color color;

    switch (priority) {
      case 'high':
        iconData = Icons.keyboard_arrow_up;
        color = Colors.red;
        break;
      case 'medium':
        iconData = Icons.remove;
        color = Colors.orange;
        break;
      case 'low':
        iconData = Icons.keyboard_arrow_down;
        color = Colors.green;
        break;
      default:
        iconData = Icons.remove;
        color = Colors.grey;
    }

    return Icon(iconData, color: color, size: 20);
  }

  /// Get category icon based on category
  Widget _getCategoryIcon(String category) {
    IconData iconData;

    switch (category) {
      case 'work':
        iconData = Icons.work;
        break;
      case 'personal':
        iconData = Icons.person;
        break;
      case 'shopping':
        iconData = Icons.shopping_cart;
        break;
      case 'health':
        iconData = Icons.health_and_safety;
        break;
      case 'education':
        iconData = Icons.school;
        break;
      default:
        iconData = Icons.category;
    }

    return Icon(iconData, size: 20);
  }

  /// Save or update task
  void _saveTask() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create Task object
      final now = DateTime.now();
      final task = Task(
        id:
            widget.task?.id ??
            '', // Will be generated by Firestore for new tasks
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        isCompleted: widget.task?.isCompleted ?? false,
        createdAt: widget.task?.createdAt ?? now,
        updatedAt: now,
        priority: _selectedPriority,
        category: _selectedCategory,
      );

      // Validate task data using service validation
      final validationError = _taskService.validateTask(task);
      if (validationError != null) {
        _showErrorSnackBar(validationError);
        return;
      }

      // Save to Firestore
      if (widget.task != null) {
        // UPDATE operation
        await _taskService.updateTask(task);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Task updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // CREATE operation
        await _taskService.createTask(task);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Task created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      // Navigate back
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      // Handle errors
      if (mounted) {
        _showErrorSnackBar(_taskService.handleFirestoreError(e));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Show error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
