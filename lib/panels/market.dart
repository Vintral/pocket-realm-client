import 'package:client/capitalize.dart';
import 'package:client/components/base_button.dart';
import 'package:client/components/base_display.dart';
import 'package:client/components/button.dart';
import 'package:client/components/quantity_row.dart';
import 'package:client/data/resource.dart';
import 'package:flutter/material.dart';

import 'package:eventify/eventify.dart' as eventify;
import 'package:logger/logger.dart';

import 'package:client/components/item_with_border.dart';
import 'package:client/components/panel.dart';
import 'package:client/components/tab_bar.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/library.dart';
import 'package:client/providers/market.dart';
import 'package:client/providers/theme.dart';
import 'package:client/states/list_panel.dart';

class MarketPanel extends StatefulWidget {
  const MarketPanel({super.key, required this.callback});

  final void Function(BuildContext) callback;

  @override
  State<MarketPanel> createState() => _MarketPanelState();
}

class _MarketPanelState extends ListPanelState<MarketPanel>
    with SingleTickerProviderStateMixin {
  final Logger _logger = Logger();

  final ThemeProvider _theme = ThemeProvider();
  final _provider = MarketProvider();
  final _library = LibraryProvider();

  late eventify.Listener _onMarketError;
  late eventify.Listener _onMarketInfo;
  late TabController _tabController;

  String _activeResource = "";
  String _activeTab = Dictionary.get("RESOURCE");
  int _quantity = 1;

  @override
  void initState() {
    super.initState();

    _logger.t("initState");

    _tabController = TabController(length: 3, vsync: this);

    // _onPlayRoundError =
    //     _connection.on("PLAY_ROUND_ERROR", null, onPlayRoundError);
    // _onPlayRoundSuccess =
    //     _connection.on("PLAY_ROUND_SUCCESS", null, onPlayRoundSucess);

    _onMarketError = _provider.on("ERROR", null, onMarketError);
    _onMarketInfo = _provider.on("INFO", null, onMarketInfo);

    // _onRoundsListener = _provider.on("ROUNDS", null, onRounds);
    // if (_provider.activeRounds.isEmpty) {
    //   _provider.getRounds();
    // }

    if (!_provider.loaded) {
      _provider.load();
    }
  }

  @override
  void dispose() {
    _logger.t("dispose");

    _onMarketError.cancel();
    _onMarketInfo.cancel();

    super.dispose();
  }

  void onTab(String tab) {
    _logger.i("onTab: $tab");
    setState(() {
      _activeTab = tab.toLowerCase();

      _logger.i("Active: $_activeTab");
      switch (_activeTab) {
        case "resource":
          _tabController.index = 0;
        case "black market":
          _tabController.index = 1;
        case "mercenary":
          _tabController.index = 2;
      }

      _logger.i("Tab Controller Index: ${_tabController.index}");
    });
  }

  void onMarketError(eventify.Event ev, Object? context) {
    _logger.w("onMarketError");

    setState(() {});
  }

  void onMarketInfo(eventify.Event ev, Object? context) {
    _logger.i("onMarketInfo");

    setState(() {});
  }

  Widget buildResourceList() {
    _logger.t("buildResourceList");

    var sellable =
        _library.resources.where((resource) => resource.canMarket).toList();

    sellable.forEach((resource) => resource.dump());

    if (_activeResource == "") {
      setState(() {
        _activeResource = sellable[0].guid;
      });
    }

    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(
        height: _theme.gap,
      ),
      itemBuilder: (context, index) => ItemWithBorder(
        item: sellable[index],
        padding: EdgeInsets.all(_theme.gap * 1.5),
        active: _activeResource != sellable[index].guid,
        handler: (resource) => setState(() {
          _activeResource = resource;
          _logger.i("Set Resource: $_activeResource");
        }),
      ),
      itemCount: sellable.length,
    );
  }

  void buy(int quantity) {
    _logger.w("buy: $quantity");
  }

  Widget buildResourceDetail() {
    _logger.t("buildResourceDetail");

    Resource? resource = _library.getResource(_activeResource);
    double buyFor = (resource?.value ?? 0) * _quantity;
    double sellFor =
        (resource?.value ?? 0) != 0 ? (1 / resource!.value) * _quantity : 0;

    var style = _theme.textLargeBold;

    return Column(
        spacing: _theme.gap,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: ItemWithBorder(
              padding: EdgeInsets.all(_theme.gap * 10),
              item: resource,
            ),
          ),
          Flexible(
              child: BaseDisplay(
                  child: Padding(
                      padding: EdgeInsets.all(_theme.gap),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(Dictionary.get("BUY").capitalize(),
                              style: _theme.textExtraLargeBold),
                          Row(
                            spacing: _theme.gap,
                            children: [
                              ...[1, 10, 100].map(
                                (val) => Flexible(
                                  child: BaseButton(children: [
                                    Text(val.toString(), style: style),
                                    Text(Dictionary.get("FOR"), style: style),
                                    Image.asset("assets/resources/gold.png")
                                  ], handler: () => buy(1)),
                                ),
                              ),
                            ],
                          )
                        ],
                      )))),
        ]);
  }

  Widget buildResourceMarket() {
    _logger.t("buildResourceMarket");

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 1,
          child: buildResourceList(),
        ),
        Flexible(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.only(left: _theme.gap),
            child: buildResourceDetail(),
          ),
        ),
      ],
    );
  }

  Widget buildBlackMarket() {
    _logger.t("buildBlackMarket");

    return Center(
      child: Text("Black Market", style: _theme.textLargeBold),
    );
  }

  Widget buildMercenaryMarket() {
    _logger.t("buildMercenaryMarket");

    return Center(
      child: Text("Mercenary", style: _theme.textLargeBold),
    );
  }

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    widget.callback(context);

    return Panel(
      loaded: _provider.loaded,
      label: Dictionary.get("MARKET"),
      header: RealmTabBar(tabs: [
        Dictionary.get("RESOURCE").toUpperCase(),
        Dictionary.get("BLACK_MARKET").toUpperCase(),
        Dictionary.get("MERCENARY").toUpperCase(),
      ], active: _activeTab, enabled: _provider.loaded, handler: onTab),
      child: TabBarView(
        controller: _tabController,
        children: [
          buildResourceMarket(),
          buildBlackMarket(),
          buildMercenaryMarket(),
        ],
      ),
    );
  }
}
