
class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String role;

  const UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
  });

  bool get isStudent => role == 'student';

  bool get isCoach => role == 'coach';
}
