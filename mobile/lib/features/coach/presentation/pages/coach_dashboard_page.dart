
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/coach_header.dart';
import '../widgets/coach_quick_actions.dart';
import '../widgets/coach_today_agenda.dart';
import '../widgets/coach_next_workout.dart';
import '../widgets/coach_bottom_navigation.dart';

class CoachDashboardPage extends StatefulWidget {
  const CoachDashboardPage({super.key});

  @override
  State<CoachDashboardPage> createState() =>
      _CoachDashboardPageState();
}

class _CoachDashboardPageState extends State<CoachDashboardPage> {
  int _currentIndex = 0;

  final List<CoachTask> _tasks = [
    const CoachTask(
      id: '1',
      title: 'Revisar treinos dos alunos',
    ),
    const CoachTask(
      id: '2',
      title: 'Responder mensagens pendentes',
    ),
    const CoachTask(
      id: '3',
      title: 'Atualizar fichas de treino',
    ),
  ];

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  void _toggleTask(String taskId) {
    setState(() {
      final index = _tasks.indexWhere(
        (task) => task.id == taskId,
      );

      if (index == -1) return;

      final oldTask = _tasks[index];

      _tasks[index] = CoachTask(
        id: oldTask.id,
        title: oldTask.title,
        isCompleted: !oldTask.isCompleted,
      );
    });
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature estará disponível em breve.'),
        backgroundColor: const Color(0xFF242424),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final coachName = user?.displayName ??
        user?.email?.split('@').first ??
        'Coach';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CoachHeader(
                coachName: coachName,
                onSettingsTap: () {
                 _showComingSoon('Configurações');
               },
               onLogoutTap: _logout,
            ),

              const SizedBox(height: 34),

              const Text(
                'Acessos principais',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              CoachQuickActions(
                onStudentsTap: () {
                  _showComingSoon('Alunos');
                },
                onReportsTap: () {
                  _showComingSoon('Relatórios');
                },
                onFinanceTap: () {
                  _showComingSoon('Financeiro');
                },
                onCommunicationTap: () {
                  _showComingSoon('Comunicação');
                },
              ),

              const SizedBox(height: 34),

              const Text(
                'Sua Agenda Hoje',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              CoachTodayAgenda(
                classesToday: 4,
                workoutOfDay: 'Treino de força',
                tasks: _tasks,
                onTaskChanged: _toggleTask,
              ),

              const SizedBox(height: 34),

              const Text(
                'Próximo Treino',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              CoachNextWorkout(
                workoutName: 'Treino de hipertrofia',
                studentName: 'Aluno demonstrativo',
                schedule: '14:30',
                durationMinutes: 60,
                onStartWorkout: () {
                  _showComingSoon('Execução de treino');
                },
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: CoachBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          if (index != 0) {
            final sections = [
              'Início',
              'Agenda',
              'Alunos',
              'Perfil',
            ];

            _showComingSoon(sections[index]);
          }
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _logout,
        backgroundColor: const Color(0xFFFF1010),
        foregroundColor: Colors.white,
        tooltip: 'Sair da conta',
        child: const Icon(Icons.logout),
      ),
    );
  }
}
