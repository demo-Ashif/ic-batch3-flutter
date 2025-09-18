import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';
import '../services/task_service.dart';

/// QueryComparisonPage demonstrates the difference between normal and optimized queries
/// This page shows performance differences and best practices
class QueryComparisonPage extends StatefulWidget {
  const QueryComparisonPage({super.key});

  @override
  State<QueryComparisonPage> createState() => _QueryComparisonPageState();
}

class _QueryComparisonPageState extends State<QueryComparisonPage> {
  final TaskService _taskService = TaskService();

  // Normal query results
  List<Task> _normalQueryResults = [];
  bool _normalQueryLoading = false;
  String? _normalQueryError;
  Duration _normalQueryTime = Duration.zero;

  // Optimized query results
  List<Task> _optimizedQueryResults = [];
  bool _optimizedQueryLoading = false;
  String? _optimizedQueryError;
  Duration _optimizedQueryTime = Duration.zero;

  // Pagination for optimized query
  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Query Performance Comparison'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Introduction Card
            _buildIntroductionCard(),
            const SizedBox(height: 16),

            // Normal Query Section
            _buildNormalQuerySection(),
            const SizedBox(height: 16),

            // Optimized Query Section
            _buildOptimizedQuerySection(),
            const SizedBox(height: 16),

            // Performance Comparison
            _buildPerformanceComparison(),
          ],
        ),
      ),
    );
  }

  /// Build introduction card explaining the comparison
  Widget _buildIntroductionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Query Performance Comparison',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'This page demonstrates the difference between normal and optimized Firestore queries. '
              'Notice how optimized queries can improve performance and reduce costs.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 Key Differences:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text('• Normal queries fetch all data at once'),
                  Text('• Optimized queries use pagination and indexing'),
                  Text(
                    '• Optimized queries reduce bandwidth and improve performance',
                  ),
                  Text('• Proper indexing is crucial for compound queries'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build normal query section
  Widget _buildNormalQuerySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Normal Query (All Tasks)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _normalQueryLoading ? null : _runNormalQuery,
                  child:
                      _normalQueryLoading
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Text('Run Query'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'This query fetches all tasks at once. While simple, it can be slow and expensive for large datasets.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            if (_normalQueryTime != Duration.zero)
              _buildQueryInfo(
                'Execution Time',
                '${_normalQueryTime.inMilliseconds}ms',
              ),
            if (_normalQueryError != null) _buildErrorInfo(_normalQueryError!),
            if (_normalQueryResults.isNotEmpty)
              _buildResultsList(_normalQueryResults, 'normal'),
          ],
        ),
      ),
    );
  }

  /// Build optimized query section
  Widget _buildOptimizedQuerySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Optimized Query (With Pagination)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _optimizedQueryLoading ? null : _runOptimizedQuery,
                  child:
                      _optimizedQueryLoading
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Text('Run Query'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'This query uses pagination to fetch tasks in smaller batches. It\'s faster and more cost-effective.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            if (_optimizedQueryTime != Duration.zero)
              _buildQueryInfo(
                'Execution Time',
                '${_optimizedQueryTime.inMilliseconds}ms',
              ),
            if (_optimizedQueryError != null)
              _buildErrorInfo(_optimizedQueryError!),
            if (_optimizedQueryResults.isNotEmpty)
              _buildResultsList(_optimizedQueryResults, 'optimized'),
            if (_hasMoreData && _optimizedQueryResults.isNotEmpty)
              Center(
                child: TextButton(
                  onPressed: _loadMoreOptimizedResults,
                  child: const Text('Load More Results'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Build performance comparison section
  Widget _buildPerformanceComparison() {
    if (_normalQueryTime == Duration.zero ||
        _optimizedQueryTime == Duration.zero) {
      return const SizedBox.shrink();
    }

    final improvement =
        _normalQueryTime.inMilliseconds - _optimizedQueryTime.inMilliseconds;
    final improvementPercent =
        (_normalQueryTime.inMilliseconds > 0)
            ? (improvement / _normalQueryTime.inMilliseconds * 100)
                .toStringAsFixed(1)
            : '0';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Performance Comparison',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildComparisonItem(
                    'Normal Query',
                    '${_normalQueryTime.inMilliseconds}ms',
                    Colors.red,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildComparisonItem(
                    'Optimized Query',
                    '${_optimizedQueryTime.inMilliseconds}ms',
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    improvement > 0 ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      improvement > 0
                          ? Colors.green.shade200
                          : Colors.red.shade200,
                ),
              ),
              child: Text(
                improvement > 0
                    ? '🚀 Optimized query is $improvementPercent% faster!'
                    : '⚠️ Normal query was faster in this case',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      improvement > 0
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build comparison item
  Widget _buildComparisonItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// Build query info
  Widget _buildQueryInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }

  /// Build error info
  Widget _buildErrorInfo(String error) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.error, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(error, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// Build results list
  Widget _buildResultsList(List<Task> tasks, String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Results (${tasks.length} tasks):',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                leading: Icon(
                  task.isCompleted
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: task.isCompleted ? Colors.green : Colors.grey,
                ),
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration:
                        task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text(
                  '${task.priority.toUpperCase()} • ${task.category}',
                ),
                dense: true,
              );
            },
          ),
        ),
      ],
    );
  }

  /// Run normal query
  void _runNormalQuery() async {
    setState(() {
      _normalQueryLoading = true;
      _normalQueryError = null;
      _normalQueryResults.clear();
    });

    final stopwatch = Stopwatch()..start();

    try {
      // Simulate normal query by getting all tasks
      final stream = _taskService.getAllTasks();
      final tasks = await stream.first;

      stopwatch.stop();

      setState(() {
        _normalQueryLoading = false;
        _normalQueryResults = tasks;
        _normalQueryTime = stopwatch.elapsed;
      });
    } catch (e) {
      stopwatch.stop();
      setState(() {
        _normalQueryLoading = false;
        _normalQueryError = _taskService.handleFirestoreError(e);
        _normalQueryTime = stopwatch.elapsed;
      });
    }
  }

  /// Run optimized query
  void _runOptimizedQuery() async {
    setState(() {
      _optimizedQueryLoading = true;
      _optimizedQueryError = null;
      _optimizedQueryResults.clear();
      _lastDocument = null;
      _hasMoreData = true;
    });

    final stopwatch = Stopwatch()..start();

    try {
      // Use pagination to get first batch
      final tasks = await _taskService.getTasksWithPagination(
        limit: 10,
        lastDocument: _lastDocument,
      );

      stopwatch.stop();

      setState(() {
        _optimizedQueryLoading = false;
        _optimizedQueryResults = tasks;
        _optimizedQueryTime = stopwatch.elapsed;
        _hasMoreData =
            tasks.length == 10; // If we got exactly 10, there might be more
      });
    } catch (e) {
      stopwatch.stop();
      setState(() {
        _optimizedQueryLoading = false;
        _optimizedQueryError = _taskService.handleFirestoreError(e);
        _optimizedQueryTime = stopwatch.elapsed;
      });
    }
  }

  /// Load more optimized results
  void _loadMoreOptimizedResults() async {
    if (!_hasMoreData || _optimizedQueryLoading) return;

    setState(() {
      _optimizedQueryLoading = true;
    });

    try {
      final tasks = await _taskService.getTasksWithPagination(
        limit: 10,
        lastDocument: _lastDocument,
      );

      setState(() {
        _optimizedQueryResults.addAll(tasks);
        _optimizedQueryLoading = false;
        _hasMoreData = tasks.length == 10;
      });
    } catch (e) {
      setState(() {
        _optimizedQueryLoading = false;
        _optimizedQueryError = _taskService.handleFirestoreError(e);
      });
    }
  }
}
