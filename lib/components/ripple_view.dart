import 'package:flutter/material.dart';
import '../constants.dart';

class RippleView extends StatelessWidget {
  /// `RippleView` is a stateless widget that provides a ripple effect on tap.
  ///
  /// It takes a child widget and wraps it with a Material widget to provide the ripple effect.
  /// The ripple effect is a visual feedback for user interaction.
  ///
  /// Parameters:
  /// - `child`: The widget that you want to have the ripple effect.
  /// - `elevation`: The z-coordinate at which to place this card. This controls the size of the shadow below the card.
  /// - `padding`: The amount of space by which to inset the child.
  /// - `isCircular`: A boolean value that determines if the shape of the widget is circular or not.
  /// - `color`: The color to paint the background of the widget. The default color is white.
  /// - `onTap`: A callback function that is called when the widget is tapped.
  ///
  /// Example usage:
  /// ```dart
  /// RippleView(
  ///   child: Text('Hello World'),
  ///   elevation: 2,
  ///   padding: 8,
  ///   isCircular: true,
  ///   color: Colors.blue,
  ///   onTap: () {
  ///     print('Widget tapped!');
  ///   },
  /// );
  /// ```
  const RippleView({
    super.key,
    required this.child,
    this.padding = 8,
    this.elevation = 0,
    this.isCircular = false,
    this.color = Colors.transparent,
    this.rippleColor = kColorPrimary,
    this.onTap,
  });

  final Widget child;
  final double elevation;
  final double padding;
  final bool isCircular;
  final Color color, rippleColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final widget = Material(

      elevation: elevation,
      color: color,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: onTap,
        splashColor: rippleColor.withOpacity(0.25),
        highlightColor: rippleColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: EdgeInsets.all(padding),
          child: child,
        ),
      ),
    );

    return isCircular
        ? ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: widget,
          )
        : widget;
  }
}
