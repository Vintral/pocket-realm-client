import 'package:client/utilities.dart';
import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:client/components/avatar.dart';
import 'package:client/components/base_display.dart';
import 'package:client/data/search_result.dart';
import 'package:client/providers/theme.dart';

class SearchResult extends StatelessWidget {
  SearchResult(
    this.data, {
    super.key,
  });

  final _theme = ThemeProvider();
  final _logger = Logger(level: Level.trace);
  final SearchResultData data;

  @override
  Widget build(BuildContext context) {
    _logger.t("build: ${data.avatar}");

    var size = MediaQuery.of(context).size.width / 4.5;
    data.dump();

    return BaseDisplay(
      child: Row(
        spacing: _theme.gap,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Avatar(
            avatar: data.avatar,
            classType: data.classType,
            size: size,
            username: data.username,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(_theme.gap),
              child: Column(
                spacing: _theme.gap / 2,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.username,
                    style: _theme.textExtraLargeBold,
                  ),
                  Text(
                    data.rank != 0 ? "#${data.rank}" : "--",
                    style: _theme.textLarge,
                  ),
                  Text(
                    data.score != 0 ? "${data.score} pts" : "--",
                    style: _theme.textLarge,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding:
                  EdgeInsets.only(top: _theme.gap / 2, right: _theme.gap / 2),
              child: Text(
                timeSince(data.lastSeen ?? DateTime.now()),
                style: _theme.textMediumBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
