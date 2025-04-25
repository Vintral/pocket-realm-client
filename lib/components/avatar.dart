import 'package:client/providers/profile.dart';
import 'package:client/providers/theme.dart';
import 'package:flutter/material.dart';

import 'package:client/components/item_with_border.dart';

class Avatar extends StatelessWidget {
  Avatar({
    super.key,
    required this.avatar,
    required this.size,
    required this.username,
    this.reflect = false,
    this.disableTap = false,
    this.classType = "",
  });

  final _theme = ThemeProvider();
  final _profile = ProfileProvider();

  final String username;
  final double size;
  final String avatar;
  final bool reflect;
  final String classType;
  final bool disableTap;

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
    var child = ItemWithBorder(
      width: size,
      height: size,
      image:
          avatar.isNotEmpty ? "assets/avatars/$avatar.png" : "assets/none.png",
      backgroundColors: _theme.getClassBackgroundColors(classType),
      reflect: reflect,
    );

    if (disableTap) {
      return child;
    }

    return GestureDetector(
      onTap: () => _profile.getProfile(username),
      child: child,
    );
  }
}
