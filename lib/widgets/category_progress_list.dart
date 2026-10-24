import 'package:flutter/material.dart';
import 'package:lingo_learn/core/app_theme.dart';
import 'package:lingo_learn/data/content_repository.dart';
import 'package:lingo_learn/models/lesson.dart';

class CategoryProgressList extends StatelessWidget {
  const CategoryProgressList({
    super.key,
    required this.languageCode,
    required this.completedLessons,
  });

  final String languageCode;
  final List<String> completedLessons;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (final category in LessonCategory.values) ...[
              _row(textTheme, category),
              if (category != LessonCategory.values.last)
                const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(TextTheme textTheme, LessonCategory category) {
    final lessons =
        ContentRepository.lessonsByCategory(languageCode, category);
    final done = lessons.where((l) => completedLessons.contains(l.id)).length;
    final total = lessons.length;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: category.color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(category.icon, color: category.color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    category.label,
                    style: textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Text(
                    '$done/$total',
                    style: textTheme.bodySmall
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: total == 0 ? 0 : done / total,
                  minHeight: 8,
                  backgroundColor: AppColors.border,
                  color: category.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}