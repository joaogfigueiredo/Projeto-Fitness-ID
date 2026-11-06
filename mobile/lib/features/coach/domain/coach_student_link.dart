
import 'package:cloud_firestore/cloud_firestore.dart';

import 'coach_profile.dart';

class CoachStudentLink {
  final String id;
  final String studentId;
  final String coachId;
  final List<CoachSpecialty> specialties;
  final DateTime createdAt;
  final bool isActive;

  const CoachStudentLink({
    required this.id,
    required this.studentId,
    required this.coachId,
    required this.specialties,
    required this.createdAt,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'coachId': coachId,
      'specialties': specialties
          .map((specialty) => specialty.name)
          .toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'isActive': isActive,
    };
  }

  factory CoachStudentLink.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return CoachStudentLink(
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
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isActive: map['isActive'] as bool? ?? true,
    );
  }
}
