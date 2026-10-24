import 'package:intl/intl.dart';

final DateFormat _dayFormat = DateFormat('yyyy-MM-dd');

/// Date key used in Firestore, e.g. "2026-10-24".
String dayKey(DateTime date) => _dayFormat.format(date);

/// Streak value to store after a study session happening at [now].
int nextStreak({
  required int streak,
  required String lastStudyDate,
  required DateTime now,
}) {
  final today = dayKey(now);
  if (lastStudyDate == today) return streak < 1 ? 1 : streak;
  final yesterday = dayKey(DateTime(now.year, now.month, now.day - 1));
  return lastStudyDate == yesterday ? streak + 1 : 1;
}

/// Streak value to SHOW. Resets to 0 when user skipped a day.
int streakFor({
  required int streak,
  required String lastStudyDate,
  required DateTime now,
}) {
  final today = dayKey(now);
  final yesterday = dayKey(DateTime(now.year, now.month, now.day - 1));
  return (lastStudyDate == today || lastStudyDate == yesterday) ? streak : 0;
}