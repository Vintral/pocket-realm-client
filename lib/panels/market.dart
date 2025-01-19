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
import 'package:client/settings.dart';
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

  late TabController _tabController;
  late TabController _subTabController;

  String _activeResource = "";
  String _activeTab = Dictionary.get("RESOURCE");
  String _activeSubTab = Dictionary.get("BUY");

  bool _busy = false;

  @override
  void initState() {
    super.initState();

    _logger.t("initState");

    _tabController = TabController(length: 3, vsync: this);
    _subTabController = TabController(length: 2, vsync: this);

    _tabController.addListener(onTabControllerChange);

    _onMarketError = _provider.on("ERROR", null, onMarketError);
    _onMarketInfo = _provider.on("INFO", null, onMarketInfo);
    _onMarketSuccess = _provider.on("SUCCESS", null, onMarketSuccess);
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
    _onMarketBusyChanged.cancel();

    super.dispose();
  }

  void onTabControllerChange() {
    _logger.i("onTabControllerChange: ${_tabController.index}");
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
    setState(() {
      _busy = _provider.busy;
    });
  }

  void onMarketSuccess(e, o) {
    _logger.i("onMarketSuccess");
    setState(() {
      _busy = false;
    });
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
    _logger.i("buy: $quantity");

    _provider.buyResource(quantity, _activeResource);
    setState(() {
      _busy = true;
    });
  }

  void sell(int quantity) {
    _logger.i("sell: $quantity");

    _connection.sendSellResource(quantity, _activeResource);
    setState(() {
      _busy = true;
    });
  }

  Widget buildResourceDetail() {
    _logger.t("buildResourceDetail");

    Resource? resource = _library.getResource(_activeResource);

    // double buyFor = (resource?.value ?? 0) * _quantity;
    // double sellFor =
    //     (resource?.value ?? 0) != 0 ? (1 / resource!.value) * _quantity : 0;

    const vals = [1, 10, 100, 1000, 10000];
    var buttonHeight = MediaQuery.of(context).size.height / 15;

    return LayoutBuilder(
      builder: (context, constraints) => Column(
        spacing: _theme.gap,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: ItemWithBorder(
              padding: EdgeInsets.all(_theme.gap * 10),
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
                                  topResource: resource,
                                  bottomAmount: (val * resource!.value).ceil(),
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
                                      (val / (1 / resource!.value)).ceil(),
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
