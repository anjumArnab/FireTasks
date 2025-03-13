import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firetasks/models/user_model.dart';
import 'package:firetasks/services/database.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  final FirestoreMethods _firestoreMethods;
  UserModel? _userModel;
  bool _isLoading = false;

  UserProvider()
      : _firestoreMethods = FirestoreMethods(FirebaseFirestore.instance);

  // Getters
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;

  // Fetch user data
  Future<void> fetchUserData(String uid) async {
    _isLoading = true;
    notifyListeners();

    try {
      _userModel = await _firestoreMethods.getUserData(uid);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save user data
  Future<void> saveUserData(UserModel user, String uid) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firestoreMethods.saveUserData(user, uid);
      _userModel = user;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String name,
    required String motto,
    required int age,
    required String dob,
    required String uid,
  }) async {
    if (_userModel == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      UserModel updatedUser = UserModel(
        name: name,
        email: _userModel!.email,
        motto: motto,
        age: age,
        dob: dob,
      );

      await _firestoreMethods.saveUserData(updatedUser, uid);
      _userModel = updatedUser;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reset user data
  void clearUserData() {
    _userModel = null;
    notifyListeners();
  }
}