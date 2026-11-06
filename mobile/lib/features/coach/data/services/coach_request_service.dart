
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/coach_profile.dart';
import '../../domain/coach_request.dart';

class CoachRequestService {
  final FirebaseFirestore _firestore;

  CoachRequestService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  // Busca as solicitações pendentes recebidas pelo Coach.
  Future<List<CoachRequest>> getPendingRequests(
    String coachId,
  ) async {
    final snapshot = await _firestore
        .collection('coach_requests')
        .where('coachId', isEqualTo: coachId)
        .where('status', isEqualTo: 'pending')
        .get();

    return snapshot.docs.map((document) {
      return CoachRequest.fromMap(
        document.id,
        document.data(),
      );
    }).toList();
  }

  // Busca todas as solicitações enviadas pelo aluno.
  Future<List<CoachRequest>> getRequestsForStudent(
    String studentId,
  ) async {
    final snapshot = await _firestore
        .collection('coach_requests')
        .where('studentId', isEqualTo: studentId)
        .get();

    return snapshot.docs.map((document) {
      return CoachRequest.fromMap(
        document.id,
        document.data(),
      );
    }).toList();
  }

  // Cria uma nova solicitação de vínculo.
  Future<void> createRequest({
    required String studentId,
    required String coachId,
    required List<CoachSpecialty> specialties,
  }) async {
    if (studentId.trim().isEmpty) {
      throw ArgumentError('O ID do aluno é obrigatório.');
    }

    if (coachId.trim().isEmpty) {
      throw ArgumentError('O CoachID é obrigatório.');
    }

    if (specialties.isEmpty) {
      throw ArgumentError('Selecione pelo menos uma especialidade.');
    }

    final requestRef =
        _firestore.collection('coach_requests').doc();

    await requestRef.set({
      'studentId': studentId,
      'coachId': coachId,
      'specialties': specialties
          .map((specialty) => specialty.name)
          .toList(),
      'status': CoachRequestStatus.pending.name,
      'requestedAt': FieldValue.serverTimestamp(),
      'reviewedAt': null,
    });
  }
}
