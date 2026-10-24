import 'package:flutter/material.dart';
import 'package:lingo_learn/core/app_theme.dart';
import 'package:lingo_learn/data/content_repository.dart';
import 'package:lingo_learn/models/lesson.dart';
import 'package:lingo_learn/providers/progress_provider.dart';
import 'package:lingo_learn/screens/flashcard_screen.dart';
import 'package:lingo_learn/screens/quiz_screen.dart';
import 'package:lingo_learn/services/tts_service.dart';
import 'package:provider/provider.dart';

class LessonDetailScreen extends StatelessWidget {
  const LessonDetailScreen({super.key, required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final language = ContentRepository.languageByCode(lesson.languageCode);
    final completed = context
            .watch<ProgressProvider>()
            .profile
            ?.completedLessons
            .contains(lesson.id) ??
        false;

    return Scaffold(
      appBar: AppBar(title: const Text('Lesson')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: AppColors.brandGradient,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          lesson.category.label,
                          style: textTheme.labelSmall
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                      const Spacer(),
                      if (completed)
                        const Icon(Icons.check_circle_rounded,
                            color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    lesson.title,
                    style: textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${language.flag} ${language.name} · ${lesson.items.length} ${lesson.category.itemLabel}',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: Colors.white.withValues(alpha: 0.85)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FlashcardScreen(lesson: lesson),
                ),
              ),
              icon: const Icon(Icons.style_rounded),
              label: const Text('Study flashcards'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => QuizScreen(lesson: lesson)),
              ),
              icon: const Icon(Icons.quiz_rounded),
              label: const Text('Take quiz'),
            ),
            const SizedBox(height: 28),
            Text(
              'In this lesson',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            for (final item in lesson.items) ...[
              Card(
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  title: Text(
                    item.term,
                    style: textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.pronunciation,
                          style: textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          item.translation,
                          style: textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.volume_up_rounded),
                    color: AppColors.primary,
                    onPressed: () => context
                        .read<TtsService>()
                        .speak(item.term, language.ttsLocale),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}