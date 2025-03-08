import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firetasks/models/user_model.dart';
import 'package:firetasks/screens/homepage.dart';
import 'package:firetasks/widgets/custom_button.dart';
import 'package:firetasks/widgets/custom_text_field.dart';
import '../services/database.dart';
import 'package:flutter/material.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({Key? key}) : super(key: key);

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _mottoController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  void _registerUser() async {
    String name = _fullNameController.text;
    String age = _ageController.text;
    String motto = _mottoController.text;
    String dob = _dobController.text;

    if (name.isNotEmpty &&
        age.isNotEmpty &&
        motto.isNotEmpty &&
        dob.isNotEmpty) {
      UserModel user = UserModel(
        name: name,
        email: FirebaseAuth.instance.currentUser!.email!,
        age: int.parse(age),
        motto: motto,
        dob: dob,
      );
      // Save user data to Firestore
      await FirestoreMethods(FirebaseFirestore.instance)
          .saveUserData(user, FirebaseAuth.instance.currentUser!.uid);
      print("User registered successfully.");
    } else {
      print("Please fill all the fields.");
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Register User"),
        ),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                  ),
                ),
                CustomTextField(
                    controller: _fullNameController, labelText: "Full Name"),
                const SizedBox(height: 16),
                CustomTextField(controller: _ageController, labelText: "Age"),
                const SizedBox(height: 16),
                CustomTextField(
                    controller: _mottoController, labelText: "Motto"),
                const SizedBox(height: 16),
                CustomTextField(controller: _dobController, labelText: "DOB"),
                const SizedBox(height: 16),
                CustomButton(onPressed: _registerUser, text: "Register"),
              ],
            ),
          ),
        )));
  }
}
