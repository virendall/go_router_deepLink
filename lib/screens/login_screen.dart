import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_deep_link/state/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final authProvider = context.read<AuthProvider>();
                await authProvider.login('test@test.com', 'password');

                if (context.mounted) {
                  final pendingLink = authProvider.pendingDeepLink;
                  if (pendingLink != null) {
                    context.go(pendingLink);
                    authProvider.setPendingDeepLink(null);
                  } else {
                    context.go('/');
                  }
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
