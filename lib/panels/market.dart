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
  final Logger _logger = Logger(level: Level.trace);

  final _theme = ThemeProvider();
  final _provider = MarketProvider();
  final _library = LibraryProvider();
  final _connection = Connection();
  final _player = PlayerProvider();

  late eventify.Listener _onMarketError;
  late eventify.Listener _onMarketInfo;
  late eventify.Listener _onMarketSuccess;

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

    // _onPlayRoundError =
    //     _connection.on("PLAY_ROUND_ERROR", null, onPlayRoundError);
    // _onPlayRoundSuccess =
    //     _connection.on("PLAY_ROUND_SUCCESS", null, onPlayRoundSucess);

    _onMarketError = _provider.on("ERROR", null, onMarketError);
    _onMarketInfo = _provider.on("INFO", null, onMarketInfo);
    _onMarketSuccess = _provider.on("SUCCESS", null, onMarketSuccess);

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
    _onMarketSuccess.cancel();

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

  void onSubTab(String tab) {
    _logger.f("onSubTab: $tab");
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
    _logger.w("buy: $quantity");

    _provider.buyResource(quantity, _activeResource);
    setState(() {
      _busy = true;
    });
  }

  void sell(int quantity) {
    _logger.w("sell: $quantity");

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

    // return LayoutBuilder(builder: (context, constraints) {
    //   _logger.w(constraints);

    //   var size = constraints.maxHeight - constraints.maxWidth - _theme.gap * 5;
    //   _logger.w(size);

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   _logger.w(context.size);
    //   if ((context.size?.width ?? 0) != _wrapWidth) {
    //     setState(() {
    //       _wrapWidth = context.size?.width ?? 0;
    //       _logger.w("Set Width to $_wrapWidth");
    //     });
    //   }
    //   if ((context.size?.height ?? 0) != _wrapSize) {
    //     setState(() {
    //       _wrapSize = context.size?.height ?? 0;
    //       _logger.w("Set Height to $_wrapSize");
    //     });
    //   }
    // _logger.w(
    //     (_wrapKeys[0].currentContext!.findRenderObject() as RenderBox).size);
    // _logger.w(
    //     (_wrapKeys[1].currentContext!.findRenderObject() as RenderBox).size);

    // var size = ((_wrapKeys[0].currentContext?.findRenderObject() ??
    //     _wrapKeys[1].currentContext?.findRenderObject()) as RenderBox);
    // _logger.w(size.size);

    // _wrapSize = size.size.width;

    // if (size.height != _wrapSize) {
    //   _logger.w("We need to set size |${size.height}|$_wrapSize|");
    //   setState(() {
    //     _wrapSize = size.height;
    //   });
    // } else {
    //   _logger.w("We don't need to set size |${size.height}|$_wrapSize|");
    // }
    // });

    var buttonHeight = MediaQuery.of(context).size.height / 15;
    _logger.w(buttonHeight);

    var iconSize = buttonHeight / 3;

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
                                  busy: _busy,
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
                                  busy: _busy,
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
                    // GridView.count(
                    //   crossAxisCount: 3,
                    //   primary: true,
                    //   crossAxisSpacing: _theme.gap,
                    //   mainAxisSpacing: _theme.gap,
                    //   children: vals
                    //       .map(
                    //         (val) => SizedBox(
                    //           height: 40,
                    //           child: BaseButton(
                    //             children: [
                    //               Text(val.toString(), style: style),
                    //               Text(Dictionary.get("FOR"), style: style),
                    //               // Image.asset("assets/resources/gold.png")
                    //             ],
                    //             handler: () => buy(1),
                    //           ),
                    //         ),
                    //       )
                    //       .toList(),
                    // ),
                    // GridView.count(
                    //   crossAxisCount: 3,
                    //   primary: true,
                    //   crossAxisSpacing: _theme.gap,
                    //   mainAxisSpacing: _theme.gap,
                    //   children: vals
                    //       .map(
                    //         (val) => SizedBox(
                    //           height: 40,
                    //           child: BaseButton(
                    //             children: [
                    //               Text(val.toString(), style: style),
                    //               Text(Dictionary.get("FOR"), style: style),
                    //               // Image.asset("assets/resources/gold.png")
                    //             ],
                    //             handler: () => sell(1),
                    //           ),
                    //         ),
                    //       )
                    //       .toList(),
                    // )

                    // Wrap(
                    //   key: _wrapKeys[1],
                    //   spacing: _theme.gap,
                    //   runSpacing: _theme.gap,
                    //   children: vals
                    //       .map(
                    //         (val) => SizedBox(
                    //           height: 40,
                    //           child: BaseButton(
                    //             children: [
                    //               Text(val.toString(), style: style),
                    //               Text(Dictionary.get("FOR"),
                    //                   style: style),
                    //               Image.asset(
                    //                   "assets/resources/gold.png")
                    //             ],
                    //             handler: () => sell(1),
                    //           ),
                    //         ),
                    //       )
                    //       .toList(),
                    // ),
                    // ],
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
