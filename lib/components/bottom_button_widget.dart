import 'package:flutter/material.dart';
import '../constants.dart';

class BottomButtonWidget extends StatelessWidget {
  final String label;
  final Function() onTap;
  final IconData? prefixIcon;
  final IconData? suffixIcon;

  const BottomButtonWidget({
    super.key,
    required this.label,
    required this.onTap,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: kColorBottomContainer,
          foregroundColor: kColorPrimary,
          minimumSize: const Size(double.infinity, 48.0),
          splashFactory: InkRipple.splashFactory,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefixIcon != null)
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Icon(
                  prefixIcon,
                  color: Colors.white,
                ),
              ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 24.0,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (suffixIcon != null)
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Icon(
                  suffixIcon,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
