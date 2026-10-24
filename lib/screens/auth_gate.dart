import 'package:flutter/material.dart';
import 'package:lingo_learn/providers/auth_provider.dart';
import 'package:lingo_learn/providers/progress_provider.dart';
import 'package:lingo_learn/screens/home_shell.dart';
import 'package:lingo_learn/screens/language_select_screen.dart';
import 'package:lingo_learn/screens/login_screen.dart';
import 'package:lingo_learn/screens/splash_screen.dart';
import 'package:provider/provider.dart';

/// Decides which screen to show based on auth + profile state.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final progress = context.watch<ProgressProvider>();

    if (!auth.initialized) return const SplashScreen();
    if (auth.user == null) return const LoginScreen();

    final profile = progress.profile;
    if (profile == null) {
      return const SplashScreen(message: 'Setting up your account…');
    }
    if (!profile.hasLanguage) return const LanguageSelectScreen();
    return const HomeShell();
  }
}