import 'package:flutter/material.dart';
import 'package:lingo_learn/core/app_theme.dart';
import 'package:lingo_learn/core/constants.dart';
import 'package:lingo_learn/data/content_repository.dart';
import 'package:lingo_learn/providers/progress_provider.dart';
import 'package:lingo_learn/widgets/category_progress_list.dart';
import 'package:lingo_learn/widgets/section_title.dart';
import 'package:lingo_learn/widgets/stat_card.dart';
import 'package:lingo_learn/widgets/weekly_chart.dart';
import 'package:provider/provider.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final profile = progress.profile;
    if (profile == null) return const SizedBox.shrink();

    final textTheme = Theme.of(context).textTheme;
    final lessons = ContentRepository.lessonsFor(profile.languageCode);
    final done =
        lessons.where((l) => profile.completedLessons.contains(l.id)).length;
    final level = profile.xp ~/ AppConstants.xpPerLevel + 1;
    final xpIntoLevel = profile.xp % AppConstants.xpPerLevel;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Text(
            'Your progress',
            style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.brandGradient,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Level $level',
                      style: textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${profile.xp} XP total',
                      style:
                          textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: xpIntoLevel / AppConstants.xpPerLevel,
                    minHeight: 10,
                    backgroundColor: Colors.white24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${AppConstants.xpPerLevel - xpIntoLevel} XP to level ${level + 1}',
                  style: textTheme.bodySmall?.copyWith(color: Colors.white70),
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
                  icon: Icons.today_rounded,
                  color: AppColors.primary,
                  value: '${progress.todayXp}',
                  label: 'XP today',
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
          const SectionTitle('Last 7 days'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: WeeklyChart(data: progress.weeklyXp),
            ),
          ),
          const SectionTitle('Course progress'),
          CategoryProgressList(
            languageCode: profile.languageCode,
            completedLessons: profile.completedLessons,
          ),
        ],
      ),
    );
  }
}