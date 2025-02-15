import 'package:client/providers/theme.dart';
import 'package:client/utilities.dart';
import 'package:flutter/material.dart';

class DisplayStat extends StatelessWidget {
  DisplayStat(this.label, this.amount, this.icon, {super.key});

  final _theme = ThemeProvider();

  final String label;
  final int amount;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("${capitalizeFirst(label)}:", style: _theme.textMediumBold),
        SizedBox(width: _theme.gap),
        Text(amount.toString(), style: _theme.textMediumBold),
        SizedBox(width: _theme.gap / 2),
        SizedBox(
          width: _theme.gap * 2,
          child: Image(
            image: AssetImage("assets/icons/$icon.png"),
          ),
        ),
      ],
    );
  }
}
