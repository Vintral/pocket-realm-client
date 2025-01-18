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

  List<dynamic> _auctions = [];
  List<dynamic> get auctions => _auctions;

  bool _loaded = false;
  bool get loaded => _loaded;
  set loaded(value) {
    if (!_loaded && value) {
      emit("LOADED");
    }

    _loaded = value;
  }

  MarketProvider._internal() {
    _logger.d("Created");

    _connection.on("ERROR", null, onError);
    _connection.on("UNDERGROUND_MARKET", null, onUndergroundMarket);
    _connection.on("MARKET_INFO", null, onMarketInfo);
    _connection.on("MARKET_SOLD", null, onMarketSold);
    _connection.on("MARKET_BOUGHT", null, onMarketBought);
    _connection.on("BUY_AUCTION_RESULT", null, onBuyAuctionResult);
  }

  void onError(Event ev, Object? context) {
    _logger.d("onError");

    emit("ERROR");
  }

  void onBuyAuctionResult(ev, o) {
    _logger.w("onBuyAuctionResult");

    busy = false;
    _connection.getUndergroundMarket();
  }

  void onMarketSold(e, o) {
    _logger.t("onMarketSold");
    emit("SUCCESS");
  }

  void onMarketBought(e, o) {
    _logger.t("onMarketBought");
    emit("SUCCESS");
  }

  void onUndergroundMarket(ev, o) {
    _logger.w("onUndergroundMarket");

    _undergroundLoaded = true;
    loaded = _resourceLoaded && _undergroundLoaded;

    var data = ev.eventData as dynamic;
    _auctions = data["auctions"];

    _logger.d(_auctions);

    for (var auction in _auctions) {
      _logger.w(auction);
      _logger.w(_library.getItem(auction["item"]));
    }
  }

  void onMarketInfo(Event ev, Object? context) {
    _logger.d("onMarketInfo");

    _resourceLoaded = true;
    loaded = _resourceLoaded && _undergroundLoaded;

    var data = ev.eventData as dynamic;
    _logger.d(data);

    data = _connection.decodePayload(data["resources"]);
    for (var resource in data) {
      _library.getResource(resource["resource"])?.value =
          double.tryParse(resource["value"].toString());
    }

    _logger.d(_library.resources);
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

  void load() {
    _logger.d("load");

    _undergroundLoaded = _resourceLoaded = _loaded = false;
    _connection.getMarketInfo();
    _connection.getUndergroundMarket();
  }
}
