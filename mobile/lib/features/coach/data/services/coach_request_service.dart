import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/coach_request.dart';

class CoachRequestService {
  final FirebaseFirestore _firestore;

  CoachRequestService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<CoachRequest>> getPendingRequests(
    String coachUid,
  ) async {
    final snapshot = await _firestore
        .collection('coach_requests')
        .where('coachUid', isEqualTo: coachUid)
        .where('status', isEqualTo: 'pending')
        .get();

    return snapshot.docs.map((document) {
      return CoachRequest.fromMap(
        document.id,
        document.data(),
      );
    }).toList();
  }
}