import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../state/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.go('/profile/settings'),
              child: const Text('Change Email & Password'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await context.read<AuthProvider>().logout();
                if (context.mounted) {
                  context.go('/login');
                }
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
