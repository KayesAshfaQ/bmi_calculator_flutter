import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  final Color? color;
  final Widget? cardChild;
  final VoidCallback? onPress;
  final BoxBorder? border;
  final EdgeInsetsGeometry? padding;

  const ReusableCard({
    super.key,
    @required this.color,
    this.cardChild,
    this.onPress,
    this.border,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: const EdgeInsets.all(12.0),
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
          border: border,
        ),
        child: cardChild,
      ),
    );
  }
}
