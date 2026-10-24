import 'package:flutter/material.dart';
import 'package:lingo_learn/core/app_theme.dart';
import 'package:lingo_learn/data/content_repository.dart';
import 'package:lingo_learn/models/lesson.dart';
import 'package:lingo_learn/providers/progress_provider.dart';
import 'package:lingo_learn/screens/lesson_detail_screen.dart';
import 'package:lingo_learn/widgets/language_chip.dart';
import 'package:lingo_learn/widgets/lesson_tile.dart';
import 'package:provider/provider.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProgressProvider>().profile;
    if (profile == null) return const SizedBox.shrink();

    return DefaultTabController(
      length: LessonCategory.values.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Learn'),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(child: LanguageChip()),
            ),
          ],
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            tabs: [
              for (final category in LessonCategory.values)
                Tab(text: category.label),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            for (final category in LessonCategory.values)
              _CategoryList(
                category: category,
                languageCode: profile.languageCode,
                completed: profile.completedLessons,
              ),
          ],
        ),
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({
    required this.category,
    required this.languageCode,
    required this.completed,
  });

  final LessonCategory category;
  final String languageCode;
  final List<String> completed;

  @override
  Widget build(BuildContext context) {
    final lessons =
        ContentRepository.lessonsByCategory(languageCode, category);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          category.description,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
        for (final lesson in lessons) ...[
          LessonTile(
            lesson: lesson,
            completed: completed.contains(lesson.id),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => LessonDetailScreen(lesson: lesson),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}