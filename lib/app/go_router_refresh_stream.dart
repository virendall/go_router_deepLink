import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream() {
    uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        debugPrint('Deep link while running: $uri');
        notifyListeners();
      }
    });
  }
}
