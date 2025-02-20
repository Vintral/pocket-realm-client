import 'package:client/capitalize.dart';
import 'package:client/components/base_display.dart';
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

    onEvents(e, o);
  }

  void onEvents(e, o) {
    _logger.d("onEvents");
    setState(() {});
  }

  Widget buildResults() {
    _logger.d("buildResults");

    if (_provider.events.isEmpty) {
      return Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: MediaQuery.of(context).size.width / 5,
          child: BaseDisplay(
            child: Center(
              child: Text(
                Dictionary.get("NO_EVENTS").capitalize(),
                style: _theme.textLargeBold,
              ),
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: _provider.events.length,
      itemBuilder: (context, index) => Event(data: _provider.events[index]),
      separatorBuilder: (context, index) => SizedBox(
        height: _theme.gap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    widget.callback(context);

    return Panel(
      loaded: _provider.eventsLoaded,
      label: Dictionary.get("EVENTS"),
      child: buildResults(),
    );
  }
}
