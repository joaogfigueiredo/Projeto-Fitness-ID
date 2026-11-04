enum CoachSpecialty {
  training,
  nutrition,
}

class CoachProfile {
  final String uid;
  final String coachId;
  final List<CoachSpecialty> specialties;
  final bool isActive;

  const CoachProfile({
    required this.uid,
    required this.coachId,
    required this.specialties,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'coachId': coachId,
      'specialties': specialties
          .map((specialty) => specialty.name)
          .toList(),
      'isActive': isActive,
    };
  }

  factory CoachProfile.fromMap(
    String uid,
    Map<String, dynamic> map,
  ) {
    final specialtyNames =
        List<String>.from(map['specialties'] ?? []);

    return CoachProfile(
      uid: uid,
      coachId: map['coachId'] as String,
      specialties: specialtyNames
          .map(
            (name) => CoachSpecialty.values.firstWhere(
              (specialty) => specialty.name == name,
            ),
          )
          .toList(),
      isActive: map['isActive'] as bool? ?? true,
    );
  }
}