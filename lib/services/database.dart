import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firetasks/models/user_model.dart';

class FirestoreMethods{
  final FirebaseFirestore _firestore;
  FirestoreMethods(this._firestore);

  // Save user data to Firestore
  Future<void> saveUserData(UserModel user, String uid) async {
    try {
      await _firestore.collection('users').doc(uid).set(user.toMap());
      print("User data saved successfully.");
    } catch (e) {
      print("Error saving user data: $e");
    }
  }

  // Fetch user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    return null;
  }
}