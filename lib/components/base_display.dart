import 'package:flutter/material.dart';

import 'package:client/providers/theme.dart';

class BaseDisplay extends StatelessWidget {
  BaseDisplay({super.key, required this.child, this.colors});

  final _theme = ThemeProvider();
  final Widget child;
  final List<Color>? colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: _theme.boxShadows,
        gradient: RadialGradient(
          colors: colors ??
              [
                _theme.colorBackgroundGradiantLight.withAlpha(220),
                _theme.colorBackgroundGradiantDark.withAlpha(220),
              ],
        ),
      ),
      child: child,
    );
  }
}
