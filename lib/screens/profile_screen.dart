import 'package:flutter/material.dart';
import 'package:lingo_learn/core/app_theme.dart';
import 'package:lingo_learn/core/constants.dart';
import 'package:lingo_learn/data/content_repository.dart';
import 'package:lingo_learn/providers/auth_provider.dart';
import 'package:lingo_learn/providers/progress_provider.dart';
import 'package:lingo_learn/screens/language_select_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _confirmSignOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text('Your progress is saved and will be here when you return.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<AuthProvider>().signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProgressProvider>().profile;
    if (profile == null) return const SizedBox.shrink();

    final textTheme = Theme.of(context).textTheme;
    final language = ContentRepository.languageByCode(profile.languageCode);
    final level = profile.xp ~/ AppConstants.xpPerLevel + 1;
    final initial = profile.name.isEmpty ? '?' : profile.name[0].toUpperCase();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Text(
            'Profile',
            style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      gradient: AppColors.brandGradient,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      initial,
                      style: textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name,
                          style: textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          profile.email,
                          style: textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Level $level · ${profile.xp} XP',
                            style: textTheme.labelSmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  leading: Text(language.flag, style: const TextStyle(fontSize: 26)),
                  title: const Text('Learning language'),
                  subtitle: Text(language.name),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          const LanguageSelectScreen(isOnboarding: false),
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.flag_rounded,
                      color: AppColors.primary),
                  title: const Text('Daily goal'),
                  subtitle: Text('${AppConstants.dailyGoalXp} XP per day'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded,
                      color: AppColors.primary),
                  title: const Text('About'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => showAboutDialog(
                    context: context,
                    applicationName: AppConstants.appName,
                    applicationVersion: '1.0.0',
                    applicationLegalese:
                        'Built with Flutter & Firebase for CodeAlpha.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => _confirmSignOut(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error, width: 1.4),
            ),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}