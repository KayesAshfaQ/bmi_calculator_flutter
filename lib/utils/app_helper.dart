import 'package:flutter/material.dart';

class AppHelper {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  AppHelper._();

  static Future<T?> push<T>(BuildContext context, Widget page) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute<T>(builder: (context) => page),
    );
  }

  static Future<T?> pushWithAnimation<T>(BuildContext context, Widget page, {bool isTransitionVertical = false}) {
    return Navigator.push<T>(
      context,
      PageRouteBuilder<T>(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = isTransitionVertical ? const Offset(0.0, 1.0) : const Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }
}
