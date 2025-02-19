import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_deep_link/app/router.dart';
import 'package:go_router_deep_link/state/auth_provider.dart';
import 'package:go_router_deep_link/state/car_provider.dart';
import 'package:provider/provider.dart';

import 'link_manager/deep_link_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DeepLinkManager.setupDeepLinks();

  final authProvider = AuthProvider();
  await authProvider.checkAuthState();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authProvider),
        ChangeNotifierProvider(create: (_) => CarProvider()),
      ],
      child: MyApp(authProvider: authProvider),
    ),
  );
}

class MyApp extends StatefulWidget {
  final AuthProvider authProvider;

  const MyApp({Key? key, required this.authProvider}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;
  StreamSubscription? _deepLinkSubscription;

  @override
  void initState() {
    super.initState();
    _router = createRouter(widget.authProvider);

    // Listen to deep links
    _deepLinkSubscription = DeepLinkManager.deepLinkStream.listen((path) {
      print('Navigating to: $path');
      if (mounted) {
        _router.go(path);
      }
    });
  }

  @override
  void dispose() {
    _deepLinkSubscription?.cancel();
    DeepLinkManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Car App',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: _router,
    );
  }
}
