import 'package:client/components/button.dart';
import 'package:client/components/list_item.dart';
import 'package:client/data/round.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/player.dart';
import 'package:client/providers/theme.dart';
import 'package:client/utilities.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Round extends StatelessWidget {
  final Logger _logger = Logger();

  final _theme = ThemeProvider();
  final _player = PlayerProvider();

  final RoundData data;
  final bool busy;
  final void Function(String)? callback;

  Round({super.key, required this.data, this.busy = false, this.callback});

  Row buildRow(List<Widget> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }

  Row buildStartFinishRow() {
    var now = DateTime.now();
    var children = <Widget>[];
    var style = _theme.textMediumBold;

    if (data.starts.compareTo(now) < 0) {
      children.add(Text(Dictionary.get("STARTS").toUpperCase(), style: style));
      children.add(Text(timeSince(data.ends, suffixFlag: false), style: style));
    } else {
      var ended = data.ends.compareTo(now) < 0;

      if (ended) {
        children.add(Text(Dictionary.get("ENDED").toUpperCase(), style: style));
      } else {
        children.add(Text(Dictionary.get("ENDS").toUpperCase(), style: style));
      }

      children.add(Text(":", style: style));
      children.add(SizedBox(width: _theme.gap / 2));
      children.add(Text(timeSince(data.ends, suffixFlag: ended), style: style));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  void handleTap() {
    _logger.t("handleTap: ${data.guid}");

    if (callback != null) {
      callback!(data.guid);
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    var size = MediaQuery.of(context).size.width / 12;

    _logger.t(
        "${_player.round} == ${data.guid} : ${(_player.round == data.guid).toString()}");

    return ListItem(
      child: Padding(
        padding: EdgeInsets.all(_theme.gap),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildRow([
              Text(
                data.title,
                style: _theme.textExtraLargeBold,
              ),
              SizedBox(
                width: _theme.gap * 2,
                height: _theme.gap * 2,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: data.finished ? Colors.grey : Colors.green,
                  ),
                  child: Text(""),
                ),
              ),
            ]),
            SizedBox(height: _theme.gap),
            buildRow(
              [
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(data.energyRegen.toString(),
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
                  Text(data.energyRegen.toString(),
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
                    Text(data.energyMax.toString(),
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
                    Text(data.players.toString(), style: _theme.textLargeBold),
                  ],
                ),
              ],
            ),
            SizedBox(height: _theme.gap),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: size * 2.5,
                  child: Button(
                    text: Dictionary.get(
                            (_player.round == data.guid ? "CURRENT" : "PLAY"))
                        .toUpperCase(),
                    handler: () => handleTap(),
                    largeFont: true,
                    busy: busy,
                    enabled: _player.round != data.guid,
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
