
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class StudentProgressCards extends StatelessWidget {
  final int workoutsCompleted;
  final int dailyCalories;
  final int streakDays;

  const StudentProgressCards({
    super.key,
    this.workoutsCompleted = 12,
    this.dailyCalories = 1850,
    this.streakDays = 7,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ProgressCard(
            icon: Icons.fitness_center,
            value: '$workoutsCompleted',
            label: 'TREINOS',
            description: 'Realizados',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ProgressCard(
            icon: Icons.local_fire_department,
            value: '$dailyCalories',
            label: 'CALORIAS',
            description: 'Hoje',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ProgressCard(
            icon: Icons.bolt,
            value: '$streakDays dias',
            label: 'SEQUÊNCIA',
            description: 'Consistência',
          ),
        ),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final String description;

  const _ProgressCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppTheme.primary,
            size: 22,
          ),
          const SizedBox(height: 14),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            description,
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
