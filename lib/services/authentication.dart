import 'package:firetasks/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

  // EMAIL Sign UP (Requires Email Verification)
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await sendEmailVerification(context);
        await _auth.signOut(); // Force sign-out after registration
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  // EMAIL Sign IN (Only If Email is Verified)
  Future<void> signInWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? user = userCredential.user;
      if (user != null && user.emailVerified) {
        showSnackBar(context, "Login successful!");
      } else {
        await _auth.signOut();
        showSnackBar(context, "Please verify your email before logging in.");
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  // EMAIL verification
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      await _auth.currentUser!.sendEmailVerification();
      showSnackBar(context, 'Verification email sent');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  // Sign OUT
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      showSnackBar(context, "Signed out successfully.");
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }
}
