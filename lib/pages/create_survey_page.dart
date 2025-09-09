import 'package:flutter/material.dart';
import '../models/survey.dart';
import '../services/firestore_service.dart';

class CreateSurveyPage extends StatefulWidget {
  final Survey? survey; // If provided, we're editing an existing survey

  const CreateSurveyPage({super.key, this.survey});

  @override
  State<CreateSurveyPage> createState() => _CreateSurveyPageState();
}

class _CreateSurveyPageState extends State<CreateSurveyPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _createdByController = TextEditingController();

  List<Question> _questions = [];
  bool _isLoading = false;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _createdByController.text = 'Current User'; // In a real app, get from auth

    if (widget.survey != null) {
      _titleController.text = widget.survey!.title;
      _descriptionController.text = widget.survey!.description;
      _createdByController.text = widget.survey!.createdBy;
      _questions = List.from(widget.survey!.questions);
      _isActive = widget.survey!.isActive;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _createdByController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.survey == null ? 'Create Survey' : 'Edit Survey'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (widget.survey != null)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _isLoading ? null : _saveSurvey,
              tooltip: 'Save Changes',
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Survey Basic Info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Survey Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Survey Title',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.title),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a survey title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _createdByController,
                        decoration: const InputDecoration(
                          labelText: 'Created By',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter creator name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Text('Active: '),
                          Switch(
                            value: _isActive,
                            onChanged: (value) {
                              setState(() {
                                _isActive = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Questions Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Questions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton.icon(
                    onPressed: _addQuestion,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Question'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Questions List
              if (_questions.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.quiz_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No questions yet',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const Text(
                          'Add your first question to get started',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ..._questions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final question = entry.value;
                  return _buildQuestionCard(question, index);
                }).toList(),

              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveSurvey,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child:
                          _isLoading
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
                                  Text('Saving...'),
                                ],
                              )
                              : Text(
                                widget.survey == null
                                    ? 'Create Survey'
                                    : 'Update Survey',
                                style: const TextStyle(fontSize: 16),
                              ),
                    ),
                  ),
                  if (widget.survey != null) ...[
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : _deleteSurvey,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Delete Survey'),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(Question question, int index) {
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
                    '${index + 1}',
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
                IconButton(
                  onPressed: () => _editQuestion(index),
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit Question',
                ),
                IconButton(
                  onPressed: () => _deleteQuestion(index),
                  icon: const Icon(Icons.delete),
                  tooltip: 'Delete Question',
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(question.type.toString().split('.').last),
                  backgroundColor: Colors.blue.withOpacity(0.1),
                ),
                const SizedBox(width: 8),
                if (question.isRequired)
                  const Chip(
                    label: Text('Required'),
                    backgroundColor: Colors.red,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                if (question.options.isNotEmpty)
                  Chip(
                    label: Text('${question.options.length} options'),
                    backgroundColor: Colors.green.withOpacity(0.1),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addQuestion() {
    _showQuestionDialog();
  }

  void _editQuestion(int index) {
    _showQuestionDialog(question: _questions[index], index: index);
  }

  void _deleteQuestion(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Question'),
            content: const Text(
              'Are you sure you want to delete this question?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _questions.removeAt(index);
                  });
                  Navigator.pop(context);
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

  void _showQuestionDialog({Question? question, int? index}) {
    final isEditing = question != null && index != null;

    final questionController = TextEditingController(
      text: question?.text ?? '',
    );
    QuestionType selectedType = question?.type ?? QuestionType.text;
    bool isRequired = question?.isRequired ?? true;
    final optionsController = TextEditingController(
      text: question?.options.join('\n') ?? '',
    );

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setDialogState) => AlertDialog(
                  title: Text(isEditing ? 'Edit Question' : 'Add Question'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: questionController,
                          decoration: const InputDecoration(
                            labelText: 'Question Text',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<QuestionType>(
                          value: selectedType,
                          decoration: const InputDecoration(
                            labelText: 'Question Type',
                            border: OutlineInputBorder(),
                          ),
                          items:
                              QuestionType.values.map((type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Text(type.toString().split('.').last),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setDialogState(() {
                              selectedType = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Text('Required: '),
                            Switch(
                              value: isRequired,
                              onChanged: (value) {
                                setDialogState(() {
                                  isRequired = value;
                                });
                              },
                            ),
                          ],
                        ),
                        if (selectedType == QuestionType.multipleChoice ||
                            selectedType == QuestionType.singleChoice) ...[
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: optionsController,
                            decoration: const InputDecoration(
                              labelText: 'Options (one per line)',
                              border: OutlineInputBorder(),
                              hintText: 'Option 1\nOption 2\nOption 3',
                            ),
                            maxLines: 5,
                          ),
                        ],
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (questionController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter question text'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        final options =
                            optionsController.text
                                .split('\n')
                                .where((option) => option.trim().isNotEmpty)
                                .map((option) => option.trim())
                                .toList();

                        if ((selectedType == QuestionType.multipleChoice ||
                                selectedType == QuestionType.singleChoice) &&
                            options.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter at least one option'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        final newQuestion = Question(
                          id:
                              question?.id ??
                              DateTime.now().millisecondsSinceEpoch.toString(),
                          text: questionController.text,
                          type: selectedType,
                          options: options,
                          isRequired: isRequired,
                        );

                        setState(() {
                          if (isEditing) {
                            _questions[index] = newQuestion;
                          } else {
                            _questions.add(newQuestion);
                          }
                        });

                        Navigator.pop(context);
                      },
                      child: Text(isEditing ? 'Update' : 'Add'),
                    ),
                  ],
                ),
          ),
    );
  }

  void _saveSurvey() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one question'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final survey = Survey(
        id: widget.survey?.id,
        title: _titleController.text,
        description: _descriptionController.text,
        questions: _questions,
        createdAt: widget.survey?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        createdBy: _createdByController.text,
        isActive: _isActive,
      );

      if (widget.survey == null) {
        await FirestoreService.createSurvey(survey);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Survey created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } else {
        await FirestoreService.updateSurvey(widget.survey!.id!, survey);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Survey updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
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
          _isLoading = false;
        });
      }
    }
  }

  void _deleteSurvey() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Survey'),
            content: const Text(
              'Are you sure you want to delete this survey? This will also delete all responses. This action cannot be undone.',
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
        await FirestoreService.deleteSurveyWithResponses(widget.survey!.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Survey deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
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
}
