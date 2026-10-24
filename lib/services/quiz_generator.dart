import 'dart:math';

import 'package:lingo_learn/models/lesson.dart';
import 'package:lingo_learn/models/quiz_question.dart';

class QuizGenerator {
  QuizGenerator._();

  static const int maxQuestions = 8;

  static List<QuizQuestion> generate(
    Lesson lesson,
    List<StudyItem> pool, {
    Random? random,
  }) {
    final rnd = random ?? Random();
    final questions = <QuizQuestion>[
      for (final item in lesson.items) ...[
        _build(item, pool, rnd, toEnglish: true),
        _build(item, pool, rnd, toEnglish: false),
      ],
    ]..shuffle(rnd);
    return questions.take(maxQuestions).toList();
  }

  static QuizQuestion _build(
    StudyItem item,
    List<StudyItem> pool,
    Random rnd, {
    required bool toEnglish,
  }) {
    String answerOf(StudyItem i) => toEnglish ? i.translation : i.term;

    final correct = answerOf(item);
    final distractors = pool
        .map(answerOf)
        .where((text) => text != correct)
        .toSet()
        .toList()
      ..shuffle(rnd);
    final options = <String>[correct, ...distractors.take(3)]..shuffle(rnd);

    return QuizQuestion(
      instruction: toEnglish
          ? 'Choose the English meaning'
          : 'Choose the correct translation',
      prompt: toEnglish ? item.term : item.translation,
      options: options,
      correctIndex: options.indexOf(correct),
      speakText: toEnglish ? item.term : null,
    );
  }
}