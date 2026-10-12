
import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/login_page.dart';

void main() {
  runApp(const FitnessIdApp());
}

class FitnessIdApp extends StatelessWidget {
  const FitnessIdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness ID',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const LoginPage(),
    );
  }
}
