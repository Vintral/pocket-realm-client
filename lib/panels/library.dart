import 'package:client/components/technology.dart';
import 'package:flutter/material.dart';

import 'package:eventify/eventify.dart' as eventify;
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

  final _theme = ThemeProvider();
  final _player = PlayerProvider();

  late eventify.Listener _onTechnologiesRetrieved;

  bool _busy = false;

  @override
  void initState() {
    super.initState();

    if (!_player.researchLoaded) {
      _player.retrieveResearch();
    }

    _onTechnologiesRetrieved =
        _player.on("TECHNOLOGIES_RETRIEVED", null, onTechnologiesRetrieved);

    _logger.t("initState");
  }

  @override
  void dispose() {
    _logger.t("dispose");

    _onTechnologiesRetrieved.cancel();

    super.dispose();
  }

  onTechnologiesRetrieved(ev, obj) {
    _logger.d("onTechnologiesRetrieved");
    setState(() {
      _busy = false;
    });
  }

  onResearch(String tech) {
    _logger.i("onResearch $tech");
    setState(() {
      _busy = true;
      _player.purchaseResearch(tech);
    });
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
            "assets/icons/gold.png",
            width: Settings.gap * 3,
            height: Settings.gap * 3,
          ),
        ],
      ),
      loaded: _player.researchLoaded,
      child: ListView.separated(
          itemBuilder: (context, index) => Technology(
                data: _player.researchAvailable[index],
                handler: onResearch,
                busy: _busy,
              ),
          separatorBuilder: (context, index) => SizedBox(
                height: _theme.gap,
              ),
          itemCount: _player.researchAvailable.length),
    );
  }
}
