import 'dart:ui';

import 'package:client/capitalize.dart';
import 'package:client/components/base_display.dart';
import 'package:client/data/devotion.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/temple.dart';
import 'package:client/providers/theme.dart';
import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

class Devotion extends StatelessWidget {
  Devotion({super.key, required this.data});

  final _logger = Logger(level: Level.warning);
  final _theme = ThemeProvider();
  final _provider = TempleProvider();

  final DevotionData data;

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    return BaseDisplay(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: _theme.gap * 2, vertical: _theme.gap / 2),
        child: Row(
          spacing: _theme.gap / 2,
          children: [
            ClipOval(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 15,
                child: Image.asset(
                  "assets/ui/bubble.png",
                  color: _provider.currentPantheon == data.pantheon.name &&
                          data.level <= _provider.currentLevel
                      ? _theme.color
                      : Colors.grey,
                  // color: _theme.color,
                  colorBlendMode: BlendMode.color,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(_theme.gap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: _theme.gap / 2,
                children: [
                  Row(children: [
                    Text(
                      data.buff,
                      style: _theme.textLargeBold,
                    ),
                  ]),
                  Text(
                    data.effect.join(", "),
                    style:
                        _theme.textMedium.copyWith(fontStyle: FontStyle.italic),
                  ),
                  Row(
                    spacing: _theme.gap / 3,
                    children: [
                      Text(
                        "${Dictionary.get("UPKEEP").capitalize()}: ${data.upkeep}",
                        style: _theme.textMediumBold,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 25,
                        width: MediaQuery.of(context).size.width / 25,
                        child: Image.asset("assets/icons/faith.png"),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
