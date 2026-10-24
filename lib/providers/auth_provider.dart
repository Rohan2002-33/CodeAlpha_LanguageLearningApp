import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:lingo_learn/services/auth_service.dart';
import 'package:lingo_learn/services/progress_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._auth, this._progress) {
    _subscription = _auth.authChanges.listen((user) {
      _user = user;
      _initialized = true;
      notifyListeners();
    });
  }

  final AuthService _auth;
  final ProgressService _progress;
  late final StreamSubscription<User?> _subscription;

  User? _user;
  bool _initialized = false;
  bool _busy = false;

  User? get user => _user;
  bool get initialized => _initialized;
  bool get busy => _busy;

  /// All methods return null on success, or an error message.
  Future<String?> signIn(String email, String password) {
    return _run(() async {
      final credential = await _auth.signIn(email, password);
      await _progress.ensureProfile(credential.user!);
    });
  }

  Future<String?> register(String name, String email, String password) {
    return _run(() async {
      final credential = await _auth.register(name, email, password);
      await _progress.ensureProfile(credential.user!, name: name);
    });
  }

  Future<String?> sendPasswordReset(String email) {
    return _run(() => _auth.sendPasswordReset(email));
  }

  Future<void> signOut() => _auth.signOut();

  Future<String?> _run(Future<void> Function() action) async {
    _busy = true;
    notifyListeners();
    try {
      await action();
      return null;
    } catch (error) {
      return AuthService.friendlyError(error);
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}