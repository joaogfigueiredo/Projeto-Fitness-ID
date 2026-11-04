
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/coach_search_result.dart';

class CoachSearchService {
  final FirebaseFirestore _firestore;

  CoachSearchService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<CoachSearchResult?> searchByCoachId(
    String coachId,
  ) async {
    final normalizedCoachId = coachId.trim().toUpperCase();

    if (normalizedCoachId.isEmpty) {
      return null;
    }

    final document = await _firestore
        .collection('coach_directory')
        .doc(normalizedCoachId)
        .get();

    if (!document.exists || document.data() == null) {
      return null;
    }

    final result = CoachSearchResult.fromMap(
      document.id,
      document.data()!,
    );

    if (!result.isActive) {
      return null;
    }

    return result;
  }
}
