
import 'coach_profile.dart';

class CoachSearchResult {
  final String coachId;
  final String name;
  final String? photoUrl;
  final List<CoachSpecialty> specialties;
  final bool isActive;

  const CoachSearchResult({
    required this.coachId,
    required this.name,
    this.photoUrl,
    required this.specialties,
    required this.isActive,
  });

  factory CoachSearchResult.fromMap(
    String coachId,
    Map<String, dynamic> map,
  ) {
    final specialtyNames =
        List<String>.from(map['specialties'] ?? []);

    return CoachSearchResult(
      coachId: coachId,
      name: map['name'] as String,
      photoUrl: map['photoUrl'] as String?,
      specialties: specialtyNames
          .map(
            (name) => CoachSpecialty.values.firstWhere(
              (specialty) => specialty.name == name,
            ),
          )
          .toList(),
      isActive: map['isActive'] as bool? ?? false,
    );
  }
}
