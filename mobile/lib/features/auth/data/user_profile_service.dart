
import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/user_profile.dart';

class UserProfileService {
  final FirebaseFirestore _firestore;

  UserProfileService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<UserProfile?> getUserProfile(String uid) async {
    final document = await _firestore
        .collection('users')
        .doc(uid)
        .get();

    if (!document.exists || document.data() == null) {
      return null;
    }

    final data = document.data()!;

    return UserProfile(
      uid: document.id,
      name: data['name'] as String,
      email: data['email'] as String,
      role: data['role'] as String,
    );
  }

  Future<void> createUserProfile(UserProfile profile) async {
    await _firestore
        .collection('users')
        .doc(profile.uid)
        .set({
      'name': profile.name,
      'email': profile.email,
      'role': profile.role,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
