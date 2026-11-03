
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class StudentHeader extends StatelessWidget {
  final String studentName;
  final String? photoUrl;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onLogoutTap;

  const StudentHeader({
    super.key,
    required this.studentName,
    this.photoUrl,
    this.onNotificationsTap,
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
                fontSize: 17,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                color: AppTheme.textPrimary,
              ),
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: IconButton(
                    onPressed: onNotificationsTap,
                    icon: const Icon(Icons.notifications_none),
                    tooltip: 'Notificações',
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: IconButton(
                    onPressed: onLogoutTap,
                    icon: const Icon(Icons.logout),
                    tooltip: 'Sair da conta',
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Olá, $studentName!',
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Bora treinar hoje?',
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 34,
              backgroundColor: AppTheme.surfaceLight,
              backgroundImage: photoUrl != null &&
                      photoUrl!.isNotEmpty
                  ? NetworkImage(photoUrl!)
                  : null,
              child: photoUrl == null || photoUrl!.isEmpty
                  ? const Icon(
                      Icons.person,
                      color: AppTheme.textSecondary,
                      size: 32,
                    )
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}
