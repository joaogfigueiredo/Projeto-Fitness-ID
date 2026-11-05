
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/coach_profile.dart';

class CoachProfileSetupPage extends StatefulWidget {
  const CoachProfileSetupPage({super.key});

  @override
  State<CoachProfileSetupPage> createState() =>
      _CoachProfileSetupPageState();
}

class _CoachProfileSetupPageState
    extends State<CoachProfileSetupPage> {
  final Set<CoachSpecialty> _selectedSpecialties = {};

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  void _toggleSpecialty(CoachSpecialty specialty) {
    setState(() {
      if (_selectedSpecialties.contains(specialty)) {
        _selectedSpecialties.remove(specialty);
      } else {
        _selectedSpecialties.add(specialty);
      }
    });
  }

  void _continueSetup() {
    if (_selectedSpecialties.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Selecione pelo menos uma especialidade.',
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Especialidades selecionadas! '
          'A próxima etapa será salvar seu perfil.',
        ),
      ),
    );
  }

  Widget _buildSpecialtyCard({
    required CoachSpecialty specialty,
    required String title,
    required String description,
    required IconData icon,
  }) {
    final isSelected =
        _selectedSpecialties.contains(specialty);

    return GestureDetector(
      onTap: () => _toggleSpecialty(specialty),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? AppTheme.primary
                : AppTheme.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppTheme.primary
                  : AppTheme.textSecondary,
              size: 30,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Checkbox(
              value: isSelected,
              activeColor: AppTheme.primary,
              onChanged: (_) =>
                  _toggleSpecialty(specialty),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'FITNESS ID',
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                  IconButton(
                    onPressed: _logout,
                    tooltip: 'Sair da conta',
                    icon: const Icon(
                      Icons.logout,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              const Text(
                'Configure seu perfil profissional',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Para começar, informe quais serviços '
                'você oferece aos seus alunos.',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 35),

              const Text(
                'SUAS ESPECIALIDADES',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 16),

              _buildSpecialtyCard(
                specialty: CoachSpecialty.training,
                title: 'Treinamento',
                description:
                    'Prescrição e acompanhamento de treinos.',
                icon: Icons.fitness_center,
              ),

              const SizedBox(height: 14),

              _buildSpecialtyCard(
                specialty: CoachSpecialty.nutrition,
                title: 'Nutrição',
                description:
                    'Planejamento e acompanhamento nutricional.',
                icon: Icons.restaurant,
              ),

              const SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppTheme.primary,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Você poderá oferecer uma ou ambas '
                        'as especialidades. Os alunos poderão '
                        'solicitar apenas os serviços que desejarem.',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _continueSetup,
                  child: const Text(
                    'Continuar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
