import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final String username;
  final String email;
  final String profilePictureUrl;
  final VoidCallback onLogout;
  final VoidCallback onExit;

  const CustomDrawer({
    super.key,
    required this.username,
    required this.email,
    required this.profilePictureUrl,
    required this.onLogout,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(username),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  profilePictureUrl),
            ),
            decoration: const BoxDecoration(
              color: Colors.black26
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