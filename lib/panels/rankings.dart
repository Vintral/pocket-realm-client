import 'package:flutter/material.dart';

import 'package:eventify/eventify.dart' as eventify;
import 'package:logger/logger.dart';

import 'package:client/capitalize.dart';
import 'package:client/components/item_with_border.dart';
import 'package:client/components/list_item.dart';
import 'package:client/components/panel.dart';
import 'package:client/components/tab_bar.dart';
import 'package:client/data/ranking.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/rankings.dart';
import 'package:client/providers/theme.dart';
import 'package:client/states/list_panel.dart';

class RankingsPanel extends StatefulWidget {
  const RankingsPanel({super.key, required this.callback});

  final void Function(BuildContext) callback;

  @override
  State<RankingsPanel> createState() => _RankingsPanelState();
}

class _RankingsPanelState extends ListPanelState<RankingsPanel> {
  final Logger _logger = Logger();

  final ThemeProvider _theme = ThemeProvider();
  final _provider = RankingsProvider();
  late eventify.Listener _onRankingsListener;
  String _activeTab = "near";

  bool showButton = true;

  @override
  void initState() {
    super.initState();

    _logger.t("initState");

    _onRankingsListener = _provider.on("RANKINGS", null, onRankings);
    _provider.getRankings();
  }

  @override
  void dispose() {
    _logger.t("dispose");

    _onRankingsListener.cancel();
    _provider.clean();

    super.dispose();
  }

  void onRankings(e, o) {
    _logger.d("onRankings");
    setState(() {});
  }

  void onTab(String tab) {
    _logger.i("onTab: $tab");

    setState(() {
      _activeTab = tab;
    });
  }

  Widget buildRankLabel(int rank, double size) {
    _logger.t("buildRankLabel");

    return SizedBox(
      height: size,
      child: Text(
        "#$rank",
        style: _theme.textLargeBold,
      ),
    );
  }

  Widget buildStat(String value, TextStyle style, double size,
      {String? label}) {
    _logger.t("buildLabel");

    Widget ret = Text(
      value,
      style: style,
    );

    if (label?.isNotEmpty ?? false) {
      return SizedBox(
        height: size,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label?.capitalize() ?? "---", style: style),
            SizedBox(width: _theme.gap / 3),
            Text(value, style: style),
          ],
        ),
      );
    }

    return SizedBox(
      height: size,
      child: ret,
    );
  }

  Widget buildListItem(BuildContext context, RankingData data) {
    _logger.t("buildListItem");

    var size = MediaQuery.of(context).size.width / 5;

    return ListItem(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ItemWithBorder(
            image: "assets/avatars/${data.avatar}.png",
            height: size,
            backgroundColor: _theme.colorBackground,
          ),
          SizedBox(width: _theme.gap),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(_theme.gap / 2),
              child: SizedBox(
                height: size,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: buildRankLabel(data.place, size / 2),
                        ),
                        SizedBox(
                          width: _theme.gap / 2,
                        ),
                        Expanded(
                          child: buildStat(
                              data.username, _theme.textSmallBold, size / 2),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: buildStat(
                              data.power.toString(), _theme.textSmall, size / 2,
                              label: Dictionary.get("POWER").capitalize()),
                        ),
                        Expanded(
                          child: buildStat(
                              data.land.toString(), _theme.textSmall, size / 2,
                              label: Dictionary.get("LAND").capitalize()),
                        ),
                      ],
                    ),
                  ],
                ),
                // GridView.count(
                //   crossAxisCount: 2,
                //   children: [
                //     buildRankLabel(data.place),
                //     buildStat(data.power.toString(), _theme.styleRankingStat,
                //         label: Dictionary.get("POWER").capitalize()),
                //     buildStat(data.username, _theme.styleRankingStat),
                //     buildStat(data.land.toString(), _theme.styleRankingStat,
                //         label: Dictionary.get("LAND").capitalize()),
                //   ],
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildResults(BuildContext context) {
    _logger.t("buildResults : ${_provider.top.length}");

    List<Widget> widgets = <Widget>[];

    var rankings = _activeTab == Dictionary.get("NEAR").capitalize()
        ? _provider.near
        : _provider.top;
    for (int i = 0; i < rankings.length; i++) {
      widgets.add(buildListItem(context, rankings[i]));
      widgets.add(SizedBox(
        height: _theme.gap,
      ));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RealmTabBar(
          tabs: [
            Dictionary.get("NEAR").capitalize(),
            Dictionary.get("TOP").capitalize(),
          ],
          active: _activeTab,
          handler: onTab,
        ),
        Expanded(
          child: ListView(
            children: [...widgets],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    widget.callback(context);

    return Panel(
      loaded: _provider.top.isNotEmpty,
      label: Dictionary.get("RANKINGS"),
      child: buildResults(context),
    );
  }
}
