
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/user_profile_service.dart';
import '../../../student/presentation/pages/student_dashboard_page.dart';
import '../../../coach/presentation/pages/coach_dashboard_page.dart';
import 'login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const LoginPage();
        }

        final user = snapshot.data!;

        return FutureBuilder(
          future: UserProfileService().getUserProfile(user.uid),
          builder: (context, profileSnapshot) {
            if (profileSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (profileSnapshot.hasError) {
              return const Scaffold(
                body: Center(
                  child: Text('Erro ao carregar perfil do usuário.'),
                ),
              );
            }

            final profile = profileSnapshot.data;

            if (profile == null) {
              return const Scaffold(
                body: Center(
                  child: Text(
                    'Perfil não encontrado. Entre em contato com o suporte.',
                  ),
                ),
              );
            }

            if (profile.isStudent) {
              return const StudentDashboardPage();
            }

            if (profile.isCoach) {
              return const CoachDashboardPage();
            }

            return const Scaffold(
              body: Center(
                child: Text('Tipo de usuário não reconhecido.'),
              ),
            );
          },
        );
      },
    );
  }
}
