import 'package:client/connection.dart';
import 'package:client/data/user_building.dart';
import 'package:client/data/user_unit.dart';
import 'package:client/providers/library.dart';
import 'package:client/utilities.dart';
import 'package:eventify/eventify.dart' as eventify;
import 'package:logger/logger.dart';

import '../data/event.dart';

class PlayerProvider extends eventify.EventEmitter {
  static final PlayerProvider _instance = PlayerProvider._internal();

  factory PlayerProvider() {
    return _instance;
  }

  final Logger _logger = Logger();
  final Connection _connection = Connection();

  final LibraryProvider _library = LibraryProvider();

  List<EventData> events = <EventData>[];
  bool _eventsRetrieved = false;

  bool loaded = false;

  bool _busy = false;
  bool get busy => _busy;
  set busy(value) => _busy = value;

  int avatar = 0;

  String username = "";
  String round = "";
  String characterClass = "";
  int roundId = 0;
  String guid = "";
  int energy = 0;
  int defense = 0;
  int land = 0;
  int landFree = 0;
  int housing = 0;
  int population = 0;
  int wood = 0;
  int tickWood = 0;
  int food = 0;
  int tickFood = 0;
  int gold = 0;
  int tickGold = 0;
  int stone = 0;
  int tickStone = 0;
  int metal = 0;
  int tickMetal = 0;
  int mana = 0;
  int tickMana = 0;
  int faith = 0;
  int tickFaith = 0;
  int buildPower = 0;
  int recruitPower = 0;

  List<UserUnit> units = <UserUnit>[];
  List<UserBuilding> buildings = <UserBuilding>[];

  PlayerProvider._internal() {
    _logger.d('Created');

    _connection.on("USER_DATA", null, onUserData);
    _connection.on("EXPLORE_SUCCESS", null, onUpdated);
    _connection.on("GATHER_SUCCESS", null, onUpdated);
    _connection.on("RECRUIT_SUCCESS", null, onUpdated);
    _connection.on("BUILD_SUCCESS", null, onUpdated);
    _connection.on("EVENT", null, onEvent);
    _connection.on("EVENTS", null, onEvents);
    _connection.on("PLAYER_UPDATE", null, onUpdated);

    // Timer(
    //   const Duration(seconds: 3),
    //   () {
    //     _logger.w( "TICK" );

    //     onEvent( jsonDecode( jsonEncode( { "eventData": { "event": { "guid": "213789-238910-123789123", "time": "2024-07-13", "event": "Testing incoming event", "round": "5e4d1639-287a-46c8-9cfc-ade29a62ae84", "seen": false } } } ) ), null );
    //   }
    // );
  }

  void refresh() {
    _logger.i("refresh");
    _connection.sendGetSelf();
  }

  void getEvents(int page) {
    _logger.i("getEvents");
    _connection.getEvents(page);
  }

  void onUpdated(ev, obj) {
    _logger.d("onUpdated");

    var data = ev.eventData as dynamic;

    if (data["user"] != null) {
      updateUser(data["user"]);
    } else {
      _logger.w("onUpdated: User data missing");
    }
  }

  void onEvent(ev, obj) {
    _logger.i("onEvent");

    if (!_eventsRetrieved || ev["eventData"]["event"]["round"] != round) return;

    events.insert(0, EventData(ev["eventData"]["event"]));
    _logger.w("PLAYER ROUND: $round");

    emit("EVENT");
  }

  void onEvents(ev, obj) {
    _logger.i("onEvents");

    _logger.w((ev.eventData as dynamic)["events"]);

    events.addAll(((ev.eventData as dynamic)["events"] as List<dynamic>)
        .map((data) => EventData(data)));

    _eventsRetrieved = true;

    emit("EVENTS");
  }

  void onUserData(ev, obj) {
    _logger.i("onGetUser");

    onUpdated(ev, obj);

    if (!loaded) {
      loaded = true;
      emit("USER_LOADED");
    }
  }

  void updateUser(dynamic data) {
    _logger.t("updateUser: $data");

    for (var key in data.keys) {
      switch (key) {
        case "username":
          username = data[key];
        case "avatar":
          avatar = getIntVal(data[key]);
        case "class":
          characterClass = data[key];
        case "character_class":
          characterClass = data[key];
        case "guid":
          guid = data[key];
        case "round_playing":
          round = data[key];
        case "round_id":
          roundId = getIntVal(data[key]);
        case "energy":
          energy = getIntVal(data[key]);
        case "population":
          population = getIntVal(data[key]);
        case "housing":
          population = getIntVal(data[key]);
        case "land":
          land = getIntVal(data[key]);
        case "free_land":
          landFree = getIntVal(data[key]);
        case "gold":
          gold = getIntVal(data[key]);
        case "tick_gold":
          tickGold = getIntVal(data[key]);
        case "food":
          food = getIntVal(data[key]);
        case "tick_food":
          tickFood = getIntVal(data[key]);
        case "wood":
          wood = getIntVal(data[key]);
        case "tick_wood":
          tickWood = getIntVal(data[key]);
        case "metal":
          metal = getIntVal(data[key]);
        case "tick_metal":
          tickMetal = getIntVal(data[key]);
        case "defense":
          defense = getIntVal(data[key]);
        case "stone":
          stone = getIntVal(data[key]);
        case "tick_stone":
          tickStone = getIntVal(data[key]);
        case "faith":
          faith = getIntVal(data[key]);
        case "tick_faith":
          tickFaith = getIntVal(data[key]);
        case "mana":
          mana = getIntVal(data[key]);
        case "tick_mana":
          tickMana = getIntVal(data[key]);
        case "build_power":
          buildPower = getIntVal(data[key]);
        case "recruit_power":
          recruitPower = getIntVal(data[key]);
        case "round":
          updateUser(data[key]);
        case "units":
          updateUnits(data[key]);
        case "buildings":
          updateBuildings(data[key]);
        case "items":
          _logger.w("NYI - Processing Items");
        default:
          _logger.e("Unhandled Key in updateUser: $key");
      }
    }

    emit("UPDATED");
  }

  void updateUnits(dynamic unitData) {
    if (!_library.loaded) return;

    units.clear();

    _logger.d(unitData);
    _logger.d("Length: ${unitData.length}");
    if (unitData.length > 0) {
      for (dynamic unit in unitData) {
        units.add(UserUnit(
          unit: _library.getUnit(unit["guid"]),
          quantity: unit["quantity"] is int
              ? (unit["quantity"] as int).toDouble()
              : unit["quantity"],
        ));
      }
    }
  }

  void updateBuildings(dynamic buildingData) {
    if (!_library.loaded) return;

    buildings.clear();

    _logger.d(buildingData);
    _logger.d("Length: ${buildingData.length}");
    if (buildingData.length > 0) {
      for (dynamic building in buildingData) {
        buildings.add(UserBuilding(
          building: _library.getBuilding(building["guid"]),
          quantity: building["quantity"] is int
              ? (building["quantity"] as int).toDouble()
              : building["quantity"],
        ));
      }
    }
  }

  void markEventsSeen() {
    _logger.w("markEventsSeen");

    for (var event in events) {
      event.seen = true;
    }
  }

  void dump() {
    _logger.t("==================================");
    _logger.t("Busy: ${_busy ? "Yes" : "No"}");
    _logger.t("Energy: $energy");
    _logger.t("Land: $land");
    _logger.t("LandFree: $landFree");
    _logger.t("Wood: $wood");
    _logger.t("Food: $food");
    _logger.t("Gold: $gold");
    _logger.t("Stone: $stone");
    _logger.t("Metal: $metal");
    _logger.t("Mana: $mana");
    _logger.t("Faith: $faith");
    _logger.t("Build Power: $buildPower");
    _logger.t("Recruit Power: $recruitPower");
    _logger.t("==================================");
  }
}
