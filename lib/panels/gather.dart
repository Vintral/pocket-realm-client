import 'package:flutter/material.dart';

import 'package:eventify/eventify.dart' as eventify;
import 'package:logger/logger.dart';

import 'package:client/components/cost_button.dart';
import 'package:client/components/item_with_border.dart';
import 'package:client/components/panel.dart';
import 'package:client/components/realm_display_object.dart';
import 'package:client/providers/actions.dart';
import 'package:client/providers/library.dart';
import 'package:client/providers/theme.dart';
import 'package:client/settings.dart';
import 'package:client/states/list_panel.dart';

class GatherPanel extends StatefulWidget {
  const GatherPanel({super.key, required this.callback});

  final void Function(BuildContext) callback;

  @override
  State<GatherPanel> createState() => _GatherPanelState();
}

class _GatherPanelState extends ListPanelState<GatherPanel> {
  final _theme = ThemeProvider();
  final _logger = Logger(level: Logger.level);

  final _library = LibraryProvider();
  final _provider = ActionProvider();
  late eventify.Listener _onResultsListener;

  bool showButton = true;

  @override
  void initState() {
    super.initState();

    _logger.t("initState");
    _onResultsListener = _provider.on("GATHER_RESULTS", null, onResults);
  }

  @override
  void dispose() {
    super.dispose();

    _logger.t("dispose");
    _onResultsListener.cancel();
  }

  void onTap({required int energy}) {
    _logger.d("onTap");
    _provider.gather(energy: energy);
  }

  void onResults(e, o) {
    _logger.d("onResults");
    setState(() {});
  }

  void onResourceTapped(type) {
    _logger.d("onResourceTapped: $type");

    setState(() {
      _provider.resource = type;
    });
  }

  List<Widget> buildTypes() {
    _logger.t("buildTypeRow");

    var resources =
        _library.resources.where((resource) => resource.canGather).toList();
    List<Widget> ret = <Widget>[];
    for (var i = 0; i < resources.length; i++) {
      if (i != 0) {
        ret.add(SizedBox(
          width: Settings.horizontalGap,
        ));
      }
      _logger.e("${resources[i].name} == ${_provider.resource}");
      ret.add(ItemWithBorder(
        item: resources[i],
        handler: onResourceTapped,
        active: resources[i].name ==
            _library.getResource(_provider.resource ?? "")?.name,
      ));
    }

    return ret;
  }

  Widget buildHeader(BuildContext context) {
    var paddingSize = _theme.gap * 1.5;

    return Container(
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  "SPEND:",
                  style: _theme.textLargeBold,
                ),
                SizedBox(
                  width: paddingSize,
                ),
                Expanded(
                  child: CostButton(
                    borderRadius:
                        BorderRadius.all(Radius.circular(Settings.gap)),
                    text: "1",
                    handler: () => onTap(energy: 1),
                    image: "assets/icons/energy.png",
                  ),
                ),
                SizedBox(
                  width: paddingSize,
                ),
                Expanded(
                  child: CostButton(
                    borderRadius:
                        BorderRadius.all(Radius.circular(Settings.gap)),
                    text: "5",
                    handler: () => onTap(energy: 5),
                    image: "assets/icons/energy.png",
                  ),
                ),
                SizedBox(
                  width: paddingSize,
                ),
                Expanded(
                  child: CostButton(
                    borderRadius:
                        BorderRadius.all(Radius.circular(Settings.gap)),
                    text: "25",
                    handler: () => onTap(energy: 25),
                    image: "assets/icons/energy.png",
                  ),
                ),
              ],
            ),
            SizedBox(height: Settings.gap),
            Row(
              children: [
                Text(
                  "Gather:",
                  style: _theme.textLargeBold,
                ),
                SizedBox(
                  width: paddingSize,
                ),
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width / 9,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ...buildTypes(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildResults(BuildContext context) {
    if (_provider.gatherResults.isEmpty) {
      return const SizedBox();
    }

    List<Widget> widgets = <Widget>[];
    for (int i = 0; i < _provider.gatherResults.length; i++) {
      var image =
          _library.getResource(_provider.gatherResults[i].type)?.name ?? "none";
      widgets.add(RealmDisplayObject(
          image: "assets/resources/$image.png",
          color: Colors.teal,
          padding: EdgeInsets.all(Settings.gap * 1.5),
          message: _provider.gatherResults[i].message));
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
      label: "Gather",
      form: buildHeader(context),
      child: buildResults(context),
    );
  }
}
