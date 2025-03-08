import 'package:firetasks/models/user_model.dart';
import 'package:firetasks/screens/user_info.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final UserModel userModel;
  final VoidCallback onLogout;
  final VoidCallback onExit;

  const CustomDrawer({
    super.key,
    required this.userModel,
    required this.onLogout,
    required this.onExit,
  });

  void _navToUserInfo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserInfo(userModel: userModel), // Pass userModel properly
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userModel.name),
            accountEmail: Text(userModel.email),
            currentAccountPicture: GestureDetector(
              onTap: () => _navToUserInfo(context),
              child: const CircleAvatar(
                backgroundImage: NetworkImage(""),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.black26,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.black),
            title: const Text('Logout'),
            onTap: onLogout,
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.black),
            title: const Text('Exit'),
            onTap: onExit,
          ),
        ],
      ),
    );
  }
}
