import 'package:client/components/ranking.dart';
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

class _RankingsPanelState extends ListPanelState<RankingsPanel>
    with TickerProviderStateMixin {
  final Logger _logger = Logger();

  final ThemeProvider _theme = ThemeProvider();
  final _provider = RankingsProvider();
  late eventify.Listener _onRankingsListener;
  String _activeTab = "near";

  late TabController _tabController;

  bool showButton = true;

  @override
  void initState() {
    super.initState();

    _logger.t("initState");

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(onTabControllerChange);

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

  void onTabControllerChange() {
    _logger.i("onTabControllerChange: ${_tabController.index}");
    setState(() {
      switch (_tabController.index) {
        case 1:
          _activeTab = Dictionary.get("TOP");
        default:
          _activeTab = Dictionary.get("NEAR");
      }
    });
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

  Widget buildRankings(List<RankingData> data) {
    _logger.t("buildRankings");

    return ListView.separated(
      itemBuilder: (context, index) => Ranking.fromData(
        data[index],
        compressed: false,
        background: true,
      ),
      separatorBuilder: (context, index) => SizedBox(height: _theme.gap),
      itemCount: data.length,
    );
  }

  Widget buildNearRankings() {
    _logger.t("buildNearRankings");
    return buildRankings(_provider.near);
  }

  Widget buildTopRankings() {
    _logger.t("buildTopRankings");
    return buildRankings(_provider.top);
  }

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    widget.callback(context);

    return Panel(
      loaded: _provider.top.isNotEmpty,
      label: Dictionary.get("RANKINGS"),
      child: Column(
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
            child: TabBarView(controller: _tabController, children: [
              buildNearRankings(),
              buildTopRankings(),
            ]),
          ),
        ],
      ),
    );
  }
}
