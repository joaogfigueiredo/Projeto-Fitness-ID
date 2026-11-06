
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/services/coach_profile_service.dart';
import '../../domain/coach_profile.dart';
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

  late Future<CoachProfile?> _coachProfileFuture;

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

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      _coachProfileFuture =
          CoachProfileService().getProfile(user.uid);
    } else {
      _coachProfileFuture = Future.value(null);
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> _copyCoachId(String coachId) async {
    await Clipboard.setData(
      ClipboardData(text: coachId),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('CoachID copiado com sucesso!'),
        backgroundColor: Color(0xFF242424),
      ),
    );
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

  Widget _buildCoachIdCard() {
    return FutureBuilder<CoachProfile?>(
      future: _coachProfileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF191919),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF191919),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Text(
              'Não foi possível carregar seu CoachID.',
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
          );
        }

        final coachId = snapshot.data!.coachId;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF191919),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFF303030),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.fingerprint,
                    color: Color(0xFFFF1010),
                    size: 22,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'SEU COACH ID',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      coachId,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _copyCoachId(coachId),
                    tooltip: 'Copiar CoachID',
                    icon: const Icon(
                      Icons.copy,
                      color: Color(0xFFFF1010),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              const Text(
                'Compartilhe este código com seus alunos '
                'para que eles possam solicitar uma vinculação '
                'ao seu perfil profissional.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      },
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

              const SizedBox(height: 25),

              _buildCoachIdCard(),

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
