import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:uni_links/uni_links.dart';

class DeepLinkManager {
  static String? _initialLink;
  static StreamSubscription? _linkSubscription;
  static final _streamController = StreamController<String>.broadcast();

  static Stream<String> get deepLinkStream => _streamController.stream;

  static Future<void> setupDeepLinks() async {
    if (Platform.isIOS || Platform.isAndroid) {
      try {
        final initialLink = await getInitialUri();
        if (initialLink != null) {
          _handleDeepLink(initialLink.toString());
        }
      } catch (e) {
        debugPrint('Error getting initial deep link: $e');
      }
      // Listen for links while app is running
      _linkSubscription = uriLinkStream.listen(
        (Uri? uri) {
          if (uri != null) {
            _handleDeepLink(uri.toString());
          }
        },
        onError: (err) {
          debugPrint('Deep link error: $err');
        },
      );
    }
  }

  static void _handleDeepLink(String link) {
    debugPrint('Handling deep link: $link');
    final path = link.replaceFirst('carapp://', '/');
    _initialLink = path;
    _streamController.add(path);
  }

  static void dispose() {
    _linkSubscription?.cancel();
    _streamController.close();
  }
}
