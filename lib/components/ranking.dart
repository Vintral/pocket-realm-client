import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:client/components/item_with_border.dart';
import 'package:client/providers/theme.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Ranking extends StatelessWidget {
  static Ranking fromData(dynamic data) {
    return Ranking(
        data.place, data.username, data.avatar, data.power, data.land);
  }

  final Logger _logger = Logger(level: Level.trace);

  final _theme = ThemeProvider();

  final int place = 0;
  final String username = "";
  final int avatar = 0;
  final int power = 0;
  final int land = 0;

  Ranking(place, username, avatar, power, land, {super.key}) {
    place = place;
    username = username;
    avatar = avatar;
    power = power;
    land = land;

    dump();
  }

  void dump() {
    _logger.t("=================================");
    _logger.t("Place: $place");
    _logger.t("Username: $username");
    _logger.t("Avatar: $avatar");
    _logger.t("Power: $power");
    _logger.t("Land: $land");
    _logger.t("=================================");
  }

  @override
  Widget build(BuildContext context) {
    _logger.w("build");

    var size = MediaQuery.of(context).size.width / 10;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(stops: [
          0,
          .5,
          1
        ], colors: [
          Colors.purple.withAlpha(100),
          Colors.transparent,
          Colors.purple.withAlpha(100)
        ], transform: GradientRotation(pi / 4)),
        borderRadius: BorderRadius.circular(_theme.gap / 2),
      ),
      child: Row(
        children: [
          SizedBox(
            width: size,
            child: Center(
              child: AutoSizeText(place.toString(),
                  style: _theme.textExtraLargeBold),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(_theme.gap),
            child: ItemWithBorder(
              image: "assets/avatars/$avatar.png",
              height: size,
              backgroundColor: _theme.colorBackground,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(_theme.gap),
            child: Text(username, style: _theme.textLargeBold),
          ),
          Flexible(
              fit: FlexFit.tight,
              child: Padding(
                  padding: EdgeInsets.only(right: _theme.gap),
                  child: Text(
                    power.toString(),
                    style: _theme.textLargeBold
                        .copyWith(color: Colors.yellow[700]),
                    textAlign: TextAlign.right,
                  ))),
        ],
      ),
    );
  }
}
