import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/coach_profile.dart';

class CoachProfileService {
  final FirebaseFirestore _firestore;

  CoachProfileService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<CoachProfile?> getProfile(String uid) async {
    final document = await _firestore
        .collection('coach_profiles')
        .doc(uid)
        .get();

    if (!document.exists || document.data() == null) {
      return null;
    }

    return CoachProfile.fromMap(
      document.id,
      document.data()!,
    );
  }
}