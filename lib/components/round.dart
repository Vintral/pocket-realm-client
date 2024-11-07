import 'package:client/data/round.dart';
import 'package:client/providers/theme.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Round extends StatelessWidget {
  final Logger _logger = Logger(level: Level.trace);

  final _theme = ThemeProvider();
  final RoundData data;

  Round({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    var size = (MediaQuery.of(context).size.width - _theme.gap * 2) / 4;

    data.dump();

    var theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.tertiary,
      child: Padding(
        padding: EdgeInsets.all(_theme.gap),
        // child: Text("This is text"),
        child: Column(
          children: [
            Text(
              "This is text",
              style: theme.textTheme.bodyLarge!
                  .copyWith(color: theme.colorScheme.onError),
              // style: theme.textTheme.bodyLarge
            ),
            Padding(
              padding: EdgeInsets.all(_theme.gap / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data.title,
                    style: theme.textTheme.bodyLarge,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: data.finished ? Colors.red : Colors.green,
                    ),
                    child: SizedBox(
                      width: _theme.gap * 3,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
