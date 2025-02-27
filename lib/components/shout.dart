import 'package:client/components/avatar.dart';
import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:client/components/base_display.dart';
import 'package:client/components/item_with_border.dart';
import 'package:client/data/shout.dart';
import 'package:client/providers/theme.dart';
import 'package:client/utilities.dart';

class Shout extends StatelessWidget {
  Shout(
    this.data, {
    super.key,
  });

  final _theme = ThemeProvider();
  final _logger = Logger();

  final ShoutData data;

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    var size = MediaQuery.of(context).size.width / 6;
    var colors = _theme.classColorsMap[data.characterClass];

    return BaseDisplay(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Avatar(
            avatar: data.avatar,
            size: size,
            username: data.username,
            classType: data.characterClass,
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
                      Text(data.username, style: _theme.textLargeBold),
                      Text(timeSince(data.time),
                          style: _theme.textMedium
                              .copyWith(fontStyle: FontStyle.italic)),
                    ],
                  ),
                  SizedBox(height: _theme.gap / 2),
                  Text(data.shout, style: _theme.textMedium),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
