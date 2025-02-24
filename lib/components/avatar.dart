import 'package:client/providers/theme.dart';
import 'package:flutter/material.dart';

import 'package:client/components/item_with_border.dart';

class Avatar extends StatelessWidget {
  Avatar(this.avatar, this.classType, this.size, {super.key});

  final _theme = ThemeProvider();

  final double size;
  final String avatar;
  final String classType;

  Color getBackgroundColor() {
    switch (classType) {
      case "mage":
        return Colors.blue;
      case "priest":
        return Colors.white;
      case "warlord":
        return Colors.red;
      case "thief":
        return Colors.orange;
      case "merchant":
        return Colors.yellow;
    }

    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return ItemWithBorder(
      width: size,
      height: size,
      image: "assets/avatars/$avatar.png",
      backgroundColors: _theme.getClassBackgroundColors(classType),
    );
  }
}
