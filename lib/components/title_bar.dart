import 'package:flutter/material.dart';

import 'package:client/providers/theme.dart';

class TitleBar extends StatelessWidget {
  TitleBar({
    super.key,
    required this.text,
    this.child,
  });

  final _theme = ThemeProvider();
  final String text;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(_theme.color, BlendMode.modulate),
            child: const Image(
              image: AssetImage("assets/ui/panel-header.png"),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: _theme.gap),
              child: Text(
                text,
                style: _theme.textExtraLargeBold,
              ),
            ),
            child ?? SizedBox.shrink(),
          ],
        ),
      ],
    );
  }
}
