import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:lingo_learn/core/app_theme.dart';
import 'package:lingo_learn/core/constants.dart';
import 'package:lingo_learn/providers/auth_provider.dart';
import 'package:lingo_learn/providers/progress_provider.dart';
import 'package:lingo_learn/screens/auth_gate.dart';
import 'package:lingo_learn/services/auth_service.dart';
import 'package:lingo_learn/services/progress_service.dart';
import 'package:lingo_learn/services/tts_service.dart';
import 'package:provider/provider.dart';

class LingoLearnApp extends StatelessWidget {
  const LingoLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<ProgressService>(create: (_) => ProgressService()),
        Provider<TtsService>(
          create: (_) => TtsService(),
          dispose: (_, service) => service.stop(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            context.read<AuthService>(),
            context.read<ProgressService>(),
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProgressProvider>(
          create: (context) =>
              ProgressProvider(context.read<ProgressService>()),
          update: (_, auth, progress) {
            final User? user = auth.user;
            return progress!..bind(user);
          },
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const AuthGate(),
      ),
    );
  }
}