import 'package:client/data/class_colors.dart';
import 'package:flutter/material.dart';

import 'package:client/providers/theme.dart';
import 'package:logger/logger.dart';

class ListItem extends StatelessWidget {
  ListItem({
    super.key,
    required this.child,
    this.classColors,
  });

  final _theme = ThemeProvider();
  final _logger = Logger();

  final Widget child;
  final ClassColors? classColors;

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(_theme.gap)),
        color: _theme.colorBackground.withAlpha(100),
        boxShadow: _theme.boxShadows,
      ),
      child: child,
    );
  }
}
