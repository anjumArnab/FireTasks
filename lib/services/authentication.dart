import 'package:firetasks/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthMethods{
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);
  // EMAIL Sign UP
  Future<void> singUpWithEmail({required String email, required String password, required BuildContext context}) async {
    try{
     final credential= await _auth.createUserWithEmailAndPassword(email: email, password: password);
     print(credential.user!.uid);
      //await sendEmailVerification(context);
    } on FirebaseAuthException catch(e){
      showSnackBar(context, e.message!);
    }
  }
  // EMAIL Sign IN
  Future<void> signInWithEmail({required String email, required String password, required BuildContext context}) async {
    try{
      await _auth.signInWithEmailAndPassword(
    email: email,
    password: password
  );
    } on FirebaseAuthException catch(e){
      showSnackBar(context, e.message!);
    }
  }
  // EMAIL verification
  Future<void> sendEmailVerification(BuildContext context) async {
    try{
      await _auth.currentUser!.sendEmailVerification();
      showSnackBar(context, 'Verification email sent');
    } on FirebaseAuthException catch(e){
      showSnackBar(context, e.message!);
    }
  }
  // Sign OUT
  Future<void> signOut(BuildContext context) async {
    try{
      await _auth.signOut();
    } on FirebaseAuthException catch(e){
      showSnackBar(context, e.message!);
    }
  }
}