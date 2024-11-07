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

class ExplorePanel extends StatefulWidget {
  const ExplorePanel({super.key, required this.callback});

  final void Function(BuildContext) callback;

  @override
  State<ExplorePanel> createState() => _ExplorePanelState();
}

class _ExplorePanelState extends ListPanelState<ExplorePanel> {
  final _theme = ThemeProvider();
  final _logger = Logger();

  final _provider = ActionProvider();
  late eventify.Listener _onResultsListener;

  bool showButton = true;

  @override
  void initState() {
    super.initState();

    _logger.t("initState");
    _onResultsListener = _provider.on("EXPLORE_RESULTS", null, onResults);
  }

  @override
  void dispose() {
    _logger.t("dispose");
    _onResultsListener.cancel();

    super.dispose();
  }

  void onTap({required int energy}) {
    _logger.d("onTap");
    _provider.explore(energy: energy);
  }

  void onResults(e, o) {
    _logger.d("onResults");
    setState(() {});
  }

  Widget buildHeader(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var paddingSize = 15.0;

    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          color: _theme.colorBackground,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: _theme.colorBackground,
              spreadRadius: -5.0,
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: paddingSize, vertical: paddingSize / 2),
          child: Row(
            children: [
              Text(
                "SPEND:",
                style: _theme.textLargeBold,
              ),
              SizedBox(
                width: paddingSize,
              ),
              Expanded(
                child: Button(
                  text: "1",
                  handler: () => onTap(energy: 1),
                  image: "assets/icons/energy.png",
                ),
              ),
              SizedBox(
                width: paddingSize,
              ),
              Expanded(
                child: Button(
                  text: "5",
                  handler: () => onTap(energy: 5),
                  image: "assets/icons/energy.png",
                ),
              ),
              SizedBox(
                width: paddingSize,
              ),
              Expanded(
                child: Button(
                  text: "25",
                  handler: () => onTap(energy: 25),
                  image: "assets/icons/energy.png",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildResults() {
    if (_provider.exploreResults.isEmpty) {
      return const SizedBox();
    }

    List<Widget> widgets = <Widget>[];
    for (int i = 0; i < _provider.exploreResults.length; i++) {
      widgets.add(
          RealmDisplayObject(message: _provider.exploreResults[i].message));
      widgets.add(SizedBox(height: Settings.verticalSpacer));
    }

    return ListView(
      children: [...widgets],
    );
  }

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    widget.callback(context);

    return Panel(
      label: "Explore",
      form: buildHeader(context),
      child: buildResults(),
    );
  }
}
