import 'package:flutter/material.dart';
import 'package:lingo_learn/core/app_theme.dart';
import 'package:lingo_learn/core/constants.dart';
import 'package:lingo_learn/widgets/brand_logo.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryDark, AppColors.primary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const BrandLogo(size: 88, onDark: true),
              const SizedBox(height: 24),
              Text(
                AppConstants.appName,
                style: textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message ?? 'Learn languages, one day at a time',
                style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 36),
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
