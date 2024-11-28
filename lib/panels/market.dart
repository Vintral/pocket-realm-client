import 'package:client/components/button.dart';
import 'package:client/components/panel.dart';
import 'package:client/components/realm_display_object.dart';
import 'package:client/providers/actions.dart';
import 'package:client/providers/theme.dart';
import 'package:client/settings.dart';
import 'package:client/states/list_panel.dart';
import 'package:eventify/eventify.dart' as eventify;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class MarketPanel extends StatefulWidget {
  const MarketPanel({super.key, required this.callback});

  final void Function(BuildContext) callback;

  @override
  State<MarketPanel> createState() => _MarketPanelState();
}

class _MarketPanelState extends ListPanelState<MarketPanel> {
  final _theme = ThemeProvider();
  final _logger = Logger();

  final _provider = ActionProvider();

  @override
  void initState() {
    super.initState();

    _logger.t("initState");
    // _onResultsListener = _provider.on("EXPLORE_RESULTS", null, onResults);
  }

  @override
  void dispose() {
    _logger.t("dispose");
    // _onResultsListener.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    widget.callback(context);

    return Panel(
      label: "Market",
      child: Placeholder(),
    );
  }
}
