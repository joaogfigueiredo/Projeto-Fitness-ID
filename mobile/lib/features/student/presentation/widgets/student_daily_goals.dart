
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class StudentDailyGoals extends StatelessWidget {
  final List<DailyGoal> goals;
  final ValueChanged<String>? onGoalChanged;

  const StudentDailyGoals({
    super.key,
    required this.goals,
    this.onGoalChanged,
  });

  @override
  Widget build(BuildContext context) {
    final completedGoals = goals.where((goal) => goal.isCompleted).length;

    final progress = goals.isEmpty
        ? 0.0
        : completedGoals / goals.length;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Metas de Hoje',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$completedGoals/${goals.length}',
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: AppTheme.surfaceLight,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppTheme.primary,
              ),
            ),
          ),

          const SizedBox(height: 18),

          ...goals.map(
            (goal) => _GoalItem(
              goal: goal,
              onChanged: onGoalChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class DailyGoal {
  final String id;
  final String title;
  final String subtitle;
  final bool isCompleted;

  const DailyGoal({
    required this.id,
    required this.title,
    required this.subtitle,
    this.isCompleted = false,
  });
}

class _GoalItem extends StatelessWidget {
  final DailyGoal goal;
  final ValueChanged<String>? onChanged;

  const _GoalItem({
    required this.goal,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.title,
                  style: TextStyle(
                    color: goal.isCompleted
                        ? AppTheme.textMuted
                        : AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    decoration: goal.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  goal.subtitle,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Checkbox(
            value: goal.isCompleted,
            activeColor: AppTheme.primary,
            onChanged: onChanged == null
                ? null
                : (_) => onChanged!(goal.id),
          ),
        ],
      ),
    );
  }
}
