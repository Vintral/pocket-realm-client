import 'package:client/providers/library.dart';
import 'package:eventify/eventify.dart';
import 'package:logger/logger.dart';

import 'package:client/connection.dart';

class MarketProvider extends EventEmitter {
  static final MarketProvider _instance = MarketProvider._internal();

  factory MarketProvider() {
    return _instance;
  }

  final Logger _logger = Logger(level: Level.debug);
  final _library = LibraryProvider();
  final Connection _connection = Connection();

  bool _busy = false;
  bool get busy => _busy;
  set busy(value) => _busy = value;

  bool _loaded = false;
  bool get loaded => _loaded;

  MarketProvider._internal() {
    _logger.d("Created");

    _connection.on("ERROR", null, onError);
    _connection.on("MARKET_INFO", null, onMarketInfo);
    _connection.on("MARKET_SOLD", null, onMarketSold);
    _connection.on("MARKET_BOUGHT", null, onMarketBought);
  }

  void onError(Event ev, Object? context) {
    _logger.d("onError");

    emit("ERROR");
  }

  void onMarketSold(e, o) {
    _logger.t("onMarketSold");
    emit("SUCCESS");
  }

  void onMarketBought(e, o) {
    _logger.t("onMarketBought");
    emit("SUCCESS");
  }

  void onMarketInfo(Event ev, Object? context) {
    _logger.d("onMarketInfo");

    _loaded = true;
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

  void load() {
    _logger.d("load");
    _connection.getMarketInfo();
  }
}
