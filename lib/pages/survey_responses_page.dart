import 'package:flutter/material.dart';
import '../models/survey.dart';
import '../services/firestore_service.dart';

class SurveyResponsesPage extends StatefulWidget {
  const SurveyResponsesPage({super.key});

  @override
  State<SurveyResponsesPage> createState() => _SurveyResponsesPageState();
}

class _SurveyResponsesPageState extends State<SurveyResponsesPage> {
  String? _selectedSurveyId;
  List<Survey> _surveys = [];
  bool _isLoadingSurveys = false;

  @override
  void initState() {
    super.initState();
    _loadSurveys();
  }

  Future<void> _loadSurveys() async {
    setState(() {
      _isLoadingSurveys = true;
    });

    try {
      // Get surveys from stream and convert to list
      final surveysStream = FirestoreService.getSurveysStream();
      await for (final surveys in surveysStream) {
        if (mounted) {
          setState(() {
            _surveys = surveys;
            _isLoadingSurveys = false;
          });
          break; // Just get the first snapshot
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingSurveys = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error loading surveys: ${FirestoreService.handleFirestoreError(e)}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey Responses'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Survey Selection
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Survey',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_isLoadingSurveys)
                      const Center(child: CircularProgressIndicator())
                    else
                      DropdownButtonFormField<String>(
                        value: _selectedSurveyId,
                        decoration: const InputDecoration(
                          labelText: 'Choose a survey',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.quiz),
                        ),
                        items:
                            _surveys.map((survey) {
                              return DropdownMenuItem(
                                value: survey.id,
                                child: Text(survey.title),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSurveyId = value;
                          });
                        },
                      ),
                    if (_surveys.isEmpty && !_isLoadingSurveys)
                      const Text(
                        'No surveys available. Create a survey first.',
                        style: TextStyle(color: Colors.grey),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Responses List
          Expanded(
            child:
                _selectedSurveyId == null
                    ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.analytics_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Select a survey to view responses',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                    : _buildResponsesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsesList() {
    return StreamBuilder<List<SurveyResponse>>(
      stream: FirestoreService.getSurveyResponsesStream(_selectedSurveyId!),
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
                Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No responses yet',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                Text(
                  'Responses will appear here when users submit the survey',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final responses = snapshot.data!;
        final survey = _surveys.firstWhere((s) => s.id == _selectedSurveyId);

        return Column(
          children: [
            // Response Statistics
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard(
                      'Total Responses',
                      '${responses.length}',
                      Icons.people,
                      Colors.blue,
                    ),
                    _buildStatCard(
                      'Questions',
                      '${survey.questions.length}',
                      Icons.quiz,
                      Colors.green,
                    ),
                    _buildStatCard(
                      'Completion Rate',
                      '100%', // All responses are complete
                      Icons.check_circle,
                      Colors.orange,
                    ),
                  ],
                ),
              ),
            ),

            // Responses List
            Expanded(
              child: ListView.builder(
                itemCount: responses.length,
                itemBuilder: (context, index) {
                  final response = responses[index];
                  return _buildResponseCard(response, survey, index + 1);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildResponseCard(
    SurveyResponse response,
    Survey survey,
    int responseNumber,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text('$responseNumber'),
        ),
        title: Text(response.respondentName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(response.respondentEmail),
            Text(
              'Submitted: ${_formatDate(response.submittedAt)}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () => _deleteResponse(response),
          icon: const Icon(Icons.delete, color: Colors.red),
          tooltip: 'Delete Response',
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Answers:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...response.answers.map((answer) {
                  final question = survey.questions.firstWhere(
                    (q) => q.id == answer.questionId,
                    orElse:
                        () => Question(
                          id: answer.questionId,
                          text: 'Question not found',
                          type: QuestionType.text,
                        ),
                  );
                  return _buildAnswerItem(question, answer);
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerItem(Question question, Answer answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.text,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: _buildAnswerContent(question, answer),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerContent(Question question, Answer answer) {
    switch (question.type) {
      case QuestionType.text:
        return Text(
          answer.text.isNotEmpty ? answer.text : 'No answer provided',
        );

      case QuestionType.singleChoice:
      case QuestionType.yesNo:
        return Text(
          answer.selectedOptions.isNotEmpty
              ? answer.selectedOptions.join(', ')
              : 'No answer provided',
        );

      case QuestionType.multipleChoice:
        return Text(
          answer.selectedOptions.isNotEmpty
              ? answer.selectedOptions.join(', ')
              : 'No answer provided',
        );

      case QuestionType.rating:
        return Row(
          children: [
            ...List.generate(5, (index) {
              return Icon(
                index < answer.rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 20,
              );
            }),
            const SizedBox(width: 8),
            Text('(${answer.rating}/5)'),
          ],
        );
    }
  }

  void _deleteResponse(SurveyResponse response) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Response'),
            content: Text(
              'Are you sure you want to delete the response from ${response.respondentName}?',
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
        await FirestoreService.deleteSurveyResponse(response.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Response deleted successfully'),
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
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
