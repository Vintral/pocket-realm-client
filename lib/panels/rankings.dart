import 'package:client/capitalize.dart';
import 'package:client/components/panel.dart';
import 'package:client/components/ranking.dart';
import 'package:client/components/tab_bar.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/rankings.dart';
import 'package:client/providers/theme.dart';
import 'package:client/states/list_panel.dart';
import 'package:eventify/eventify.dart' as eventify;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class RankingsPanel extends StatefulWidget {
  const RankingsPanel({super.key, required this.callback});

  final void Function(BuildContext) callback;

  @override
  State<RankingsPanel> createState() => _RankingsPanelState();
}

class _RankingsPanelState extends ListPanelState<RankingsPanel> {
  final Logger _logger = Logger(level: Level.info);

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
    _logger.d("onRounds");
    setState(() {});
  }

  void onTab(String tab) {
    _logger.i("onTab: " + tab);

    setState(() {
      _activeTab = tab;
    });
  }

  Widget buildResults() {
    List<Widget> widgets = <Widget>[];
    for (int i = 0; i < _provider.top.length; i++) {
      widgets.add(Ranking(data: _provider.top[i]));
      widgets.add(SizedBox(
        height: _theme.gap,
      ));
    }

    // for (int i = 0; i < _provider.rounds.length; i++) {
    //   widgets.add(Text("Round"));
    //   widgets.add(SizedBox(
    //     height: _theme.gap,
    //   ));
    // }

    return ListView(
      children: [
        RealmTabBar(
          tabs: [
            Dictionary.get("NEAR").capitalize(),
            Dictionary.get("TOP").capitalize(),
          ],
          active: _activeTab,
          handler: onTab,
        ),
        ...widgets
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
      child: buildResults(),
    );
  }
}
