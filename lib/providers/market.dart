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
  }

  void onError(Event ev, Object? context) {
    _logger.d("onError");

    emit("ERROR");
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

  void load() {
    _logger.d("load");
    _connection.getMarketInfo();
  }
}
