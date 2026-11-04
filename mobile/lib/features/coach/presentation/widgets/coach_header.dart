import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class CoachHeader extends StatelessWidget {
  final String coachName;
  final String? photoUrl;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onLogoutTap;

  const CoachHeader({
    super.key,
    required this.coachName,
    this.photoUrl,
    this.onSettingsTap,
    this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'FITNESS ID',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),

            Row(
              children: [
                IconButton(
                  onPressed: onLogoutTap,
                  icon: const Icon(
                    Icons.logout,
                    color: AppTheme.textPrimary,
                  ),
                  tooltip: 'Sair da conta',
                ),

                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.border,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: onSettingsTap,
                    icon: const Icon(
                      Icons.settings_outlined,
                      color: AppTheme.textPrimary,
                    ),
                    tooltip: 'Configurações',
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 34),

        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primary,
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 42,
                backgroundColor: AppTheme.surfaceLight,
                backgroundImage:
                    photoUrl != null && photoUrl!.isNotEmpty
                        ? NetworkImage(photoUrl!)
                        : null,
                child: photoUrl == null || photoUrl!.isEmpty
                    ? const Icon(
                        Icons.person,
                        color: AppTheme.textSecondary,
                        size: 38,
                      )
                    : null,
              ),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Olá, $coachName!',
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'Gerencie seus alunos e treinos com excelência',
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontSize: 15,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}