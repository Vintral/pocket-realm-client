import 'package:flutter/material.dart';

import 'package:client/providers/theme.dart';

class HeaderStat extends StatelessWidget {
  HeaderStat({super.key, required this.icon, required this.value});

  final _theme = ThemeProvider();

  final String icon;
  final dynamic value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value.toString(),
          style: _theme.textMediumBold,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 64,
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width / 32,
            child: Image.asset(
              "assets/icons/$icon.png",
              fit: BoxFit.fitWidth,
            )),
      ],
    );
  }
}
