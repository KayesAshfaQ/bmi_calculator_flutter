import 'package:flutter/material.dart';

import '../constants.dart';
import 'ripple_view.dart';

class UnitSelectionWidget<T> extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<T> items;
  final T selectedItem;
  final void Function(T)? onTap;
  final double height = 32, width = 40.0;

  const UnitSelectionWidget({
    super.key,
    required this.label,
    required this.icon,
    required this.items,
    required this.selectedItem,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        const Spacer(),
        SizedBox(
          height: height,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              bool isSelected = selectedItem == items[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                child: RippleView(
                  padding: 0,
                  rippleColor: kColorBottomContainer,
                  onTap: () {
                    onTap?.call(items[index]);
                  },
                  child: Container(
                    constraints: BoxConstraints(
                      minWidth: width,
                      minHeight: height,
                      maxWidth: width,
                      maxHeight: height,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? kColorBottomContainer : null,
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                        color: kColorLightGrey,
                        width: 1.0,
                      ),
                    ),
                    child: Text(items[index].toString().split('.').last),
                  ),
                ),
              );
              // return Text(imperialUnits[index].toString().split('.').last);
            },
          ),
        ),
      ],
    );
  }
}
