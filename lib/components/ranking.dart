import 'package:client/data/ranking.dart';
import 'package:client/providers/theme.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Ranking extends StatelessWidget {
  final Logger _logger = Logger(level: Logger.level);

  final _theme = ThemeProvider();
  final RankingData data;

  Ranking({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    _logger.w("build");

    var size = (MediaQuery.of(context).size.width - _theme.gap * 2) / 4;

    data.dump();

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          height: size,
          width: size,
          color: Colors.blue,
        ),
        Expanded(
          child: Container(
            height: size,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}
