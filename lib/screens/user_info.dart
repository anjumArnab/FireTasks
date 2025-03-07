import 'package:firebase_auth/firebase_auth.dart';
import 'package:firetasks/services/authentication.dart';
import 'package:firetasks/widgets/custom_button.dart';
import 'package:firetasks/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  bool isEditing = false;

  final TextEditingController nameController =
      TextEditingController(text: "Sakib Anjum Arnab");
  final TextEditingController mottoController =
      TextEditingController(text: "Let's do something good");
  final TextEditingController emailController =
      TextEditingController(text: "anjumarnab050@gmail.com");
  final TextEditingController ageController = TextEditingController(text: "26");
  final TextEditingController dobController =
      TextEditingController(text: "21-12-1994");

  void _handleProfileUpdate(){
    String newName = nameController.text;
    String newMotto = mottoController.text;
    String newEmail = emailController.text;
    String newAge = ageController.text;
    String newDob = dobController.text;

    bool emailChanged = newEmail != emailController.text;
    bool nameChanged = newName != nameController.text;
    bool mottoChanged = newMotto != mottoController.text;
    bool ageChanged = newAge != ageController.text;
    bool dobChanged = newDob != dobController.text;

    if(emailChanged || nameChanged || mottoChanged || ageChanged || dobChanged){
      if(emailChanged){
        // Update email
        FirebaseAuthMethods(FirebaseAuth.instance).updateEmail(newEmail: newEmail, context: context);
      }
      if(nameChanged){
        // Update name

      }
      if(mottoChanged){
        // Update motto

      }
      if(ageChanged){
        // Update age

      }
      if(dobChanged){
        // Update dob

      }

      // Show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
        ),
      );
    } else {
      // Show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No changes detected'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Info"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isEditing
                ? _buildEditableField("Name:", nameController)
                : _buildInfoTile("Name:", nameController.text),
            _buildSpacingOrDivider(),
            isEditing
                ? _buildEditableField("Motto:", mottoController)
                : _buildInfoTile("Motto:", mottoController.text),
            _buildSpacingOrDivider(),
            isEditing
                ? _buildEditableField("Email:", emailController)
                : _buildInfoTile("Email:", emailController.text),
            _buildSpacingOrDivider(),
            isEditing
                ? _buildEditableField("Age:", ageController)
                : _buildInfoTile("Age:", ageController.text),
            _buildSpacingOrDivider(),
            isEditing
                ? _buildEditableField("Date of Birth:", dobController)
                : _buildInfoTile("Date of Birth:", dobController.text),
            const SizedBox(height: 20),
            Center(
              child: CustomButton(
                onPressed: () {
                  _handleProfileUpdate();
                  setState(() {
                    isEditing = !isEditing;
                  });
                },
                text: isEditing ? 'Done' : 'Edit',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return CustomTextField(
      controller: controller,
      labelText: label,
    );
  }

  Widget _buildSpacingOrDivider() {
    return isEditing ? const SizedBox(height: 20) : const Divider(thickness: 1, height: 20);
  }
}
