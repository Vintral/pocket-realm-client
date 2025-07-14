import 'package:client/capitalize.dart';
import 'package:client/components/base_button.dart';
import 'package:client/components/base_display.dart';
import 'package:client/components/devotion.dart';
import 'package:client/data/pantheon.dart';
import 'package:client/providers/temple.dart';
import 'package:client/utilities.dart';
import 'package:flutter/material.dart';

import 'package:eventify/eventify.dart' as eventify;
import 'package:logger/logger.dart';

import 'package:client/components/item_with_border.dart';
import 'package:client/components/panel.dart';
import 'package:client/components/tab_bar.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/player.dart';
import 'package:client/providers/theme.dart';
import 'package:client/states/list_panel.dart';

class TemplePanel extends StatefulWidget {
  const TemplePanel({super.key, required this.callback});

  final void Function(BuildContext) callback;

  @override
  State<TemplePanel> createState() => _TemplePanelState();
}

class _TemplePanelState extends ListPanelState<TemplePanel>
    with TickerProviderStateMixin {
  final Logger _logger = Logger();

  final _theme = ThemeProvider();
  final _player = PlayerProvider();
  final _provider = TempleProvider();

  late TabController _tabController;

  late eventify.Listener _onLoadedListener;
  late eventify.Listener _onBusyChangedListener;

  @override
  void initState() {
    super.initState();

    _onBusyChangedListener = _provider.on("BUSY_CHANGED", null, onBusyChanged);
    _onLoadedListener = _provider.on("LOADED", null, onLoaded);

    createTabController();

    if (!_provider.loaded) {
      _provider.load();
    }

    _logger.t("initState");
  }

  @override
  void dispose() {
    _logger.t("dispose");

    _tabController.dispose();

    _onBusyChangedListener.cancel();
    _onLoadedListener.cancel();

    super.dispose();
  }

  void onBusyChanged(e, o) {
    _logger.t("onBusyChanged");
    setState(() {});
  }

  void createTabController() {
    _logger.t("createTabController");

    _tabController =
        TabController(length: _provider.pantheons.length, vsync: this);
    _tabController.addListener(onTabControllerChange);
  }

  void onLoaded(e, o) {
    _logger.t("onLoaded");

    createTabController();

    setState(() {});
  }

  void onTabControllerChange() {
    _logger.t("onTabControllerChange: ${_tabController.index}");
    setState(() {
      _provider.activeTab =
          _provider.pantheons[_tabController.index].name.toLowerCase();
    });
  }

  void onTab(String tab) {
    _logger.e("onTab: $tab");
    setState(() {
      _provider.activeTab = tab.toLowerCase();

      _tabController.index = _provider.pantheons.indexWhere(
          (pantheon) => pantheon.name.toLowerCase() == _provider.activeTab);
    });
  }

  Widget buildLostFaith() {
    _logger.e("buildLostFaith");

    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        // height: MediaQuery.of(context).size.width / 5,
        width: MediaQuery.of(context).size.width,
        child: BaseDisplay(
          child: Padding(
            padding: EdgeInsets.all(_theme.gap * 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: _theme.gap,
              children: [
                Text(Dictionary.get("ANGERED_GODS").capitalize(),
                    style: _theme.textExtraLargeBold),
                Text(
                    "${Dictionary.get("COME_BACK").capitalize()}: ${timeUntil(_player.lostFaith!.add(const Duration(days: 2)), suffixFlag: false)}",
                    style: _theme.textLargeBold)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUserPantheon(PantheonData data) {
    _logger.t("buildUserPantheon");

    return Center(
      child: Text(
        "User Pantheon".toUpperCase(),
        style: _theme.textExtraLargeBold,
      ),
    );
  }

  Widget buildPantheonList() {
    _logger.t("buildPantheonList");

    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(
        height: _theme.gap,
      ),
      itemBuilder: (context, index) => ItemWithBorder(
        image: "assets/none.png",
        padding: EdgeInsets.all(_theme.gap),
        active: _provider.activeTab ==
            _provider.pantheons[index].name.toLowerCase(),
        handler: (pantheon) => setState(() {
          onTab(_provider.pantheons[index].name.toLowerCase());
        }),
      ),
      itemCount: _provider.pantheons.length,
    );
  }

  void onRaiseDevotion(PantheonData pantheon) {
    _logger.f("onRaiseDevotion");
    _provider.raiseDevotion(pantheon);
  }

  void onRenounceDevotion() {
    _logger.f("onRenounceDevotion");
    _provider.renounceDevotion();
  }

  Widget buildPantheonDetail(PantheonData data) {
    _logger.t("buildPantheonDetail");

    var buttons = <Widget>[];

    if (_provider.currentPantheon.isEmpty ||
        (_provider.currentPantheon == data.name &&
            _provider.currentLevel < data.devotions.length)) {
      buttons.add(
        SizedBox(
          height: MediaQuery.of(context).size.height / 20,
          child: BaseButton(
            borderRadius: BorderRadius.circular(_theme.gap / 2),
            handler: () => onRaiseDevotion(data),
            child: Text(
              Dictionary.get("RAISE_DEVOTION").toUpperCase(),
              style: _theme.textLargeBold,
            ),
          ),
        ),
      );
    }

    if (data.name == _provider.currentPantheon) {
      buttons.add(
        SizedBox(
          height: MediaQuery.of(context).size.height / 20,
          child: BaseButton(
            borderRadius: BorderRadius.circular(_theme.gap / 2),
            handler: onRenounceDevotion,
            child: Text(
              Dictionary.get("RENOUNCE_DEVOTION").toUpperCase(),
              style: _theme.textLargeBold,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(left: _theme.gap),
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            spacing: _theme.gap,
            children: [
              BaseDisplay(
                child: Padding(
                  padding: EdgeInsets.all(_theme.gap),
                  child: Center(
                    child: Text(
                      data.name.toUpperCase(),
                      style: _theme.textExtraLargeBold,
                    ),
                  ),
                ),
              ),
              ...data.devotions.map((devotion) => Devotion(data: devotion)),
              ...buttons,
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContent() {
    _logger.t("buildContent");

    if (_player.lostFaith != null &&
        _player.lostFaith!
            .isAfter(DateTime.now().subtract(const Duration(days: 2)))) {
      return buildLostFaith();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 1,
          child: buildPantheonList(),
        ),
        Flexible(
          flex: 3,
          child: TabBarView(
            controller: _tabController,
            children: [
              ..._provider.pantheons
                  .map((pantheon) => buildPantheonDetail(pantheon)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _logger.e("build: ${_provider.loaded}");

    widget.callback(context);

    return Panel(
      label: Dictionary.get("TEMPLE"),
      loaded: !_provider.busy,
      child: buildContent(),
    );
  }
}
