
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class CoachQuickActions extends StatelessWidget {
  final VoidCallback? onStudentsTap;
  final VoidCallback? onReportsTap;
  final VoidCallback? onFinanceTap;
  final VoidCallback? onCommunicationTap;

  const CoachQuickActions({
    super.key,
    this.onStudentsTap,
    this.onReportsTap,
    this.onFinanceTap,
    this.onCommunicationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                title: 'Alunos',
                icon: Icons.groups,
                isHighlighted: true,
                onTap: onStudentsTap,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _QuickActionCard(
                title: 'Relatórios',
                icon: Icons.bar_chart,
                onTap: onReportsTap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                title: 'Financeiro',
                icon: Icons.payments_outlined,
                onTap: onFinanceTap,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _QuickActionCard(
                title: 'Comunicação',
                icon: Icons.chat_bubble_outline,
                onTap: onCommunicationTap,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isHighlighted;
  final VoidCallback? onTap;

  const _QuickActionCard({
    required this.title,
    required this.icon,
    this.isHighlighted = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isHighlighted
          ? const Color(0xFF260000)
          : AppTheme.surface,
      borderRadius: BorderRadius.circular(48),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(48),
        child: Container(
          height: 104,
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 18,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(48),
            border: Border.all(
              color: isHighlighted
                  ? AppTheme.primaryDark
                  : AppTheme.border,
            ),
            boxShadow: isHighlighted
                ? [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.12),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: AppTheme.primary,
                size: 27,
              ),
              const SizedBox(height: 9),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
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
