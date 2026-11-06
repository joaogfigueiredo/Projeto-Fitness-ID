
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/data/user_profile_service.dart';
import '../../data/services/coach_profile_service.dart';
import '../../domain/coach_profile.dart';
import 'coach_dashboard_page.dart';

class CoachProfileSetupPage extends StatefulWidget {
  const CoachProfileSetupPage({super.key});

  @override
  State<CoachProfileSetupPage> createState() =>
      _CoachProfileSetupPageState();
}

class _CoachProfileSetupPageState
    extends State<CoachProfileSetupPage> {
  final Set<CoachSpecialty> _selectedSpecialties = {};

  bool _isSaving = false;

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

  Future<void> _continueSetup() async {
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

    setState(() {
      _isSaving = true;
    });

    try {
      // Recupera o usuário autenticado.
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw StateError('Usuário não autenticado.');
      }

      // Verifica se o Coach já possui um perfil profissional.
      final coachProfileService = CoachProfileService();

      final alreadyExists =
          await coachProfileService.profileExists(user.uid);

      if (alreadyExists) {
        throw StateError(
          'Seu perfil profissional já foi criado.',
        );
      }

      // Recupera os dados do usuário cadastrado.
      final userProfile =
          await UserProfileService().getUserProfile(user.uid);

      if (userProfile == null) {
        throw StateError(
          'Não foi possível localizar seu cadastro.',
        );
      }

      // Cria o perfil profissional e reserva o CoachID.
      await coachProfileService.createProfile(
        uid: user.uid,
        name: userProfile.name,
        specialties: _selectedSpecialties.toList(),
        photoUrl: user.photoURL,
      );

      if (!mounted) return;

      // Encerra o carregamento.
      setState(() {
        _isSaving = false;
      });

      // Direciona o Coach ao painel principal.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const CoachDashboardPage(),
        ),
      );
    } on FirebaseException catch (error) {
      if (!mounted) return;

      String message =
          'Não foi possível salvar seu perfil. Tente novamente.';

      if (error.code == 'permission-denied') {
        message =
            'O Firebase recusou a operação. Verifique as permissões.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppTheme.surfaceLight,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error is StateError
                ? error.message
                : 'Ocorreu um erro ao configurar seu perfil.',
          ),
          backgroundColor: AppTheme.surfaceLight,
        ),
      );
    } finally {
      if (mounted && _isSaving) {
        setState(() {
          _isSaving = false;
        });
      }
    }
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
      onTap: _isSaving
          ? null
          : () => _toggleSpecialty(specialty),
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
              onChanged: _isSaving
                  ? null
                  : (_) => _toggleSpecialty(specialty),
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    onPressed: _isSaving ? null : _logout,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                  onPressed:
                      _isSaving ? null : _continueSetup,
                  child: _isSaving
                      ? const SizedBox(
                          height: 23,
                          width: 23,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
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
