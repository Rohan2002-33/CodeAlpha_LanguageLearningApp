import 'package:lingo_learn/core/date_utils.dart';

class UserProfile {
  const UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.languageCode,
    required this.xp,
    required this.streak,
    required this.lastStudyDate,
    required this.completedLessons,
  });

  factory UserProfile.fromMap(String uid, Map<String, dynamic> data) {
    return UserProfile(
      uid: uid,
      name: (data['name'] as String?) ?? 'Learner',
      email: (data['email'] as String?) ?? '',
      languageCode: (data['languageCode'] as String?) ?? '',
      xp: (data['xp'] as num?)?.toInt() ?? 0,
      streak: (data['streak'] as num?)?.toInt() ?? 0,
      lastStudyDate: (data['lastStudyDate'] as String?) ?? '',
      completedLessons:
          List<String>.from((data['completedLessons'] as List?) ?? const []),
    );
  }

  final String uid;
  final String name;
  final String email;
  final String languageCode;
  final int xp;
  final int streak;
  final String lastStudyDate;
  final List<String> completedLessons;

  bool get hasLanguage => languageCode.isNotEmpty;

  String get firstName {
    final parts = name.trim().split(' ');
    return parts.isEmpty || parts.first.isEmpty ? 'Learner' : parts.first;
  }

  int get activeStreak => streakFor(
        streak: streak,
        lastStudyDate: lastStudyDate,
        now: DateTime.now(),
      );
}