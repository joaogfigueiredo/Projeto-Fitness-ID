
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/coach_profile.dart';

class CoachProfileService {
  final FirebaseFirestore _firestore;

  CoachProfileService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  // Busca o perfil profissional pelo UID do Coach.
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

  // Verifica se o Coach já possui um perfil profissional.
  Future<bool> profileExists(String uid) async {
    final document = await _firestore
        .collection('coach_profiles')
        .doc(uid)
        .get();

    return document.exists;
  }

  // Cria o perfil profissional e reserva um CoachID.
  Future<CoachProfile> createProfile({
    required String uid,
    required String name,
    required List<CoachSpecialty> specialties,
    String? photoUrl,
  }) async {
    if (name.trim().isEmpty) {
      throw ArgumentError(
        'O nome do Coach é obrigatório.',
      );
    }

    if (specialties.isEmpty) {
      throw ArgumentError(
        'Selecione pelo menos uma especialidade.',
      );
    }

    // Gera um identificador automático do Firestore.
    final generatedId = _firestore
        .collection('coach_id_reservations')
        .doc()
        .id;

    final coachId = 'FIT-${generatedId.toUpperCase()}';

    // Referência do perfil profissional.
    final profileRef = _firestore
        .collection('coach_profiles')
        .doc(uid);

    // Referência do diretório público.
    final directoryRef = _firestore
        .collection('coach_directory')
        .doc(coachId);

    // Referência da reserva privada.
    final reservationRef = _firestore
        .collection('coach_id_reservations')
        .doc(coachId);

    final profile = CoachProfile(
      uid: uid,
      coachId: coachId,
      specialties: specialties,
    );

    // Prepara as três gravações.
    final batch = _firestore.batch();

    // Perfil profissional.
    batch.set(profileRef, {
      ...profile.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Informações públicas do Coach.
    batch.set(directoryRef, {
      'coachId': coachId,
      'name': name.trim(),
      'specialties': specialties
          .map((specialty) => specialty.name)
          .toList(),
      'isActive': true,
      if (photoUrl != null && photoUrl.trim().isNotEmpty)
        'photoUrl': photoUrl.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Reserva privada do identificador.
    batch.set(reservationRef, {
      'ownerUid': uid,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Executa todas as gravações juntas.
    await batch.commit();

    return profile;
  }
}
