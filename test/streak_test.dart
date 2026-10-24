import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_learn/core/date_utils.dart';

void main() {
  final now = DateTime(2026, 10, 24, 10);

  group('nextStreak', () {
    test('first study day starts streak at 1', () {
      expect(nextStreak(streak: 0, lastStudyDate: '', now: now), 1);
    });
    test('studying after yesterday increments', () {
      expect(nextStreak(streak: 3, lastStudyDate: '2026-10-23', now: now), 4);
    });
    test('studying twice same day keeps streak', () {
      expect(nextStreak(streak: 3, lastStudyDate: '2026-10-24', now: now), 3);
    });
    test('missed days reset streak', () {
      expect(nextStreak(streak: 5, lastStudyDate: '2026-10-20', now: now), 1);
    });
  });

  group('streakFor', () {
    test('shows streak when studied yesterday', () {
      expect(streakFor(streak: 4, lastStudyDate: '2026-10-23', now: now), 4);
    });
    test('shows 0 when streak is stale', () {
      expect(streakFor(streak: 4, lastStudyDate: '2026-10-10', now: now), 0);
    });
  });
}