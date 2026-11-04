
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class CoachNextWorkout extends StatelessWidget {
  final String workoutName;
  final String studentName;
  final String schedule;
  final int durationMinutes;
  final VoidCallback? onStartWorkout;

  const CoachNextWorkout({
    super.key,
    required this.workoutName,
    required this.studentName,
    required this.schedule,
    required this.durationMinutes,
    this.onStartWorkout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppTheme.border),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            const Color(0xFF281919),
            AppTheme.surface,
            AppTheme.surface,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            workoutName,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 20),

          _WorkoutInfoRow(
            icon: Icons.person_outline,
            label: 'Aluno:',
            value: studentName,
          ),

          const SizedBox(height: 12),

          _WorkoutInfoRow(
            icon: Icons.access_time,
            label: 'Horário:',
            value: schedule,
          ),

          const SizedBox(height: 12),

          _WorkoutInfoRow(
            icon: Icons.timer_outlined,
            label: 'Duração:',
            value: '$durationMinutes min',
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton.icon(
              onPressed: onStartWorkout,
              icon: const Icon(
                Icons.play_arrow,
                size: 25,
              ),
              label: const Text(
                'INICIAR TREINO',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                elevation: 8,
                shadowColor: AppTheme.primary.withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _WorkoutInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppTheme.textSecondary,
          size: 19,
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
