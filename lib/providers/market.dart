import 'dart:collection';

import 'package:client/data/message.dart';
import 'package:eventify/eventify.dart';
import 'package:logger/logger.dart';

import 'package:client/connection.dart';
import 'package:client/data/conversation.dart';
import 'package:client/data/shout.dart';
import 'package:client/settings.dart';

class MarketProvider extends EventEmitter {
  static final MarketProvider _instance = MarketProvider._internal();

  factory MarketProvider() {
    return _instance;
  }

  final Logger _logger = Logger(level: Level.info);
  final Connection _connection = Connection();

  bool _busy = false;
  bool get busy => _busy;
  set busy(value) => _busy = value;

  MarketProvider._internal() {
    _logger.d("Created");

    _connection.on("ERROR", null, onError);
    _connection.on("MARKET_INFO", null, onMarketInfo);
  }

  void onError(Event ev, Object? context) {
    _logger.d("onError");
  }

  void onMarketInfo(Event ev, Object? context) {
    _logger.d("onMarketInfo");
  }

  void refresh() {
    _connection.getMarketInfo();
  }
}
