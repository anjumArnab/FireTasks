import 'package:firebase_auth/firebase_auth.dart';
import 'package:firetasks/services/authentication.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuthMethods _authMethods;
  User? _user;
  bool _isLoading = false;

  AuthProvider() : _authMethods = FirebaseAuthMethods(FirebaseAuth.instance) {
    _initializeUser();
  }

  // Getters
  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  FirebaseAuthMethods get authMethods => _authMethods;

  void _initializeUser() {
    _user = _auth.currentUser;
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // Sign Up with Email
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authMethods.signUpWithEmail(
        email: email,
        password: password,
        context: context,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign In with Email
  Future<bool> signInWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authMethods.signInWithEmail(
        email: email,
        password: password,
        context: context,
      );
      return _auth.currentUser != null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign In with Google
  Future<bool> signInWithGoogle(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authMethods.signInWithGoogle(context);
      return _auth.currentUser != null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign Out
  Future<void> signOut(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authMethods.signOut(context);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update Email
  Future<void> updateEmail({
    required String newEmail,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authMethods.updateEmail(
        newEmail: newEmail,
        context: context,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update Password
  Future<void> updatePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authMethods.updatePasswordWithReauthentication(
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
        context: context,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}