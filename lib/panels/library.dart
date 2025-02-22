import 'package:flutter/material.dart';

// import 'package:eventify/eventify.dart' as eventify;
import 'package:logger/logger.dart';

import 'package:client/components/panel.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/player.dart';
import 'package:client/providers/theme.dart';
import 'package:client/settings.dart';
import 'package:client/states/list_panel.dart';

class LibraryPanel extends StatefulWidget {
  const LibraryPanel({super.key, required this.callback});

  final void Function(BuildContext) callback;

  @override
  State<LibraryPanel> createState() => _LibraryPanelState();
}

class _LibraryPanelState extends ListPanelState<LibraryPanel>
    with TickerProviderStateMixin {
  final Logger _logger = Logger(level: Level.debug);

  final _theme = ThemeProvider();
  final _player = PlayerProvider();

  @override
  void initState() {
    super.initState();

    _logger.t("initState");
  }

  @override
  void dispose() {
    _logger.t("dispose");

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    widget.callback(context);

    return Panel(
      label: Dictionary.get("LIBRARY"),
      rightChild: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(_player.research.toString(), style: _theme.textLarge),
          Image.asset(
            "assets/icons/research.png",
            width: Settings.gap * 3,
            height: Settings.gap * 3,
          ),
        ],
      ),
      child: Center(
        child: Text(
          "Library Panel",
          style: _theme.textExtraLarge,
        ),
      ),
    );
  }
}
