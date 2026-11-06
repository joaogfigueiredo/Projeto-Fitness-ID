
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/coach_student_link.dart';

class CoachStudentLinkService {
  final FirebaseFirestore _firestore;

  CoachStudentLinkService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<CoachStudentLink>> getActiveLinksForCoach(
    String coachId,
  ) async {
    final snapshot = await _firestore
        .collection('coach_student_links')
        .where('coachId', isEqualTo: coachId)
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs.map((document) {
      return CoachStudentLink.fromMap(
        document.id,
        document.data(),
      );
    }).toList();
  }

  Future<List<CoachStudentLink>> getActiveLinksForStudent(
    String studentId,
  ) async {
    final snapshot = await _firestore
        .collection('coach_student_links')
        .where('studentId', isEqualTo: studentId)
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs.map((document) {
      return CoachStudentLink.fromMap(
        document.id,
        document.data(),
      );
    }).toList();
  }
}
