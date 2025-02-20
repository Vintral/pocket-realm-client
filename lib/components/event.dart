import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:client/components/base_display.dart';
import 'package:client/connection.dart';
import 'package:client/components/item_with_border.dart';
import 'package:client/data/event.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/theme.dart';
import 'package:client/utilities.dart';

class Event extends StatelessWidget {
  Event({super.key, required this.data});

  final Logger _logger = Logger(level: Level.warning);

  final _theme = ThemeProvider();
  final Connection _connection = Connection();

  final EventData data;

  Widget buildContent(BuildContext context) {
    _logger.t("buildContent");

    var size = MediaQuery.of(context).size.width / 5;

    return SizedBox(
      height: size,
      child: BaseDisplay(
        child: Row(
          spacing: _theme.gap,
          children: [
            ItemWithBorder(
              image: "assets/resources/gold.png",
              height: size,
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    top: _theme.gap / 2,
                    right: _theme.gap / 2,
                    child: Text(
                      timeSince(data.time),
                      style: _theme.textMediumBold.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      data.message,
                      style: _theme.textExtraLarge,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _logger.t("Message: ${data.message}");
    _logger.t("Time Since: ${timeSince(data.time)}");

    if (!data.seen) {
      _connection.markEventSeen(data.guid);

      return ClipRect(
        child: Banner(
          color: Colors.purple,
          message: Dictionary.get("NEW").toUpperCase(),
          location: BannerLocation.topStart,
          child: buildContent(context),
        ),
      );
    }

    return buildContent(context);
  }
}
