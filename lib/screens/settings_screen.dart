import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'New Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Implement password change logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings updated')),
                );
                context.pop();
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
