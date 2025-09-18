import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

/// TaskService class demonstrates all Firestore CRUD operations
/// This is the main service for interacting with Firestore database
class TaskService {
  // Reference to the 'tasks' collection in Firestore
  final CollectionReference _tasksCollection = FirebaseFirestore.instance
      .collection('tasks');

  /// CREATE DATA - Add a new task to Firestore
  /// Demonstrates how to create data in Firestore
  Future<String> createTask(Task task) async {
    try {
      // Add the task to Firestore and get the document reference
      DocumentReference docRef = await _tasksCollection.add(task.toFirestore());

      // Return the generated document ID
      return docRef.id;
    } catch (e) {
      // Handle Firestore errors
      throw Exception('Failed to create task: $e');
    }
  }

  /// READ DATA IN REAL-TIME - Get all tasks as a stream
  /// Demonstrates how to read data in real-time using StreamBuilder
  Stream<List<Task>> getAllTasks() {
    try {
      return _tasksCollection
          .orderBy('createdAt', descending: true) // Order by creation date
          .snapshots() // This creates a real-time stream
          .map((snapshot) {
            return snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
          });
    } catch (e) {
      // Handle Firestore errors
      throw Exception('Failed to fetch tasks: $e');
    }
  }

  /// READ DATA - Get tasks by category (Basic Query)
  /// Demonstrates basic Firestore querying
  Stream<List<Task>> getTasksByCategory(String category) {
    try {
      return _tasksCollection
          .where('category', isEqualTo: category)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
          });
    } catch (e) {
      throw Exception('Failed to fetch tasks by category: $e');
    }
  }

  /// READ DATA - Get completed tasks (Basic Query)
  /// Demonstrates filtering by boolean field
  Stream<List<Task>> getCompletedTasks() {
    try {
      return _tasksCollection
          .where('isCompleted', isEqualTo: true)
          .orderBy('updatedAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
          });
    } catch (e) {
      throw Exception('Failed to fetch completed tasks: $e');
    }
  }

  /// OPTIMIZED QUERY - Get tasks with pagination
  /// Demonstrates optimized Firestore queries for performance
  Future<List<Task>> getTasksWithPagination({
    required int limit,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query = _tasksCollection
          .orderBy('createdAt', descending: true)
          .limit(limit);

      // If we have a last document, start after it (for pagination)
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      QuerySnapshot snapshot = await query.get();


      return snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch tasks with pagination: $e');
    }
  }

  /// OPTIMIZED QUERY - Get tasks by priority with compound query
  /// Demonstrates compound queries and indexing
  Stream<List<Task>> getTasksByPriority(String priority) {
    try {
      return _tasksCollection
          .where('priority', isEqualTo: priority)
          .where('isCompleted', isEqualTo: false) // Only incomplete tasks
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
          });
    } catch (e) {
      throw Exception('Failed to fetch tasks by priority: $e');
    }
  }

  /// UPDATE DATA - Update an existing task
  /// Demonstrates how to update data in Firestore
  Future<void> updateTask(Task task) async {
    try {
      // Update the task with new updatedAt timestamp
      Task updatedTask = task.copyWith(updatedAt: DateTime.now());

      await _tasksCollection.doc(task.id).update(updatedTask.toFirestore());
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  /// UPDATE DATA - Toggle task completion status
  /// Demonstrates partial updates
  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
    try {
      await _tasksCollection.doc(taskId).update({
        'isCompleted': isCompleted,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to toggle task completion: $e');
    }
  }

  /// DELETE DATA - Delete a task from Firestore
  /// Demonstrates how to delete data from Firestore
  Future<void> deleteTask(String taskId) async {
    try {
      await _tasksCollection.doc(taskId).delete();
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  /// DELETE DATA - Delete multiple tasks
  /// Demonstrates batch operations
  Future<void> deleteMultipleTasks(List<String> taskIds) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (String taskId in taskIds) {
        batch.delete(_tasksCollection.doc(taskId));
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete multiple tasks: $e');
    }
  }

  /// VALIDATION - Validate task data before saving
  /// Demonstrates data validation
  String? validateTask(Task task) {
    if (task.title.trim().isEmpty) {
      return 'Task title cannot be empty';
    }

    if (task.title.length > 100) {
      return 'Task title cannot exceed 100 characters';
    }

    if (task.description.length > 500) {
      return 'Task description cannot exceed 500 characters';
    }

    if (!['low', 'medium', 'high'].contains(task.priority)) {
      return 'Priority must be low, medium, or high';
    }

    if (task.category.trim().isEmpty) {
      return 'Category cannot be empty';
    }

    return null; // No validation errors
  }

  /// ERROR HANDLING - Handle Firestore errors gracefully
  /// Demonstrates comprehensive error handling
  String handleFirestoreError(dynamic error) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return 'You do not have permission to perform this action';
        case 'unavailable':
          return 'Firestore is currently unavailable. Please try again later';
        case 'deadline-exceeded':
          return 'Request timed out. Please check your internet connection';
        case 'resource-exhausted':
          return 'Too many requests. Please try again later';
        case 'unauthenticated':
          return 'You need to be logged in to perform this action';
        case 'not-found':
          return 'The requested data was not found';
        default:
          return 'An error occurred: ${error.message}';
      }
    }
    return 'An unexpected error occurred: $error';
  }

  /// UTILITY - Get task statistics
  /// Demonstrates aggregation queries
  Future<Map<String, int>> getTaskStatistics() async {
    try {
      QuerySnapshot allTasks = await _tasksCollection.get();
      QuerySnapshot completedTasks =
          await _tasksCollection.where('isCompleted', isEqualTo: true).get();

      return {
        'total': allTasks.docs.length,
        'completed': completedTasks.docs.length,
        'pending': allTasks.docs.length - completedTasks.docs.length,
      };
    } catch (e) {
      throw Exception('Failed to get task statistics: $e');
    }
  }
}
