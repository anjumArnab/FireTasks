import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firetasks/models/user_model.dart';
import 'package:firetasks/screens/create_acc_page.dart';
import 'package:firetasks/screens/homepage.dart';
import 'package:firetasks/screens/register_user.dart';
import 'package:firetasks/services/authentication.dart';
import 'package:firetasks/services/database.dart';
import 'package:firetasks/widgets/custom_button.dart';
import 'package:firetasks/widgets/custom_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginCreateAccountScreen extends StatefulWidget {
  const LoginCreateAccountScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginCreateAccountScreenState createState() =>
      _LoginCreateAccountScreenState();
}

class _LoginCreateAccountScreenState extends State<LoginCreateAccountScreen> {
  bool _isPasswordVisible = false; // Track password visibility

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _navigateToCreateAccountScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateAccountScreen(),
      ),
    );
  }

  void _signInUser() async {
    try {
      await FirebaseAuthMethods(FirebaseAuth.instance).signInWithEmail(
        email: _emailController.text,
        password: _passwordController.text,
        context: context,
      );

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        FirestoreMethods firestoreMethods =
            FirestoreMethods(FirebaseFirestore.instance);

        // Check if user exists in Firestore
        UserModel? userModel = await firestoreMethods.getUserData(user.uid);

        if (userModel != null) {
          // If user exists, navigate to HomePage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          // If user does not exist, navigate to RegisterUser
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const RegisterUser()),
          );
        }
      }
    } catch (e) {
      // Handle errors (e.g., incorrect password, user not found)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  void _signInWithGoogle(BuildContext context) async {
    await FirebaseAuthMethods(FirebaseAuth.instance).signInWithGoogle(context);
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      // If the user is verified, navigate to the HomePage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } else {
      // If the user is not verified, navigate to the LoginCreateAccountScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginCreateAccountScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Manager"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  obscureText: !_isPasswordVisible,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  onPressed: _signInUser,
                  text: 'Login',
                ),
                const SizedBox(height: 15),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.blue),
                    children: [
                      const TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                          text: 'Create one',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.blueAccent,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap =
                                () => _navigateToCreateAccountScreen(context)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: CustomButton(
                    onPressed: () => _signInWithGoogle(context),
                    text: 'Sign in with Google',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
