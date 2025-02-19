import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _pendingDeepLink;

  bool get isAuthenticated => _isAuthenticated;

  String? get pendingDeepLink => _pendingDeepLink;

  Future<void> login(String email, String password) async {
    // Mock authentication
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = true;
    await SharedPreferences.getInstance().then(
      (prefs) => prefs.setBool('isAuthenticated', true),
    );
    notifyListeners();
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _pendingDeepLink = null;
    await SharedPreferences.getInstance().then(
      (prefs) => prefs.setBool('isAuthenticated', false),
    );
    notifyListeners();
  }

  void setPendingDeepLink(String? link) {
    _pendingDeepLink = link;
    notifyListeners();
  }

  Future<void> checkAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    notifyListeners();
  }
}
