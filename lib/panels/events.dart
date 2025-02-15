import 'package:client/components/panel.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/player.dart';
import 'package:client/providers/theme.dart';
import 'package:client/states/list_panel.dart';
import 'package:eventify/eventify.dart' as eventify;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../components/event.dart';

class EventsPanel extends StatefulWidget {
  const EventsPanel({super.key, required this.callback});

  final void Function(BuildContext) callback;

  @override
  State<EventsPanel> createState() => _EventsPanelState();
}

class _EventsPanelState extends ListPanelState<EventsPanel> {
  final Logger _logger = Logger(level: Level.off);

  final ThemeProvider _theme = ThemeProvider();
  final _provider = PlayerProvider();
  late eventify.Listener _onEventsListener;
  late eventify.Listener _onEventListener;

  @override
  void initState() {
    super.initState();

    _logger.t("initState");

    _onEventsListener = _provider.on("EVENTS", null, onEvents);
    _onEventListener = _provider.on("EVENT", null, onEvent);

    _provider.markEventsSeen();
    if (_provider.events.isEmpty) {
      _provider.getEvents(1);
    }
  }

  @override
  void dispose() {
    _logger.t("dispose");

    _onEventsListener.cancel();
    _onEventListener.cancel();

    super.dispose();
  }

  void onEvent(e, o) {
    _logger.d("onEvent");

    _logger.d(e.eventData);

    onEvents(e, o);
  }

  void onEvents(e, o) {
    _logger.d("onEvents");
    setState(() {});
  }

  Widget buildResults() {
    _logger.d("buildResults");

    List<Widget> widgets = <Widget>[];
    for (var event in _provider.events) {
      widgets.add(Event(data: event));
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

    _logger.d("Loaded: ${_provider.events.isNotEmpty}");

    return Panel(
      loaded: _provider.events.isNotEmpty,
      label: Dictionary.get("EVENTS"),
      child: buildResults(),
    );
  }
}
