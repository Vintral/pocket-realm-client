import 'package:client/components/panel.dart';
import 'package:client/components/realm_display_object.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/application.dart';
import 'package:client/providers/theme.dart';
import 'package:client/states/list_panel.dart';
import 'package:eventify/eventify.dart' as eventify;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class InnPanel extends StatefulWidget {
  const InnPanel({super.key, required this.callback});

  final void Function(BuildContext) callback;

  @override
  State<InnPanel> createState() => _InnPanelState();
}

class _InnPanelState extends ListPanelState<InnPanel> {
  final Logger _logger = Logger(level: Logger.level);

  final ThemeProvider _theme = ThemeProvider();
  final _provider = ApplicationProvider();

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

  void onRules(e, o) {
    _logger.d("onRules");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    widget.callback(context);

    return Panel(
      loaded: _provider.rules.isNotEmpty,
      label: Dictionary.get("INN"),
      child: Text(Dictionary.get("INN"), style: _theme.textExtraLargeBold),
    );
  }
}
