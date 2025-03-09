import 'package:client/data/unit.dart';
import 'package:client/providers/library.dart';
import 'package:eventify/eventify.dart';
import 'package:logger/logger.dart';

import 'package:client/connection.dart';

class MarketProvider extends EventEmitter {
  static final MarketProvider _instance = MarketProvider._internal();

  factory MarketProvider() {
    return _instance;
  }

  final Logger _logger = Logger();
  final _library = LibraryProvider();
  final Connection _connection = Connection();

  bool _busy = false;
  bool get busy => _busy;
  set busy(value) {
    if (_busy != value) {
      emit("BUSY_CHANGED");
    }

    _busy = value;
  }

  bool _undergroundLoaded = false;
  bool _resourceLoaded = false;
  bool _mercenaryLoaded = false;

  Unit? _unit;
  Unit? get unit => _unit;

  int _unitCost = 0;
  int get unitCost => _unitCost;

  List<dynamic> _auctions = [];
  List<dynamic> get auctions => _auctions;

  bool _loaded = false;
  bool get loaded => _loaded;
  set loaded(value) {
    if (!_loaded && value) {
      _logger.t("Emit: LOADED");
      emit("LOADED");
    }

    _loaded = value;
  }

  MarketProvider._internal() {
    _logger.d("Created");

    _connection.on("ERROR", null, onError);
    _connection.on("UNDERGROUND_MARKET", null, onUndergroundMarket);
    _connection.on("MERCENARY_MARKET", null, onMercenaryMarket);
    _connection.on("MARKET_INFO", null, onMarketInfo);
    _connection.on("MARKET_SOLD", null, onMarketSold);
    _connection.on("MARKET_BOUGHT", null, onMarketBought);
    _connection.on("BUY_AUCTION_RESULT", null, onBuyAuctionResult);
    _connection.on("BUY_MERCENARY", null, onBuyMercenary);
  }

  void onError(Event ev, Object? context) {
    _logger.w("onError");

    emit("ERROR");
  }

  void clearBusy() {
    _logger.t("clearBusy");
    busy = false;
  }

  void onBuyAuctionResult(ev, o) {
    _logger.d("onBuyAuctionResult");

    clearBusy();
    _connection.getUndergroundMarket();
  }

  void onMarketSold(e, o) {
    _logger.t("onMarketSold");

    clearBusy();
    emit("SUCCESS");
  }

  void onMarketBought(e, o) {
    _logger.t("onMarketBought");

    clearBusy();
    emit("SUCCESS");
  }

  void onBuyMercenary(ev, o) {
    _logger.t("onBuyMercenary");

    var data = ev.eventData as dynamic;
    if (!data["success"]) {
      _logger.w("Failed to buy mercenary");
    }

    clearBusy();
    emit("SUCCESS");
  }

  void onUndergroundMarket(ev, o) {
    _logger.t("onUndergroundMarket");

    var data = ev.eventData as dynamic;
    _auctions.clear();

    if (data["auctions"] != null) {
      _auctions = data["auctions"];
    }

    _logger.t(_auctions);

    _undergroundLoaded = true;
    checkAllReady();
  }

  void checkAllReady() {
    _logger.t("checkAllReady");

    loaded = _resourceLoaded && _undergroundLoaded && _mercenaryLoaded;
  }

  void onMercenaryMarket(ev, o) {
    _logger.t("onMercenaryMarket");

    _mercenaryLoaded = true;
    checkAllReady();

    var data = ev.eventData as dynamic;
    var mercenary = data["mercenary"];

    var unit = _library.getUnit(mercenary["unit"]);
    _unitCost = mercenary["cost"];

    if (unit != null) {
      _unit = unit;
    } else {
      _logger.w("No unit for mercenary market");
    }
  }

  void onMarketInfo(Event ev, Object? context) {
    _logger.t("onMarketInfo");

    _resourceLoaded = true;
    checkAllReady();

    var data = ev.eventData as dynamic;

    _logger.t(data["resources"]);

    // data = _connection.decodePayload(data["resources"]);
    for (var resource in data["resources"]) {
      _library.getResource(resource["resource"])?.value =
          double.tryParse(resource["value"].toString());
    }

    emit("INFO");
  }

  void buyResource(int amount, String resource) {
    _logger.t("buyResource: $amount $resource");
    _connection.sendBuyResource(amount, resource);
  }

  void sellResource(int amount, String resource) {
    _logger.t("sellResource: $amount $resource");
    _connection.sendSellResource(amount, resource);
  }

  void buyAuction(String auction) {
    _logger.i("buyAuction: $auction");

    busy = true;
    _connection.buyAuction(auction);
  }

  void buyMercenary(int amount) {
    _logger.i("buyMercenary: $amount");

    busy = true;
    _connection.buyMercenary(amount);
  }

  void load() {
    _logger.d("load");

    _undergroundLoaded = _resourceLoaded = _loaded = false;
    _connection.getMarketInfo();
    _connection.getUndergroundMarket();
    _connection.getMercanaryMarket();
  }
}
