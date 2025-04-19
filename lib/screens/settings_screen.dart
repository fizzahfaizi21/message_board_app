import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  void logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Log Out'),
            leading: Icon(Icons.logout),
            onTap: () => logout(context),
          ),
          ListTile(
            title: Text('Change Password'),
            leading: Icon(Icons.lock),
            onTap: () {
              _auth.sendPasswordResetEmail(email: _auth.currentUser!.email!);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Password reset email sent.')));
            },
          ),
        ],
      ),
    );
  }
}
