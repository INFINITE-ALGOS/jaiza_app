import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void navigateTo(MaterialPageRoute<dynamic> route) {
    navigatorKey.currentState?.push(route);
  }

  void navigateAndReplace(MaterialPageRoute<dynamic> route) {
    navigatorKey.currentState?.pushReplacement(route);
  }

  void navigateAndRemoveUntil(MaterialPageRoute<dynamic> route) {
    navigatorKey.currentState?.pushAndRemoveUntil(
      route,
          (Route<dynamic> route) => false,
    );
  }
}
