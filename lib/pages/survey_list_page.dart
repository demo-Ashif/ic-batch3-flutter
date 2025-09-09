import 'package:flutter/material.dart';
import '../models/survey.dart';
import '../services/firestore_service.dart';
import 'take_survey_page.dart';

class SurveyListPage extends StatefulWidget {
  const SurveyListPage({super.key});

  @override
  State<SurveyListPage> createState() => _SurveyListPageState();
}

class _SurveyListPageState extends State<SurveyListPage> {
  bool _showActiveOnly = true;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Surveys'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(
              _showActiveOnly ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _showActiveOnly = !_showActiveOnly;
              });
            },
            tooltip: _showActiveOnly ? 'Show All Surveys' : 'Show Active Only',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search surveys...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon:
                        _searchQuery.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                            : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('Active Only: '),
                    Switch(
                      value: _showActiveOnly,
                      onChanged: (value) {
                        setState(() {
                          _showActiveOnly = value;
                        });
                      },
                    ),
                    const Spacer(),
                    Text(
                      'Real-time updates enabled',
                      style: TextStyle(color: Colors.green, fontSize: 12),
                    ),
                    const Icon(Icons.wifi, color: Colors.green, size: 16),
                  ],
                ),
              ],
            ),
          ),
          // Surveys List
          Expanded(child: _buildSurveysList()),
        ],
      ),
    );
  }

  Widget _buildSurveysList() {
    return StreamBuilder<List<Survey>>(
      stream:
          _showActiveOnly
              ? FirestoreService.getActiveSurveysStream()
              : FirestoreService.getSurveysStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.quiz_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No surveys found',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                Text(
                  'Create your first survey to get started!',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        List<Survey> surveys = snapshot.data!;

        // Filter by search query
        if (_searchQuery.isNotEmpty) {
          surveys =
              surveys
                  .where(
                    (survey) =>
                        survey.title.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ) ||
                        survey.description.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ),
                  )
                  .toList();
        }

        return ListView.builder(
          itemCount: surveys.length,
          itemBuilder: (context, index) {
            final survey = surveys[index];
            return _buildSurveyCard(survey);
          },
        );
      },
    );
  }

  Widget _buildSurveyCard(Survey survey) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () => _navigateToTakeSurvey(survey),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      survey.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: survey.isActive ? Colors.green : Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      survey.isActive ? 'Active' : 'Inactive',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                survey.description,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.quiz_outlined, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${survey.questions.length} questions',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.person_outline, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    survey.createdBy,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const Spacer(),
                  Text(
                    _formatDate(survey.createdAt),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _navigateToTakeSurvey(survey),
                      icon: const Icon(Icons.play_arrow, size: 16),
                      label: const Text('Take Survey'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _showSurveyDetails(survey),
                    icon: const Icon(Icons.info_outline),
                    tooltip: 'View Details',
                  ),
                  IconButton(
                    onPressed: () => _toggleSurveyStatus(survey),
                    icon: Icon(
                      survey.isActive ? Icons.pause : Icons.play_arrow,
                    ),
                    tooltip: survey.isActive ? 'Deactivate' : 'Activate',
                  ),
                  IconButton(
                    onPressed: () => _deleteSurvey(survey),
                    icon: const Icon(Icons.delete),
                    tooltip: 'Delete Survey',
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToTakeSurvey(Survey survey) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TakeSurveyPage(survey: survey)),
    );
  }

  void _showSurveyDetails(Survey survey) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(survey.title),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Description: ${survey.description}'),
                  const SizedBox(height: 8),
                  Text('Questions: ${survey.questions.length}'),
                  const SizedBox(height: 8),
                  Text('Created by: ${survey.createdBy}'),
                  const SizedBox(height: 8),
                  Text('Created: ${_formatDate(survey.createdAt)}'),
                  const SizedBox(height: 8),
                  Text('Updated: ${_formatDate(survey.updatedAt)}'),
                  const SizedBox(height: 8),
                  Text('Status: ${survey.isActive ? 'Active' : 'Inactive'}'),
                  const SizedBox(height: 16),
                  const Text(
                    'Questions:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...survey.questions.map(
                    (question) => Padding(
                      padding: const EdgeInsets.only(left: 8, top: 4),
                      child: Text(
                        '• ${question.text} (${question.type.toString().split('.').last})',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _toggleSurveyStatus(Survey survey) async {
    try {
      await FirestoreService.toggleSurveyStatus(survey.id!, !survey.isActive);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Survey ${survey.isActive ? 'deactivated' : 'activated'} successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${FirestoreService.handleFirestoreError(e)}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _deleteSurvey(Survey survey) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Survey'),
            content: Text(
              'Are you sure you want to delete "${survey.title}"? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        await FirestoreService.deleteSurveyWithResponses(survey.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Survey deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error: ${FirestoreService.handleFirestoreError(e)}',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
