
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/student_header.dart';
import '../widgets/student_quick_actions.dart';
import '../widgets/student_progress_cards.dart';
import '../widgets/student_daily_goals.dart';
import '../widgets/student_bottom_navigation.dart';

class StudentDashboardPage extends StatefulWidget {
  const StudentDashboardPage({super.key});

  @override
  State<StudentDashboardPage> createState() =>
      _StudentDashboardPageState();
}

class _StudentDashboardPageState extends State<StudentDashboardPage> {
  int _currentIndex = 0;

  final List<DailyGoal> _goals = [
    const DailyGoal(
      id: '1',
      title: 'Realizar treino do dia',
      subtitle: 'Treino personalizado',
    ),
    const DailyGoal(
      id: '2',
      title: 'Seguir o plano alimentar',
      subtitle: 'Alimentação programada',
    ),
    const DailyGoal(
      id: '3',
      title: 'Beber 2 litros de água',
      subtitle: 'Hidratação diária',
    ),
  ];

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  void _toggleGoal(String goalId) {
    setState(() {
      final index = _goals.indexWhere((goal) => goal.id == goalId);

      if (index == -1) return;

      final oldGoal = _goals[index];

      _goals[index] = DailyGoal(
        id: oldGoal.id,
        title: oldGoal.title,
        subtitle: oldGoal.subtitle,
        isCompleted: !oldGoal.isCompleted,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final studentName = user?.displayName ??
        user?.email?.split('@').first ??
        'Aluno';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StudentHeader(
                studentName: studentName,
                onLogoutTap: _logout,
              ),

              const SizedBox(height: 30),

              const Text(
                'Acesso rápido',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              const StudentQuickActions(),

              const SizedBox(height: 30),

              const Text(
                'Seu Progresso',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              const StudentProgressCards(),

              const SizedBox(height: 30),

              StudentDailyGoals(
                goals: _goals,
                onGoalChanged: _toggleGoal,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: StudentBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
