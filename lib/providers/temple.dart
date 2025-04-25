import 'package:client/data/devotion.dart';
import 'package:client/data/pantheon.dart';
import 'package:client/data/unit.dart';
import 'package:client/providers/library.dart';
import 'package:client/providers/player.dart';
import 'package:eventify/eventify.dart';
import 'package:logger/logger.dart';

import 'package:client/connection.dart';

class TempleProvider extends EventEmitter {
  static final TempleProvider _instance = TempleProvider._internal();

  factory TempleProvider() {
    return _instance;
  }

  final Logger _logger = Logger();
  final Connection _connection = Connection();
  final _player = PlayerProvider();

  bool _busy = false;
  bool get busy => _busy;
  set busy(value) {
    if (_busy != value) {
      emit("BUSY_CHANGED");
    }

    _busy = value;
  }

  bool _loaded = false;
  bool get loaded => _loaded;
  set loaded(value) {
    if (!_loaded && value) {
      _logger.t("Emit: LOADED");
      emit("LOADED");
    }

    _loaded = value;
  }

  PantheonData? get pantheon {
    if (pantheons.isEmpty || currentPantheon.isEmpty) return null;
    _logger.w("Pantheon length: ${pantheons.length}");
    _logger.w("Pantheon: $currentPantheon");
    return pantheons.firstWhere((current) => current.name == currentPantheon);
  }

  var activeTab = "";
  var currentPantheon = "";
  var currentLevel = 0;
  var pantheons = <PantheonData>[];

  TempleProvider._internal() {
    _logger.d("Created");

    _connection.on("ERROR", null, onError);
    _connection.on("GET_PANTHEONS", null, onPantheons);
    _connection.on("RAISE_DEVOTION", null, onRaiseDevotion);
    _connection.on("RENOUNCE_DEVOTION", null, onRenounceDevotion);
  }

  void raiseDevotion(PantheonData pantheon) {
    busy = true;
    _connection.sendRaiseDevotion(pantheon.guid);
  }

  void renounceDevotion() {
    busy = true;
    _connection.sendRenounceDevotion();
  }

  void onRaiseDevotion(e, o) {
    _logger.i("onRaiseDevotion");
    var data = e.eventData as dynamic;
    if (data["success"]) {
      currentLevel++;
    } else {
      _logger.e("Failed to raise devotion");
    }

    busy = false;
  }

  void onRenounceDevotion(e, o) {
    _logger.i("onRenounceDevotion");
    var data = e.eventData as dynamic;
    if (data["success"]) {
      _player.lostFaith = DateTime.now().add(Duration(minutes: 5));
      _connection.getPantheons();
    } else {
      _logger.e("Failed to renounce devotion");
      busy = false;
    }
  }

  void onError(Event ev, Object? context) {
    _logger.w("onError");

    emit("ERROR");
  }

  void onPantheons(e, o) {
    _logger.d("onPantheons");

    var data = e.eventData as dynamic;
    currentPantheon = data["current"]["pantheon"];
    currentLevel = data["current"]["level"] as int;

    pantheons.clear();
    for (int i = 0; i < (data["pantheons"] as List<dynamic>).length; i++) {
      var pantheon = PantheonData(data["pantheons"][i]);

      if (pantheon.name == currentPantheon) {
        pantheons.insert(0, pantheon);
      } else {
        pantheons.add(pantheon);
      }
    }

    activeTab = pantheons[0].name.toLowerCase();

    loaded = true;
    busy = false;
  }

  void clearBusy() {
    _logger.t("clearBusy");
    busy = false;
  }

  void load() {
    _logger.d("load");

    _loaded = false;
    busy = true;
    _connection.getPantheons();
  }
}
