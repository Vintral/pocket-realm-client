import 'package:client/data/class_colors.dart';
import 'package:flutter/material.dart';

import 'package:client/providers/theme.dart';

class ListItem extends StatelessWidget {
  ListItem({
    super.key,
    required this.child,
    this.classColors,
  });

  final _theme = ThemeProvider();
  // final _player = PlayerProvider();
  final Widget child;
  final ClassColors? classColors;

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size.width / 6;

    // var colors = _theme.classColorsMap[classColors ?? _player.characterClass];

    // return Container(
    //     decoration: BoxDecoration(
    //       gradient: LinearGradient(
    //           begin: Alignment.topLeft,
    //           end: Alignment.bottomRight,
    //           colors: [
    //             colors != null
    //                 ? Color.fromARGB(
    //                     (_theme.gradientOpacity / 60).floor(),
    //                     colors.colorAccent.red,
    //                     colors.colorAccent.green,
    //                     colors.colorAccent.blue)
    //                 : Color.fromARGB(
    //                     (_theme.gradientOpacity / 60).floor(),
    //                     _theme.colorAccent.red,
    //                     _theme.colorAccent.green,
    //                     _theme.colorAccent.blue),
    //             colors != null
    //                 ? Color.fromARGB(_theme.gradientOpacity, colors.color.red,
    //                     colors.color.green, colors.color.blue)
    //                 : Color.fromARGB(_theme.gradientOpacity, _theme.color.red,
    //                     _theme.color.green, _theme.color.blue),
    //           ]),
    //       borderRadius: BorderRadius.all(Radius.circular(_theme.gap)),
    //     ),
    //     child: child);

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(_theme.gap)),
          color: _theme.colorBackground.withAlpha(100),
          boxShadow: [
            BoxShadow(
              color: _theme.shadowColor,
            ),
            BoxShadow(
              color: _theme.color.withAlpha(100),
              spreadRadius: -5,
              blurRadius: 15,
              blurStyle: BlurStyle.inner,
            ),
          ]),
      child: child,
    );
  }
}
