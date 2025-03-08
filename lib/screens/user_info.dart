import 'package:firebase_auth/firebase_auth.dart';
import 'package:firetasks/models/user_model.dart';
import 'package:firetasks/services/authentication.dart';
import 'package:firetasks/widgets/custom_button.dart';
import 'package:firetasks/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class UserInfo extends StatefulWidget {
  final UserModel userModel; // Accept UserModel as a parameter

  const UserInfo({super.key, required this.userModel});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  bool isEditing = false;

  late TextEditingController nameController;
  late TextEditingController mottoController;
  late TextEditingController emailController;
  late TextEditingController ageController;
  late TextEditingController dobController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with user data
    nameController = TextEditingController(text: widget.userModel.name);
    mottoController = TextEditingController(text: widget.userModel.motto);
    emailController = TextEditingController(text: widget.userModel.email);
    ageController = TextEditingController(text: widget.userModel.age.toString());
    dobController = TextEditingController(text: widget.userModel.dob);
  }

  @override
  void dispose() {
    // Dispose controllers to free resources
    nameController.dispose();
    mottoController.dispose();
    emailController.dispose();
    ageController.dispose();
    dobController.dispose();
    super.dispose();
  }

  void _handleProfileUpdate() {
    String newName = nameController.text;
    String newMotto = mottoController.text;
    String newEmail = emailController.text;
    String newAge = ageController.text;
    String newDob = dobController.text;

    bool emailChanged = newEmail != widget.userModel.email;
    bool nameChanged = newName != widget.userModel.name;
    bool mottoChanged = newMotto != widget.userModel.motto;
    bool ageChanged = newAge != widget.userModel.age.toString();
    bool dobChanged = newDob != widget.userModel.dob;

    if (emailChanged || nameChanged || mottoChanged || ageChanged || dobChanged) {
      if (emailChanged) {
        // Update email
        FirebaseAuthMethods(FirebaseAuth.instance).updateEmail(
          newEmail: newEmail,
          context: context,
        );
      }
      // Here, you can implement Firestore updates for other fields as needed.

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } else {
      // Show message if no changes were made
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No changes detected')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Info")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isEditing
                ? _buildEditableField("Name:", nameController)
                : _buildInfoTile("Name:", widget.userModel.name),
            _buildSpacingOrDivider(),
            isEditing
                ? _buildEditableField("Motto:", mottoController)
                : _buildInfoTile("Motto:", widget.userModel.motto),
            _buildSpacingOrDivider(),
            isEditing
                ? _buildEditableField("Email:", emailController)
                : _buildInfoTile("Email:", widget.userModel.email),
            _buildSpacingOrDivider(),
            isEditing
                ? _buildEditableField("Age:", ageController)
                : _buildInfoTile("Age:", widget.userModel.age.toString()),
            _buildSpacingOrDivider(),
            isEditing
                ? _buildEditableField("Date of Birth:", dobController)
                : _buildInfoTile("Date of Birth:", widget.userModel.dob),
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
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
      ],
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return CustomTextField(controller: controller, labelText: label);
  }

  Widget _buildSpacingOrDivider() {
    return isEditing ? const SizedBox(height: 20) : const Divider(thickness: 1, height: 20);
  }
}
