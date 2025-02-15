import 'package:client/components/cost_button.dart';
import 'package:client/components/display_stat.dart';
import 'package:client/components/underground_auction.dart';
import 'package:client/settings.dart';
import 'package:flutter/material.dart';

import 'package:eventify/eventify.dart' as eventify;
import 'package:logger/logger.dart';

import 'package:client/components/base_display.dart';
import 'package:client/components/market_button.dart';
import 'package:client/connection.dart';
import 'package:client/components/item_with_border.dart';
import 'package:client/components/panel.dart';
import 'package:client/components/tab_bar.dart';
import 'package:client/data/resource.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/library.dart';
import 'package:client/providers/market.dart';
import 'package:client/providers/player.dart';
import 'package:client/providers/theme.dart';
import 'package:client/states/list_panel.dart';

class MarketPanel extends StatefulWidget {
  const MarketPanel({super.key, required this.callback});

  final void Function(BuildContext) callback;

  @override
  State<MarketPanel> createState() => _MarketPanelState();
}

class _MarketPanelState extends ListPanelState<MarketPanel>
    with TickerProviderStateMixin {
  final Logger _logger = Logger();

  final _theme = ThemeProvider();
  final _provider = MarketProvider();
  final _library = LibraryProvider();
  final _connection = Connection();
  final _player = PlayerProvider();

  late eventify.Listener _onMarketError;
  late eventify.Listener _onMarketInfo;
  late eventify.Listener _onMarketSuccess;
  late eventify.Listener _onMarketBusyChanged;
  late eventify.Listener _onMarketLoaded;
  late eventify.Listener _onPlayerUpdated;

  late TabController _tabController;
  late TabController _subTabController;

  String _activeResource = "";
  String _activeTab = Dictionary.get("RESOURCE");
  String _activeSubTab = Dictionary.get("BUY");

  @override
  void initState() {
    super.initState();

    _logger.t("initState");

    _tabController = TabController(length: 3, vsync: this);
    _subTabController = TabController(length: 2, vsync: this);

    _tabController.addListener(onTabControllerChange);

    _onPlayerUpdated = _player.on("UPDATED", null, onPlayerUpdated);

    _onMarketError = _provider.on("ERROR", null, onMarketError);
    _onMarketInfo = _provider.on("INFO", null, onMarketInfo);
    _onMarketSuccess = _provider.on("SUCCESS", null, onMarketSuccess);
    _onMarketLoaded = _provider.on("LOADED", null, onMarketLoaded);
    _onMarketBusyChanged =
        _provider.on("BUSY_CHANGED", null, onMarketBusyChanged);

    if (!_provider.loaded) {
      _provider.load();
    }
  }

  @override
  void dispose() {
    _logger.t("dispose");

    _onMarketError.cancel();
    _onMarketInfo.cancel();
    _onMarketSuccess.cancel();
    _onMarketLoaded.cancel();
    _onMarketBusyChanged.cancel();

    _onPlayerUpdated.cancel();

    super.dispose();
  }

  void onPlayerUpdated(ev, o) {
    _logger.t("onPlayerUpdated");
    setState(() {});
  }

  void onTabControllerChange() {
    _logger.i("onTabControllerChange: ${_tabController.index}");
    setState(() {});
  }

  void onMarketLoaded(ev, o) {
    _logger.t("onMarketLoaded");
    setState(() {});
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
    });
  }

  void onSubTab(String tab) {
    _logger.i("onSubTab: $tab");

    setState(() {
      _activeSubTab = tab.toLowerCase();

      _logger.i("Active: $_activeSubTab");
      switch (_activeSubTab) {
        case "buy":
          _subTabController.index = 0;
        case "sell":
          _subTabController.index = 1;
      }

      _logger.i("Tab Controller Index: ${_subTabController.index}");
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

  void onMarketBusyChanged(ev, o) {
    _logger.d("onMarketBusyChanged");
    setState(() {});
  }

  void onMarketSuccess(e, o) {
    _logger.i("onMarketSuccess");
    setState(() {});
  }

  Widget buildResourceList() {
    _logger.t("buildResourceList");

    var sellable =
        _library.resources.where((resource) => resource.canMarket).toList();

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
        padding: EdgeInsets.all(_theme.gap),
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
    _logger.i("buy: $quantity");

    _provider.buyResource(quantity, _activeResource);
    setState(() {});
  }

  void sell(int quantity) {
    _logger.i("sell: $quantity");

    _connection.sendSellResource(quantity, _activeResource);
    setState(() {});
  }

  Widget buildResourceDetail() {
    _logger.t("buildResourceDetail");

    Resource? resource = _library.getResource(_activeResource);
    if (resource == null) {
      _logger.w("Missing resource");
      return SizedBox();
    }

    const vals = [1, 10, 100, 1000, 10000];
    var buttonHeight = MediaQuery.of(context).size.height / 15;

    return LayoutBuilder(
      builder: (context, constraints) => Column(
        spacing: _theme.gap,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: ItemWithBorder(
              padding: EdgeInsets.all(_theme.gap * 3),
              item: resource,
            ),
          ),
          BaseDisplay(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: _theme.gap,
              children: [
                RealmTabBar(
                    tabs: [
                      Dictionary.get("BUY").toUpperCase(),
                      Dictionary.get("SELL").toUpperCase(),
                    ],
                    active: _activeSubTab,
                    enabled: _provider.loaded,
                    handler: onSubTab),
                SizedBox(
                  width: constraints.maxWidth,
                  height: buttonHeight * 2 + _theme.gap * 2,
                  child: TabBarView(
                    controller: _subTabController,
                    children: [
                      GridView.count(
                        crossAxisCount: 3,
                        primary: true,
                        physics: NeverScrollableScrollPhysics(),
                        childAspectRatio: 1.5,
                        children: vals
                            .map(
                              (val) => Padding(
                                padding: EdgeInsets.all(_theme.gap / 2),
                                child: MarketButton(
                                  topAmount: val,
                                  busy: _provider.busy,
                                  enabled: _player.gold >= val * resource.value,
                                  topResource: resource,
                                  bottomAmount: (val * resource.value).ceil(),
                                  bottomResource: _library.resourceGold,
                                  borderRadius:
                                      BorderRadius.circular(_theme.gap),
                                  handler: () => buy(val),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      GridView.count(
                        crossAxisCount: 3,
                        // spacing: _theme.gap,
                        // runSpacing: _theme.gap,
                        children: vals
                            .map(
                              (val) => Padding(
                                padding: EdgeInsets.all(_theme.gap / 2),
                                child: MarketButton(
                                  busy: _provider.busy,
                                  topAmount: val,
                                  topResource: _library.resourceGold,
                                  bottomAmount:
                                      (val / (1 / resource.value)).ceil(),
                                  bottomResource: resource,
                                  borderRadius:
                                      BorderRadius.circular(_theme.gap),
                                  handler: () => sell(val),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    // });
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

  Widget buildUndergroundMarket() {
    _logger.t("buildUndergroundMarket");

    return ListView.separated(
      itemCount: _provider.auctions.length,
      itemBuilder: (context, index) => UndergroundAuction(
        item: _provider.auctions[index]["item"],
        auction: _provider.auctions[index]["auction"],
        cost: _provider.auctions[index]["cost"],
        expires: DateTime.parse(_provider.auctions[index]["expires"]),
        purchased: DateTime.parse(_provider.auctions[index]["purchased"]),
      ),
      separatorBuilder: (context, index) => SizedBox(height: Settings.gap),
    );
  }

  buyMercenary(int quantity) {
    _logger.i("buyMercenary: $quantity");

    _provider.buyMercenary(quantity);
    setState(() {});
  }

  Widget buildMercenaryMarket() {
    _logger.t("buildMercenaryMarket");

    if (_provider.unit == null) {
      if (_provider.loaded) {
        _logger.w("Missing unit");
      }
      return Container();
    }

    const vals = [1, 5, 10, 100];
    var size = MediaQuery.of(context).size.width * .5;

    return Column(
      children: [
        SizedBox(
          height: size,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: size,
                child: ItemWithBorder(
                  item: _provider.unit,
                ),
              ),
              SizedBox(
                width: _theme.gap,
              ),
              Expanded(
                child: Container(
                  color: _theme.color,
                  child: Padding(
                    padding: EdgeInsets.all(_theme.gap),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        DisplayStat(Dictionary.get("ATTACK"),
                            _provider.unit!.attack, "action"),
                        SizedBox(height: _theme.gap),
                        DisplayStat(Dictionary.get("DEFENSE"),
                            _provider.unit!.defense, "action"),
                        SizedBox(height: _theme.gap),
                        DisplayStat(Dictionary.get("HEALTH"),
                            _provider.unit!.health, "action"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            primary: true,
            physics: NeverScrollableScrollPhysics(),
            childAspectRatio: 3,
            children: vals
                .map(
                  (val) => Padding(
                    padding: EdgeInsets.all(_theme.gap / 2),
                    child: CostButton(
                      borderRadius: BorderRadius.circular(_theme.gap),
                      text:
                          "$val ${Dictionary.get("FOR")} ${val * _provider.unitCost}",
                      handler: () => buyMercenary(val),
                      image: "assets/icons/gold.png",
                      enabled: _player.gold > val * _provider.unitCost,
                      busy: _provider.busy,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    widget.callback(context);

    return Panel(
      loaded: _provider.loaded,
      label: Dictionary.get("MARKET"),
      rightChild: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(_player.gold.toString(), style: _theme.textLarge),
          Image.asset(
            "assets/icons/gold.png",
            width: Settings.gap * 3,
            height: Settings.gap * 3,
          ),
        ],
      ),
      header: RealmTabBar(tabs: [
        Dictionary.get("RESOURCE").toUpperCase(),
        Dictionary.get("UNDERGROUND_MARKET").toUpperCase(),
        Dictionary.get("MERCENARY").toUpperCase(),
      ], active: _activeTab, enabled: _provider.loaded, handler: onTab),
      child: TabBarView(
        controller: _tabController,
        children: [
          buildResourceMarket(),
          buildUndergroundMarket(),
          buildMercenaryMarket(),
        ],
      ),
    );
  }
}
