import 'package:client/components/base_display.dart';
import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:logger/logger.dart';

import 'package:client/components/item_with_border.dart';
import 'package:client/providers/theme.dart';

class Ranking extends StatelessWidget {
  static Ranking fromData(dynamic data,
      {bool background = true, bool compressed = false}) {
    return Ranking(
        rank: data.rank,
        username: data.username,
        avatar: data.avatar,
        score: data.score,
        background: background,
        compressed: compressed);
  }

  final Logger _logger = Logger();

  final _theme = ThemeProvider();

  final int rank;
  final String username;
  final String avatar;
  final int score;
  final bool background;
  final bool compressed;

  Ranking(
      {super.key,
      required this.rank,
      required this.username,
      required this.avatar,
      required this.score,
      required this.compressed,
      required this.background});

  void dump() {
    _logger.t("""=================================
Rank: $rank
Username: $username
Avatar: $avatar
Score: $score
Background: $background
Compressed: $compressed
=================================""");
  }

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    dump();

    var size = MediaQuery.of(context).size.width / (compressed ? 15 : 8);

    var content = Row(
      children: [
        SizedBox(
          width: size,
          child: Center(
            child:
                AutoSizeText(rank.toString(), style: _theme.textExtraLargeBold),
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
                  score.toString(),
                  style:
                      _theme.textLargeBold.copyWith(color: Colors.yellow[700]),
                  textAlign: TextAlign.right,
                ))),
      ],
    );

    if (background) {
      return BaseDisplay(
        child: content,
      );
    }

    return content;
  }
}
