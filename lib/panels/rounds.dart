import 'package:client/components/panel.dart';
import 'package:client/components/round.dart';
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

class _RoundsPanelState extends ListPanelState<RoundsPanel> {
  final Logger _logger = Logger(level: Level.trace);

  final ThemeProvider _theme = ThemeProvider();
  final _provider = ApplicationProvider();
  late eventify.Listener _onRoundsListener;

  bool showButton = true;

  @override
  void initState() {
    super.initState();

    _logger.t("initState");

    _onRoundsListener = _provider.on("ROUNDS", null, onRounds);
    if (_provider.rounds.isEmpty) {
      _provider.getRounds();
    }
  }

  @override
  void dispose() {
    _logger.t("dispose");
    _onRoundsListener.cancel();

    super.dispose();
  }

  void onRounds(e, o) {
    _logger.d("onRounds");
    setState(() {});
  }

  Widget buildResults() {
    List<Widget> widgets = <Widget>[];

    for (int i = 0; i < _provider.rounds.length; i++) {
      widgets.add(Round(
        data: _provider.rounds[i],
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

    _logger.d("Loaded: ${_provider.rounds.isNotEmpty}");

    return Panel(
      loaded: _provider.rounds.isNotEmpty,
      label: Dictionary.get("ROUNDS"),
      child: buildResults(),
    );
  }
}
