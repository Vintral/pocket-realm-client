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

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 100,
          color: Colors.blue,
        ),
        Container(
          color: Colors.red,
        ),
        Container(
          color: Colors.yellow,
        ),
      ],
    );
  }
}
