import 'package:flutter/material.dart';
import '../models/survey.dart';
import '../services/firestore_service.dart';

class TakeSurveyPage extends StatefulWidget {
  final Survey survey;

  const TakeSurveyPage({super.key, required this.survey});

  @override
  State<TakeSurveyPage> createState() => _TakeSurveyPageState();
}

class _TakeSurveyPageState extends State<TakeSurveyPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final Map<String, dynamic> _answers = {};
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _initializeAnswers();
  }

  void _initializeAnswers() {
    for (final question in widget.survey.questions) {
      _answers[question.id] = {
        'text': '',
        'selectedOptions': <String>[],
        'rating': 0,
      };
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.survey.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Survey Info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.survey.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.survey.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.survey.questions.length} questions',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Respondent Info
              const Text(
                'Your Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Questions
              const Text(
                'Survey Questions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              ...widget.survey.questions.asMap().entries.map((entry) {
                final index = entry.key;
                final question = entry.value;
                return _buildQuestionCard(question, index + 1);
              }).toList(),

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitSurvey,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child:
                      _isSubmitting
                          ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('Submitting...'),
                            ],
                          )
                          : const Text(
                            'Submit Survey',
                            style: TextStyle(fontSize: 16),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(Question question, int questionNumber) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$questionNumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question.text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (question.isRequired)
                  const Text(
                    '*',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _buildQuestionInput(question),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionInput(Question question) {
    switch (question.type) {
      case QuestionType.text:
        return TextFormField(
          decoration: const InputDecoration(
            hintText: 'Enter your answer...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          onChanged: (value) {
            _answers[question.id]['text'] = value;
          },
          validator:
              question.isRequired
                  ? (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  }
                  : null,
        );

      case QuestionType.singleChoice:
        return Column(
          children:
              question.options.map((option) {
                return RadioListTile<String>(
                  title: Text(option),
                  value: option,
                  groupValue:
                      _answers[question.id]['selectedOptions'].isNotEmpty
                          ? _answers[question.id]['selectedOptions'][0]
                          : null,
                  onChanged: (value) {
                    setState(() {
                      _answers[question.id]['selectedOptions'] = [value!];
                    });
                  },
                );
              }).toList(),
        );

      case QuestionType.multipleChoice:
        return Column(
          children:
              question.options.map((option) {
                return CheckboxListTile(
                  title: Text(option),
                  value: _answers[question.id]['selectedOptions'].contains(
                    option,
                  ),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _answers[question.id]['selectedOptions'].add(option);
                      } else {
                        _answers[question.id]['selectedOptions'].remove(option);
                      }
                    });
                  },
                );
              }).toList(),
        );

      case QuestionType.rating:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index < _answers[question.id]['rating']
                    ? Icons.star
                    : Icons.star_border,
                color: Colors.amber,
                size: 32,
              ),
              onPressed: () {
                setState(() {
                  _answers[question.id]['rating'] = index + 1;
                });
              },
            );
          }),
        );

      case QuestionType.yesNo:
        return Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('Yes'),
                value: true,
                groupValue:
                    _answers[question.id]['selectedOptions'].isNotEmpty
                        ? _answers[question.id]['selectedOptions'][0] == 'Yes'
                        : null,
                onChanged: (value) {
                  setState(() {
                    _answers[question.id]['selectedOptions'] = ['Yes'];
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('No'),
                value: false,
                groupValue:
                    _answers[question.id]['selectedOptions'].isNotEmpty
                        ? _answers[question.id]['selectedOptions'][0] == 'No'
                        : null,
                onChanged: (value) {
                  setState(() {
                    _answers[question.id]['selectedOptions'] = ['No'];
                  });
                },
              ),
            ),
          ],
        );
    }
  }

  void _submitSurvey() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate required questions
    for (final question in widget.survey.questions) {
      if (question.isRequired) {
        final answer = _answers[question.id];
        bool isValid = false;

        switch (question.type) {
          case QuestionType.text:
            isValid = answer['text'].toString().isNotEmpty;
            break;
          case QuestionType.singleChoice:
          case QuestionType.yesNo:
            isValid = answer['selectedOptions'].isNotEmpty;
            break;
          case QuestionType.multipleChoice:
            isValid = answer['selectedOptions'].isNotEmpty;
            break;
          case QuestionType.rating:
            isValid = answer['rating'] > 0;
            break;
        }

        if (!isValid) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please answer all required questions'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = SurveyResponse(
        surveyId: widget.survey.id!,
        respondentName: _nameController.text,
        respondentEmail: _emailController.text,
        answers:
            _answers.entries.map((entry) {
              return Answer(
                questionId: entry.key,
                text: entry.value['text'],
                selectedOptions: List<String>.from(
                  entry.value['selectedOptions'],
                ),
                rating: entry.value['rating'],
              );
            }).toList(),
        submittedAt: DateTime.now(),
      );

      await FirestoreService.submitSurveyResponse(response);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Survey submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
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
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
