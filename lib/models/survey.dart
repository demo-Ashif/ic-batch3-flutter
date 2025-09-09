import 'package:cloud_firestore/cloud_firestore.dart';

class Survey {
  final String? id;
  final String title;
  final String description;
  final List<Question> questions;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final bool isActive;

  Survey({
    this.id,
    required this.title,
    required this.description,
    required this.questions,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.isActive = true,
  });

  factory Survey.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Survey(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      questions:
          (data['questions'] as List<dynamic>?)
              ?.map((q) => Question.fromMap(q))
              .toList() ??
          [],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdBy: data['createdBy'] ?? '',
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'questions': questions.map((q) => q.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'createdBy': createdBy,
      'isActive': isActive,
    };
  }

  Survey copyWith({
    String? id,
    String? title,
    String? description,
    List<Question>? questions,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    bool? isActive,
  }) {
    return Survey(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      questions: questions ?? this.questions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      isActive: isActive ?? this.isActive,
    );
  }
}

class Question {
  final String id;
  final String text;
  final QuestionType type;
  final List<String> options;
  final bool isRequired;

  Question({
    required this.id,
    required this.text,
    required this.type,
    this.options = const [],
    this.isRequired = true,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      type: QuestionType.values.firstWhere(
        (e) => e.toString() == 'QuestionType.${map['type']}',
        orElse: () => QuestionType.text,
      ),
      options: List<String>.from(map['options'] ?? []),
      isRequired: map['isRequired'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'type': type.toString().split('.').last,
      'options': options,
      'isRequired': isRequired,
    };
  }
}

enum QuestionType { text, multipleChoice, singleChoice, rating, yesNo }

class SurveyResponse {
  final String? id;
  final String surveyId;
  final String respondentName;
  final String respondentEmail;
  final List<Answer> answers;
  final DateTime submittedAt;

  SurveyResponse({
    this.id,
    required this.surveyId,
    required this.respondentName,
    required this.respondentEmail,
    required this.answers,
    required this.submittedAt,
  });

  factory SurveyResponse.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return SurveyResponse(
      id: doc.id,
      surveyId: data['surveyId'] ?? '',
      respondentName: data['respondentName'] ?? '',
      respondentEmail: data['respondentEmail'] ?? '',
      answers:
          (data['answers'] as List<dynamic>?)
              ?.map((a) => Answer.fromMap(a))
              .toList() ??
          [],
      submittedAt:
          (data['submittedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'surveyId': surveyId,
      'respondentName': respondentName,
      'respondentEmail': respondentEmail,
      'answers': answers.map((a) => a.toMap()).toList(),
      'submittedAt': Timestamp.fromDate(submittedAt),
    };
  }
}

class Answer {
  final String questionId;
  final String text;
  final List<String> selectedOptions;
  final int rating;

  Answer({
    required this.questionId,
    this.text = '',
    this.selectedOptions = const [],
    this.rating = 0,
  });

  factory Answer.fromMap(Map<String, dynamic> map) {
    return Answer(
      questionId: map['questionId'] ?? '',
      text: map['text'] ?? '',
      selectedOptions: List<String>.from(map['selectedOptions'] ?? []),
      rating: map['rating'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'text': text,
      'selectedOptions': selectedOptions,
      'rating': rating,
    };
  }
}
