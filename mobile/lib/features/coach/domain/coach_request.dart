
import 'package:cloud_firestore/cloud_firestore.dart';

import 'coach_profile.dart';

enum CoachRequestStatus {
  pending,
  accepted,
  rejected,
  cancelled,
}

class CoachRequest {
  final String id;
  final String studentId;
  final String coachId;
  final List<CoachSpecialty> specialties;
  final CoachRequestStatus status;
  final DateTime requestedAt;
  final DateTime? reviewedAt;

  const CoachRequest({
    required this.id,
    required this.studentId,
    required this.coachId,
    required this.specialties,
    required this.status,
    required this.requestedAt,
    this.reviewedAt,
  });

  factory CoachRequest.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return CoachRequest(
      id: id,
      studentId: map['studentId'] as String,
      coachId: map['coachId'] as String,
      specialties: (map['specialties'] as List<dynamic>)
          .map(
            (name) => CoachSpecialty.values.firstWhere(
              (specialty) => specialty.name == name,
            ),
          )
          .toList(),
      status: CoachRequestStatus.values.firstWhere(
        (status) => status.name == map['status'],
      ),
      requestedAt: (map['requestedAt'] as Timestamp).toDate(),
      reviewedAt: map['reviewedAt'] == null
          ? null
          : (map['reviewedAt'] as Timestamp).toDate(),
    );
  }
}
