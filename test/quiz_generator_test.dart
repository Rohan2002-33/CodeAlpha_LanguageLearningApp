import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_learn/data/content_repository.dart';
import 'package:lingo_learn/services/quiz_generator.dart';

void main() {
  test('every language builds valid quiz questions', () {
    for (final language in ContentRepository.languages) {
      final pool = ContentRepository.allItems(language.code);
      for (final lesson in ContentRepository.lessonsFor(language.code)) {
        final questions = QuizGenerator.generate(lesson, pool);
        expect(questions, isNotEmpty);
        for (final q in questions) {
          expect(q.options.length, 4);
          expect(q.options.toSet().length, 4);
          expect(q.correctIndex, inInclusiveRange(0, 3));
        }
      }
    }
  });
}