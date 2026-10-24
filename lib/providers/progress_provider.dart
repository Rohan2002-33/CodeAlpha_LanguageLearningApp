import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:lingo_learn/core/date_utils.dart';
import 'package:lingo_learn/models/user_profile.dart';
import 'package:lingo_learn/services/progress_service.dart';

class ProgressProvider extends ChangeNotifier {
  ProgressProvider(this._service);

  final ProgressService _service;

  UserProfile? _profile;
  Map<String, int> _weeklyXp = const {};
  StreamSubscription<UserProfile?>? _profileSub;
  StreamSubscription<Map<String, int>>? _weekSub;
  String? _uid;

  UserProfile? get profile => _profile;
  Map<String, int> get weeklyXp => _weeklyXp;
  int get todayXp => _weeklyXp[dayKey(DateTime.now())] ?? 0;

  /// Called by ProxyProvider whenever auth user changes.
  void bind(User? user) {
    final uid = user?.uid;
    if (uid == _uid) return;

    _profileSub?.cancel();
    _weekSub?.cancel();
    _uid = uid;
    _profile = null;
    _weeklyXp = const {};
    if (uid == null) return;

    _profileSub = _service.watchProfile(uid).listen(
      (profile) {
        _profile = profile;
        notifyListeners();
      },
      onError: (Object e) => debugPrint('Profile stream error: $e'),
    );
    _weekSub = _service.watchWeeklyXp(uid).listen(
      (data) {
        _weeklyXp = data;
        notifyListeners();
      },
      onError: (Object e) => debugPrint('Weekly stream error: $e'),
    );
  }

  Future<void> selectLanguage(String code) async {
    final uid = _uid;
    if (uid == null) return;
    await _service.setLanguage(uid, code);
  }

  /// Fire-and-forget. Firestore queues the write offline and syncs later.
  void recordSession({
    required int xp,
    required String lessonTitle,
    String? lessonId,
    bool completed = false,
    int? score,
    int? total,
  }) {
    final profile = _profile;
    if (profile == null) return;
    _service
        .recordSession(
          profile: profile,
          xp: xp,
          lessonTitle: lessonTitle,
          lessonId: lessonId,
          completed: completed,
          score: score,
          total: total,
        )
        .catchError((Object e) => debugPrint('recordSession failed: $e'));
  }

  @override
  void dispose() {
    _profileSub?.cancel();
    _weekSub?.cancel();
    super.dispose();
  }
}