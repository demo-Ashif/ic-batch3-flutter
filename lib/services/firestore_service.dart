import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/survey.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  static const String _surveysCollection = 'surveys';
  static const String _responsesCollection = 'responses';

  // ========== SURVEY CRUD OPERATIONS ==========

  /// Create a new survey
  static Future<String> createSurvey(Survey survey) async {
    try {
      final docRef = await _firestore
          .collection(_surveysCollection)
          .add(survey.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create survey: $e');
    }
  }

  /// Get a single survey by ID
  static Future<Survey?> getSurvey(String surveyId) async {
    try {
      final doc =
          await _firestore.collection(_surveysCollection).doc(surveyId).get();

      if (doc.exists) {
        return Survey.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get survey: $e');
    }
  }

  /// Get all surveys with real-time updates
  static Stream<List<Survey>> getSurveysStream() {
    return _firestore
        .collection(_surveysCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Survey.fromFirestore(doc)).toList();
        });
  }

  /// Get active surveys only
  static Stream<List<Survey>> getActiveSurveysStream() {
    return _firestore
        .collection(_surveysCollection)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Survey.fromFirestore(doc)).toList();
        });
  }

  /// Update a survey
  static Future<void> updateSurvey(String surveyId, Survey survey) async {
    try {
      await _firestore
          .collection(_surveysCollection)
          .doc(surveyId)
          .update(survey.toFirestore());
    } catch (e) {
      throw Exception('Failed to update survey: $e');
    }
  }

  /// Delete a survey
  static Future<void> deleteSurvey(String surveyId) async {
    try {
      await _firestore.collection(_surveysCollection).doc(surveyId).delete();
    } catch (e) {
      throw Exception('Failed to delete survey: $e');
    }
  }

  /// Toggle survey active status
  static Future<void> toggleSurveyStatus(String surveyId, bool isActive) async {
    try {
      await _firestore.collection(_surveysCollection).doc(surveyId).update({
        'isActive': isActive,
      });
    } catch (e) {
      throw Exception('Failed to toggle survey status: $e');
    }
  }

  // ========== SURVEY RESPONSE CRUD OPERATIONS ==========

  /// Submit a survey response
  static Future<String> submitSurveyResponse(SurveyResponse response) async {
    try {
      final docRef = await _firestore
          .collection(_responsesCollection)
          .add(response.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to submit survey response: $e');
    }
  }

  /// Get responses for a specific survey
  static Stream<List<SurveyResponse>> getSurveyResponsesStream(
    String surveyId,
  ) {
    return _firestore
        .collection(_responsesCollection)
        .where('surveyId', isEqualTo: surveyId)
        .orderBy('submittedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => SurveyResponse.fromFirestore(doc))
              .toList();
        });
  }

  /// Get all responses with real-time updates
  static Stream<List<SurveyResponse>> getAllResponsesStream() {
    return _firestore
        .collection(_responsesCollection)
        .orderBy('submittedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => SurveyResponse.fromFirestore(doc))
              .toList();
        });
  }

  /// Delete a survey response
  static Future<void> deleteSurveyResponse(String responseId) async {
    try {
      await _firestore
          .collection(_responsesCollection)
          .doc(responseId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete survey response: $e');
    }
  }

  // ========== QUERY OPERATIONS ==========

  /// Search surveys by title
  static Stream<List<Survey>> searchSurveysByTitle(String searchTerm) {
    return _firestore
        .collection(_surveysCollection)
        .where('title', isGreaterThanOrEqualTo: searchTerm)
        .where('title', isLessThan: searchTerm + 'z')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Survey.fromFirestore(doc)).toList();
        });
  }

  /// Get surveys created by a specific user
  static Stream<List<Survey>> getSurveysByUser(String userId) {
    return _firestore
        .collection(_surveysCollection)
        .where('createdBy', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Survey.fromFirestore(doc)).toList();
        });
  }

  /// Get survey statistics
  static Future<Map<String, int>> getSurveyStats(String surveyId) async {
    try {
      final responsesSnapshot =
          await _firestore
              .collection(_responsesCollection)
              .where('surveyId', isEqualTo: surveyId)
              .get();

      final surveyDoc =
          await _firestore.collection(_surveysCollection).doc(surveyId).get();

      return {
        'totalResponses': responsesSnapshot.docs.length,
        'totalQuestions':
            surveyDoc.exists
                ? (surveyDoc.data()?['questions'] as List?)?.length ?? 0
                : 0,
      };
    } catch (e) {
      throw Exception('Failed to get survey stats: $e');
    }
  }

  // ========== BATCH OPERATIONS ==========

  /// Delete survey and all its responses
  static Future<void> deleteSurveyWithResponses(String surveyId) async {
    try {
      final batch = _firestore.batch();

      // Delete all responses for this survey
      final responsesSnapshot =
          await _firestore
              .collection(_responsesCollection)
              .where('surveyId', isEqualTo: surveyId)
              .get();

      for (final doc in responsesSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Delete the survey
      batch.delete(_firestore.collection(_surveysCollection).doc(surveyId));

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete survey with responses: $e');
    }
  }

  // ========== ERROR HANDLING HELPERS ==========

  /// Handle Firestore errors
  static String handleFirestoreError(dynamic error) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return 'You do not have permission to perform this action';
        case 'not-found':
          return 'The requested document was not found';
        case 'already-exists':
          return 'A document with this ID already exists';
        case 'resource-exhausted':
          return 'Too many requests. Please try again later';
        case 'unavailable':
          return 'Service is currently unavailable. Please try again later';
        case 'unauthenticated':
          return 'You must be authenticated to perform this action';
        default:
          return 'An error occurred: ${error.message}';
      }
    }
    return 'An unexpected error occurred: $error';
  }
}
