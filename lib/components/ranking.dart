import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:client/components/item_with_border.dart';
import 'package:client/data/ranking.dart';
import 'package:client/providers/theme.dart';
import 'package:client/utilities.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Ranking extends StatelessWidget {
  final Logger _logger = Logger(level: Level.trace);

  final _theme = ThemeProvider();
  // final dynamic data;

  late int place;
  late String username;
  late int avatar;
  late int power;
  late int land;

  Ranking(dynamic data, {super.key}) {
    parse(data);
  }

  parse(dynamic data, {bool even = false}) {
    _logger.t(data);

    if (data is RankingData) {
      place = data.place;
      username = data.username;
      avatar = data.avatar;
      power = data.power;
      land = data.land;
    } else {
      place = 1;
      username = data["username"] ?? "";
      avatar = data["avatar"] is int
          ? data["avatar"]
          : int.tryParse(data["avatar"] ?? "0");
      power = data["power"] ?? 0;
      land = data["land"] ?? 0;
    }

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
