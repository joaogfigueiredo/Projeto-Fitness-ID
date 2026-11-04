
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class CoachTodayAgenda extends StatelessWidget {
  final int classesToday;
  final String workoutOfDay;
  final List<CoachTask> tasks;
  final ValueChanged<String>? onTaskChanged;

  const CoachTodayAgenda({
    super.key,
    required this.classesToday,
    required this.workoutOfDay,
    required this.tasks,
    this.onTaskChanged,
  });

  @override
  Widget build(BuildContext context) {
    final completedTasks =
        tasks.where((task) => task.isCompleted).length;

    final progress = tasks.isEmpty
        ? 0.0
        : completedTasks / tasks.length;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppTheme.border),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AgendaSummary(
            classesToday: classesToday,
            workoutOfDay: workoutOfDay,
          ),

          const SizedBox(height: 30),

          const Text(
            'TAREFAS DO DIA',
            style: TextStyle(
              color: AppTheme.primary,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 18),

          ...tasks.map(
            (task) => _AgendaTaskItem(
              task: task,
              onChanged: onTaskChanged,
            ),
          ),

          const SizedBox(height: 12),

          Divider(color: AppTheme.border),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: Text(
                  'Progresso de hoje: $completedTasks/${tasks.length} concluídos',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 55,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 7,
                    backgroundColor: AppTheme.surfaceLight,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(
                      AppTheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CoachTask {
  final String id;
  final String title;
  final bool isCompleted;

  const CoachTask({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });
}

class _AgendaSummary extends StatelessWidget {
  final int classesToday;
  final String workoutOfDay;

  const _AgendaSummary({
    required this.classesToday,
    required this.workoutOfDay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.background.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AULAS DE HOJE',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$classesToday',
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'TREINO DO DIA',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  workoutOfDay,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AgendaTaskItem extends StatelessWidget {
  final CoachTask task;
  final ValueChanged<String>? onChanged;

  const _AgendaTaskItem({
    required this.task,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: task.isCompleted,
              activeColor: AppTheme.primary,
              shape: const CircleBorder(),
              onChanged: onChanged == null
                  ? null
                  : (_) => onChanged!(task.id),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              task.title,
              style: TextStyle(
                color: task.isCompleted
                    ? AppTheme.textMuted
                    : AppTheme.textPrimary,
                fontSize: 14,
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
