import 'package:client/providers/theme.dart';
import 'package:flutter/material.dart';

class BaseDisplay extends StatelessWidget {
  BaseDisplay({super.key, required this.child});

  final _theme = ThemeProvider();
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(colors: [
            _theme.colorBackgroundGradiantLight.withAlpha(220),
            _theme.colorBackgroundGradiantDark.withAlpha(220),
          ]),
        ),
        child: child);
  }
}
