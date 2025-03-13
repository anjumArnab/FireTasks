import 'package:firetasks/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await sendEmailVerification(context);
        await _auth.signOut();
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
      if (user != null) {
        // && user.emailVerified
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

  // Google Sign In
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        User? user = userCredential.user;
        if (user != null) {
          showSnackBar(context, "Login successful!");
        }
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  // Update Email
  Future<void> updateEmail(
      {required String newEmail, required BuildContext context}) async {
    try {
      await _auth.currentUser?.verifyBeforeUpdateEmail(newEmail);
      showSnackBar(context, "Email updated successfully.");
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  // Change Password
  Future<void> updatePasswordWithReauthentication({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
    required BuildContext context,
  }) async {
    try {
      // Check if new password and confirm password match
      if (newPassword != confirmPassword) {
        showSnackBar(
            context, "New password and confirm password do not match.");
        return;
      }

      // Get the current user
      User? user = _auth.currentUser;

      if (user != null) {
        // Reauthenticate the user with the old password
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: oldPassword,
        );

        // Reauthenticate the user
        await user.reauthenticateWithCredential(credential);

        // If reauthentication is successful, update the password
        await user.updatePassword(newPassword);

        // Show success message
        showSnackBar(context, "Password updated successfully.");
      } else {
        showSnackBar(context, "No user is logged in.");
      }
    } on FirebaseAuthException catch (e) {
      // Handle error (e.g., incorrect old password)
      if (e.code == 'wrong-password') {
        showSnackBar(context, "Old password is incorrect.");
      } else {
        showSnackBar(context, e.message ?? "An error occurred.");
      }
    }
  }

  // Sign Out
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      showSnackBar(context, "Signed out successfully.");
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }
}
