import 'package:flutter/material.dart';

import 'constants.dart';

class ColorDot extends StatelessWidget {
  final Color color;
  final bool isActive;

  ColorDot({this.color, this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding / 4),
      decoration: BoxDecoration(
        border: Border.all(color: isActive ? primaryColor : Colors.transparent),
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        radius: 10,
        backgroundColor: color,
      ),
    );
  }
}
