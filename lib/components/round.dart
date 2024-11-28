import 'package:client/components/button.dart';
import 'package:client/components/list_item.dart';
import 'package:client/components/ranking.dart';
import 'package:client/data/ranking.dart';
import 'package:client/data/round.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/player.dart';
import 'package:client/providers/theme.dart';
import 'package:client/utilities.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Round extends StatefulWidget {
  const Round(
      {super.key, required this.data, this.busy = false, this.callback});

  final RoundData data;
  final bool busy;
  final void Function(String)? callback;

  @override
  State<Round> createState() => _RoundState();
}

class _RoundState extends State<Round> {
  final Logger _logger = Logger();

  final _theme = ThemeProvider();
  final _player = PlayerProvider();

  bool _open = false;
  final GlobalKey _key = GlobalKey();
  double _max = 2;

  Row buildRow(List<Widget> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }

  Padding buildRankTable(List<RankingData> data) {
    _logger.t(
        "buildRankTable: ${_key.currentContext?.findRenderObject() != null ? (_key.currentContext?.findRenderObject() as RenderBox).size.height : 0}");

    Future.microtask(() {
      if (_key.currentContext != null) {
        _logger.w(
            "========Height: ${(_key.currentContext!.findRenderObject() as RenderBox).size.toString()}");

        var max =
            (_key.currentContext!.findRenderObject() as RenderBox).size.height;

        if (max != _max) {
          setState(() {
            _max = (_key.currentContext!.findRenderObject() as RenderBox)
                .size
                .height;
          });
        }
      }
    });

    return Padding(
      padding: EdgeInsets.only(bottom: _theme.gap),
      child: AnimatedContainer(
        duration: Duration(milliseconds: _theme.animationSpeed),
        height: !_open ? 0 : _max,
        child: Container(
          decoration: BoxDecoration(
              gradient: buildBackgroundGradiant(10),
              borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.hardEdge,
          height: _max,
          child: Column(
            children: [...data.map((item) => Ranking(item as dynamic))],
          ),
        ),
        onEnd: () {
          _logger.w("Animation Done");
        },
      ),
    );
  }

  Row buildStartFinishRow() {
    var now = DateTime.now();
    var children = <Widget>[];
    var style = _theme.textMediumBold;
    Text? label;
    Text? since;

    if (widget.data.starts.compareTo(now) < 0) {
      label = Text(Dictionary.get("STARTS").toUpperCase(), style: style);
      since =
          Text(timeSince(widget.data.ends, suffixFlag: false), style: style);
    } else {
      var ended = widget.data.ends.compareTo(now) < 0;
      label = Text(Dictionary.get(ended ? "ENDED" : "ENDS").toUpperCase(),
          style: style);
      since =
          Text(timeSince(widget.data.ends, suffixFlag: ended), style: style);
    }

    children.add(label);
    children.add(Text(":", style: style));
    children.add(SizedBox(width: _theme.gap / 2));
    children.add(since);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  void handleTap() {
    _logger.t("handleTap: ${widget.data.guid}");

    if (widget.data.finished) {
      _logger.w("AHHHHH");
      setState(() {
        _open = !_open;
      });
    } else {
      if (widget.callback != null) {
        widget.callback!(widget.data.guid);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    var size = MediaQuery.of(context).size.width / 12;

    _logger.t(
        "${_player.round} == ${widget.data.guid} : ${(_player.round == widget.data.guid).toString()}");

    return ListItem(
      child: Padding(
        padding: EdgeInsets.all(_theme.gap),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            widget.data.ranks?.isNotEmpty ?? false
                ? Offstage(
                    offstage: true,
                    child: Column(
                      key: _key,
                      children: [
                        ...widget.data.ranks!
                            .map((item) => Ranking(item as dynamic))
                      ],
                    ))
                : SizedBox(
                    height: 0,
                  ),
            buildRow([
              Text(
                widget.data.title,
                style: _theme.textExtraLargeBold,
              ),
              SizedBox(
                width: _theme.gap * 2,
                height: _theme.gap * 2,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.data.finished ? Colors.grey : Colors.green,
                  ),
                  child: Text(""),
                ),
              ),
            ]),
            SizedBox(height: _theme.gap),
            buildRow(
              [
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(widget.data.energyRegen.toString(),
                      style: _theme.textLargeBold),
                  SizedBox(
                    width: _theme.gap / 4,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / size,
                      child: Image.asset(
                        "assets/icons/energy.png",
                        fit: BoxFit.fitWidth,
                      )),
                  SizedBox(
                    width: _theme.gap / 2,
                  ),
                  Text(Dictionary.get("EVERY").toUpperCase(),
                      style: _theme.textLargeBold),
                  SizedBox(
                    width: _theme.gap / 2,
                  ),
                  Text(widget.data.energyRegen.toString(),
                      style: _theme.textLargeBold),
                  SizedBox(
                    width: _theme.gap / 2,
                  ),
                  Text(Dictionary.get("MINUTES").toUpperCase(),
                      style: _theme.textLargeBold),
                ]),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(Dictionary.get("MAX").toUpperCase(),
                        style: _theme.textLargeBold),
                    SizedBox(
                      width: _theme.gap / 2,
                    ),
                    Text(Dictionary.get("OF").toUpperCase(),
                        style: _theme.textLargeBold),
                    SizedBox(
                      width: _theme.gap / 2,
                    ),
                    Text(widget.data.energyMax.toString(),
                        style: _theme.textLargeBold),
                    SizedBox(
                      width: _theme.gap / 4,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width / size,
                        child: Image.asset(
                          "assets/icons/energy.png",
                          fit: BoxFit.fitWidth,
                        )),
                  ],
                ),
              ],
            ),
            SizedBox(height: _theme.gap),
            buildRow(
              [
                buildStartFinishRow(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${Dictionary.get("PLAYERS").toUpperCase()}:",
                      style: _theme.textLargeBold,
                    ),
                    SizedBox(
                      width: _theme.gap / 2,
                    ),
                    Text(widget.data.players.toString(),
                        style: _theme.textLargeBold),
                  ],
                ),
              ],
            ),
            SizedBox(height: _theme.gap),
            widget.data.ranks?.isNotEmpty ?? false
                ? buildRankTable(widget.data.ranks ?? <RankingData>[])
                : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: size * (widget.data.finished ? 3.25 : 2.5),
                  child: Button(
                    text: Dictionary.get((widget.data.finished
                            ? (_open ? "HIDE_RANKS" : "SHOW_RANKS")
                            : (_player.round == widget.data.guid
                                ? "CURRENT"
                                : "PLAY")))
                        .toUpperCase(),
                    handler: () => handleTap(),
                    largeFont: true,
                    busy: widget.busy,
                    enabled: _player.round != widget.data.guid,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
