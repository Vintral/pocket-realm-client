import 'package:client/components/list_item.dart';
import 'package:flutter/material.dart';

import 'package:client/components/item_with_border.dart';
import 'package:client/providers/theme.dart';
import 'package:client/utilities.dart';

class Shout extends StatelessWidget {
  Shout(
      {super.key,
      required this.avatar,
      required this.username,
      required this.time,
      required this.message,
      required this.characterClass});

  final _theme = ThemeProvider();

  final String avatar;
  final String username;
  final String characterClass;
  final DateTime time;
  final String message;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width / 6;

    var colors = _theme.classColorsMap[characterClass];

    return ListItem(
      classColors: colors,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ItemWithBorder(
            image: "assets/avatars/$avatar.png",
            height: size,
            backgroundColor: colors?.color,
          ),
          SizedBox(width: _theme.gap),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(_theme.gap / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(username, style: _theme.textLargeBold),
                      Text(timeSince(time),
                          style: _theme.textMedium
                              .copyWith(fontStyle: FontStyle.italic)),
                    ],
                  ),
                  SizedBox(height: _theme.gap / 2),
                  Text(message, style: _theme.textMedium),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
