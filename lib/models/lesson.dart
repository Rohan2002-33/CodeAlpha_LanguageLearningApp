import 'package:flutter/material.dart';

enum LessonCategory { vocabulary, phrases, grammar }

extension LessonCategoryX on LessonCategory {
  String get label => switch (this) {
        LessonCategory.vocabulary => 'Vocabulary',
        LessonCategory.phrases => 'Phrases',
        LessonCategory.grammar => 'Grammar',
      };

  String get itemLabel => switch (this) {
        LessonCategory.vocabulary => 'words',
        LessonCategory.phrases => 'phrases',
        LessonCategory.grammar => 'patterns',
      };

  String get description => switch (this) {
        LessonCategory.vocabulary => 'Build your word bank with everyday words.',
        LessonCategory.phrases => 'Learn ready-to-use sentences for real life.',
        LessonCategory.grammar => 'Master the building blocks of sentences.',
      };

  IconData get icon => switch (this) {
        LessonCategory.vocabulary => Icons.menu_book_rounded,
        LessonCategory.phrases => Icons.chat_bubble_rounded,
        LessonCategory.grammar => Icons.auto_stories_rounded,
      };

  Color get color => switch (this) {
        LessonCategory.vocabulary => const Color(0xFF4F46E5),
        LessonCategory.phrases => const Color(0xFF0EA5E9),
        LessonCategory.grammar => const Color(0xFFF97316),
      };
}

class StudyItem {
  const StudyItem(
    this.term,
    this.translation,
    this.pronunciation,
    this.example,
    this.exampleTranslation,
  );

  final String term;
  final String translation;
  final String pronunciation;
  final String example;
  final String exampleTranslation;
}

class Lesson {
  const Lesson({
    required this.id,
    required this.languageCode,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.items,
  });

  final String id;
  final String languageCode;
  final LessonCategory category;
  final String title;
  final String subtitle;
  final List<StudyItem> items;
}