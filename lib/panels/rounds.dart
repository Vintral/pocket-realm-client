import 'package:client/components/panel.dart';
import 'package:client/components/round.dart';
import 'package:client/components/tab_bar.dart';
import 'package:client/connection.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/application.dart';
import 'package:client/providers/theme.dart';
import 'package:client/states/list_panel.dart';
import 'package:eventify/eventify.dart' as eventify;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class RoundsPanel extends StatefulWidget {
  const RoundsPanel({super.key, required this.callback});

  final void Function(BuildContext) callback;

  @override
  State<RoundsPanel> createState() => _RoundsPanelState();
}

class _RoundsPanelState extends ListPanelState<RoundsPanel>
    with SingleTickerProviderStateMixin {
  final Logger _logger = Logger();

  final ThemeProvider _theme = ThemeProvider();
  final _provider = ApplicationProvider();
  final _connection = Connection();

  late eventify.Listener _onRoundsListener;
  late eventify.Listener _onPlayRoundError;
  late eventify.Listener _onPlayRoundSuccess;
  late TabController _tabController;

  bool _busy = false;
  bool showButton = true;
  String _activeTab = "active";

  @override
  void initState() {
    super.initState();

    _logger.t("initState");

    _tabController = TabController(length: 2, vsync: this);

    _onPlayRoundError =
        _connection.on("PLAY_ROUND_ERROR", null, onPlayRoundError);
    _onPlayRoundSuccess =
        _connection.on("PLAY_ROUND_SUCCESS", null, onPlayRoundSucess);

    _onRoundsListener = _provider.on("ROUNDS", null, onRounds);
    if (_provider.activeRounds.isEmpty) {
      _provider.getRounds();
    }
  }

  @override
  void dispose() {
    _logger.t("dispose");

    _onRoundsListener.cancel();
    _onPlayRoundError.cancel();
    _onPlayRoundSuccess.cancel();

    super.dispose();
  }

  void onPlayRoundError(e, o) {
    _logger.w("onPlayRoundError");

    setState(() {
      _busy = false;
    });
  }

  void onPlayRoundSucess(e, o) {
    _logger.w("onPlayRoundSucess");

    setState(() {
      _busy = false;
    });
  }

  void onRounds(e, o) {
    _logger.d("onRounds");
    setState(() {});
  }

  void onTab(String tab) {
    _logger.i("onTab: $tab");
    setState(() {
      _activeTab = tab.toLowerCase();
      if (_activeTab == Dictionary.get("ACTIVE")) {
        _tabController.index = 0;
      } else {
        _tabController.index = 1;
      }
    });
  }

  void onPlayRound(String round) {
    _logger.i("onPlayRound: $round");

    setState(() {
      _busy = true;
      _connection.playRound(round);
    });
  }

  Widget buildResults(bool active) {
    List<Widget> widgets = <Widget>[];

    for (int i = 0;
        i < (active ? _provider.activeRounds : _provider.finishedRounds).length;
        i++) {
      widgets.add(Round(
        data: active ? _provider.activeRounds[i] : _provider.finishedRounds[i],
        busy: _busy,
        callback: onPlayRound,
      ));
      widgets.add(SizedBox(
        height: _theme.gap,
      ));
    }

    return ListView(
      children: [...widgets],
    );
  }

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    widget.callback(context);

    _logger.d("Loaded: ${_provider.activeRounds.isNotEmpty}");

    return Panel(
      loaded: _activeTab == Dictionary.get("ACTIVE")
          ? _provider.activeRounds.isNotEmpty
          : true,
      label: Dictionary.get("ROUNDS"),
      header: RealmTabBar(tabs: [
        Dictionary.get("ACTIVE").toUpperCase(),
        Dictionary.get("FINISHED").toUpperCase()
      ], active: _activeTab, handler: onTab),
      child: TabBarView(
        controller: _tabController,
        children: [
          buildResults(true),
          buildResults(false),
        ],
      ),
    );
  }
}
