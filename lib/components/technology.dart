import 'package:client/components/base_display.dart';
import 'package:client/components/cost_button.dart';
import 'package:client/data/technology.dart';
import 'package:client/providers/player.dart';
import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:logger/logger.dart';

import 'package:client/components/item_with_border.dart';
import 'package:client/providers/theme.dart';

class Technology extends StatelessWidget {
  final Logger _logger = Logger();

  final _theme = ThemeProvider();
  final _player = PlayerProvider();

  final TechnologyData data;
  final void Function(String) handler;
  final bool busy;

  Technology({
    super.key,
    required this.data,
    required this.handler,
    this.busy = false,
  });

  Row getBubbles(BuildContext context) {
    _logger.t("getBubbles");

    var size = MediaQuery.of(context).size.width / 10;
    var bubbles = <Widget>[];
    var maxLevels = 4;
    for (int i = 1; i <= maxLevels; i++) {
      bubbles.add(
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_theme.gap),
            color: i <= data.level ? Colors.green : Colors.grey,
          ),
          width: size,
          height: size / 2,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: _theme.gap,
      children: bubbles,
    );
  }

  onTap() {
    _logger.i("onTap");
    handler(data.guid);
  }

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    return BaseDisplay(
      child: Padding(
        padding: EdgeInsets.all(_theme.gap),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: _theme.gap,
              children: [
                Text(data.name, style: _theme.textExtraLargeBold),
                Text(data.description, style: _theme.textLarge),
                getBubbles(context),
              ],
            ),
            CostButton(
              borderRadius: BorderRadius.circular(_theme.gap / 2),
              busy: busy,
              enabled: data.cost <= _player.research,
              text: data.cost.toString(),
              handler: () => handler(data.guid),
              image: "assets/icons/gold.png",
            ),
          ],
        ),
      ),
    );
  }
}
