import 'package:flutter/material.dart';
import 'package:message_board_app/screens/auth/login_screen.dart';
import 'package:message_board_app/services/auth_service.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const ListTile(
            leading: Icon(Icons.dark_mode),
            title: Text('Dark Mode'),
            subtitle: Text('Change app appearance'),
            trailing: Icon(Icons.toggle_off),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            subtitle: Text('Configure notification settings'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Change Password'),
            subtitle: const Text('Update your login credentials'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Show password change dialog
              _showChangePasswordDialog(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy'),
            subtitle: const Text('Manage your data and privacy'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to privacy settings
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            subtitle: const Text('Get assistance'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to help and support
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            subtitle: const Text('App version and information'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Show about dialog
              showAboutDialog(
                context: context,
                applicationName: 'Chat Boards',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(
                  Icons.chat_bubble_rounded,
                  size: 50,
                  color: Colors.blue,
                ),
                children: [
                  const Text(
                    'A new age chat boards application built with Flutter and Firebase.',
                  ),
                ],
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () async {
              // Show confirmation dialog
              final shouldLogout = await _showLogoutConfirmationDialog(context);
              if (shouldLogout && context.mounted) {
                await authService.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<bool> _showLogoutConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Logout'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showChangePasswordDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String currentPassword = '';
    String newPassword = '';
    String confirmPassword = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val!.isEmpty ? 'Current password is required' : null,
                onChanged: (val) => currentPassword = val,
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val!.length < 6
                    ? 'Password must be at least 6 characters'
                    : null,
                onChanged: (val) => newPassword = val,
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val != newPassword ? 'Passwords do not match' : null,
                onChanged: (val) => confirmPassword = val,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                // Implement password change logic
                // This is a placeholder - actual implementation would need Firebase auth methods
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password updated successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text('Change Password'),
          ),
        ],
      ),
    );
  }
}
