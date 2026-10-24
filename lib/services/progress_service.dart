import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lingo_learn/core/date_utils.dart';
import 'package:lingo_learn/models/user_profile.dart';

/// All Firestore reads/writes live here.
///
/// users/{uid}                    -> profile, xp, streak, completedLessons
/// users/{uid}/activity/{day}     -> xp earned per day (weekly chart)
/// users/{uid}/quizResults/{id}   -> quiz history
class ProgressService {
  ProgressService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  DocumentReference<Map<String, dynamic>> _userRef(String uid) =>
      _db.collection('users').doc(uid);

  Future<void> ensureProfile(User user, {String? name}) async {
    final ref = _userRef(user.uid);
    final snapshot = await ref.get();
    if (snapshot.exists) return;
    await ref.set({
      'name': name ?? user.displayName ?? 'Learner',
      'email': user.email ?? '',
      'languageCode': '',
      'xp': 0,
      'streak': 0,
      'lastStudyDate': '',
      'completedLessons': <String>[],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<UserProfile?> watchProfile(String uid) {
    return _userRef(uid).snapshots().map((snapshot) {
      final data = snapshot.data();
      return data == null ? null : UserProfile.fromMap(uid, data);
    });
  }

  Stream<Map<String, int>> watchWeeklyXp(String uid, {int days = 7}) {
    final start = dayKey(DateTime.now().subtract(Duration(days: days - 1)));
    return _userRef(uid)
        .collection('activity')
        .where('date', isGreaterThanOrEqualTo: start)
        .snapshots()
        .map((snapshot) {
      return {
        for (final doc in snapshot.docs)
          (doc.data()['date'] as String): ((doc.data()['xp'] as num?) ?? 0)
              .toInt(),
      };
    });
  }

  Future<void> setLanguage(String uid, String languageCode) {
    return _userRef(uid)
        .set({'languageCode': languageCode}, SetOptions(merge: true));
  }

  Future<void> recordSession({
    required UserProfile profile,
    required int xp,
    required String lessonTitle,
    String? lessonId,
    bool completed = false,
    int? score,
    int? total,
  }) {
    final now = DateTime.now();
    final today = dayKey(now);
    final userRef = _userRef(profile.uid);
    final batch = _db.batch();

    batch.set(
      userRef,
      {
        'xp': FieldValue.increment(xp),
        'streak': nextStreak(
          streak: profile.streak,
          lastStudyDate: profile.lastStudyDate,
          now: now,
        ),
        'lastStudyDate': today,
        if (completed && lessonId != null)
          'completedLessons': FieldValue.arrayUnion([lessonId]),
      },
      SetOptions(merge: true),
    );

    batch.set(
      userRef.collection('activity').doc(today),
      {'date': today, 'xp': FieldValue.increment(xp)},
      SetOptions(merge: true),
    );

    if (score != null && total != null) {
      batch.set(userRef.collection('quizResults').doc(), {
        'lessonId': lessonId,
        'lessonTitle': lessonTitle,
        'score': score,
        'total': total,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return batch.commit();
  }
}