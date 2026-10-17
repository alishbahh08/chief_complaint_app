import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Wraps Firebase Auth. Exposed to the widget tree via Provider so any
/// screen can read `authService.user` or call sign in/up/out.
class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _auth.currentUser;
  bool get isSignedIn => user != null;

  AuthService() {
    _auth.authStateChanges().listen((_) => notifyListeners());
  }

  /// Throws a FirebaseAuthException with a `.message` the UI can show directly.
  Future<void> signUp({required String name, required String email, required String password}) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
    await cred.user?.updateDisplayName(name.trim());
    await cred.user?.reload();
    notifyListeners();
  }

  Future<void> signIn({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
  }

  Future<void> signOut() => _auth.signOut();

  String get displayName => user?.displayName?.split(' ').first ?? 'there';
}
