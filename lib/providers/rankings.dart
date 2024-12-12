import 'package:client/data/ranking.dart';
import 'package:eventify/eventify.dart';
import 'package:logger/logger.dart';

import 'package:client/connection.dart';

class RankingsProvider extends EventEmitter {
  static final RankingsProvider _instance = RankingsProvider._internal();

  factory RankingsProvider() {
    return _instance;
  }

  final Logger _logger = Logger(level: Level.warning);
  final Connection _connection = Connection();

  bool _busy = false;
  bool get busy => _busy;
  set busy(value) => _busy = value;

  final List<RankingData> _top = <RankingData>[];
  List<RankingData> get top => _top;

  final List<RankingData> _near = <RankingData>[];
  List<RankingData> get near => _near;

  RankingsProvider._internal() {
    _logger.d("Created");

    _connection.on("RANKINGS", null, onRankings);
  }

  void onRankings(e, o) {
    _logger.d("onRankings");

    var data = e.eventData;

    _top.addAll((data["top"] as List<dynamic>)
        .map<RankingData>((data) => RankingData(data)));

    _near.addAll((data["near"] as List<dynamic>)
        .map<RankingData>((data) => RankingData(data)));

    emit("RANKINGS");
  }

  void getRankings() {
    _logger.d("getRankings");

    _connection.getRankings();
  }

  void clean() {
    _logger.d("clean");

    _top.clear();
    _near.clear();
  }
}
