import 'package:flutter/material.dart';
import 'package:lingo_learn/core/app_theme.dart';
import 'package:lingo_learn/core/constants.dart';
import 'package:lingo_learn/data/content_repository.dart';
import 'package:lingo_learn/providers/progress_provider.dart';
import 'package:lingo_learn/screens/lesson_detail_screen.dart';
import 'package:lingo_learn/widgets/category_progress_list.dart';
import 'package:lingo_learn/widgets/language_chip.dart';
import 'package:lingo_learn/widgets/section_title.dart';
import 'package:lingo_learn/widgets/stat_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onOpenLearn});

  final VoidCallback onOpenLearn;

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final profile = progress.profile;
    if (profile == null) return const SizedBox.shrink();

    final textTheme = Theme.of(context).textTheme;
    final language = ContentRepository.languageByCode(profile.languageCode);
    final lessons = ContentRepository.lessonsFor(language.code);
    final done =
        lessons.where((l) => profile.completedLessons.contains(l.id)).length;
    final daily = ContentRepository.dailyLesson(language.code, DateTime.now());
    final goalRatio =
        (progress.todayXp / AppConstants.dailyGoalXp).clamp(0.0, 1.0).toDouble();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_greeting()},',
                      style: textTheme.bodyMedium
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                    Text(
                      '${profile.firstName} 👋',
                      style: textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const LanguageChip(),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.brandGradient,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 76,
                  height: 76,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: CircularProgressIndicator(
                          value: goalRatio,
                          strokeWidth: 8,
                          strokeCap: StrokeCap.round,
                          backgroundColor: Colors.white24,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${(goalRatio * 100).round()}%',
                        style: textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily goal',
                        style: textTheme.bodySmall
                            ?.copyWith(color: Colors.white70),
                      ),
                      Text(
                        '${progress.todayXp} / ${AppConstants.dailyGoalXp} XP',
                        style: textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        goalRatio >= 1
                            ? 'Goal reached. Amazing work!'
                            : 'Finish a quiz or flashcards to earn XP.',
                        style: textTheme.bodySmall
                            ?.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.local_fire_department_rounded,
                  color: const Color(0xFFF97316),
                  value: '${profile.activeStreak}',
                  label: 'Day streak',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  icon: Icons.bolt_rounded,
                  color: AppColors.accent,
                  value: '${profile.xp}',
                  label: 'Total XP',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  icon: Icons.check_circle_rounded,
                  color: AppColors.success,
                  value: '$done/${lessons.length}',
                  label: 'Lessons',
                ),
              ),
            ],
          ),
          const SectionTitle('Lesson of the day'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: daily.category.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(daily.category.icon,
                            color: daily.category.color),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              daily.title,
                              style: textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '${daily.category.label} · ${daily.items.length} ${daily.category.itemLabel}',
                              style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  LessonDetailScreen(lesson: daily),
                            ),
                          ),
                          child: const Text('Start lesson'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              const Expanded(child: SectionTitle('Your courses')),
              TextButton(onPressed: onOpenLearn, child: const Text('See all')),
            ],
          ),
          CategoryProgressList(
            languageCode: language.code,
            completedLessons: profile.completedLessons,
          ),
        ],
      ),
    );
  }
}