import 'package:client/connection.dart';
import 'package:client/data/building.dart';
import 'package:client/data/realm_object.dart';
import 'package:client/data/resource.dart';
import 'package:client/data/unit.dart';
import 'package:eventify/eventify.dart' as eventify;
import 'package:logger/logger.dart';

class LibraryProvider extends eventify.EventEmitter {
  static final LibraryProvider _instance = LibraryProvider._internal();

  factory LibraryProvider() {
    return _instance;
  }

  final Logger _logger = Logger();
  final Connection _connection = Connection();

  bool _loading = false;
  bool _loaded = false;
  bool get loaded => _loaded;

  final Map<String, Resource> _mapResources = <String, Resource>{};
  final List<Resource> _resources = [];
  List<Resource> get resources => _resources;

  Resource? get resourceGold =>
      _resources.firstWhere((resource) => resource.name == "gold");

  final Map<String, Unit> _mapUnits = <String, Unit>{};
  final List<Unit> _units = [];
  List<Unit> get units => _units;

  final Map<String, Building> _mapBuildings = <String, Building>{};
  final List<Building> _buildings = [];
  List<Building> get buildings => _buildings;

  final Map<String, dynamic> _mapItems = <String, dynamic>{};
  final List<dynamic> _items = [];
  List<dynamic> get items => _items;

  LibraryProvider._internal() {
    _logger.d('Created');
    _connection.on("ROUND", null, onRound);
  }

  void load(String round) {
    if (_loading) return;
    _loading = true;
    _loaded = false;

    _logger.d("load");

    emit("LOADING");

    _connection.sendRetrieveLibrary(round: round);
  }

  void onRound(ev, obj) {
    _logger.d("onRound");

    var data = (ev.eventData as dynamic)["round"];
    parseResources(data["resources"]);
    parseBuildings(data["buildings"]);
    parseUnits(data["units"]);
    parseItems((ev.eventData as dynamic)["items"]);

    _loading = false;
    _loaded = true;
    emit("LOADED");
  }

  Resource? getResource(String guid) {
    _logger.d("getResource: $guid");
    return _mapResources[guid];
  }

  Unit? getUnit(String guid) {
    _logger.d("getUnit: $guid");
    return _mapUnits[guid];
  }

  Building? getBuilding(String guid) {
    _logger.d("getBuilding: $guid");
    return _mapBuildings[guid];
  }

  dynamic getItem(String guid) {
    _logger.d("getItem: $guid");
    return _mapItems[guid];
  }

  void sort(List<RealmObject> objects) {
    objects.sort((r1, r2) => r1.order.compareTo(r2.order));
  }

  void parseResources(dynamic resources) {
    _resources.clear();

    for (final r in resources) {
      var resource = Resource(r);
      _resources.add(resource);
      _mapResources[resource.guid] = resource;
    }

    sort(_resources);
  }

  void parseBuildings(dynamic buildings) {
    _buildings.clear();

    if (buildings != null && buildings.length > 0) {
      for (final b in buildings) {
        var building = Building(b);
        _buildings.add(building);
        _mapBuildings[building.guid] = building;
      }
    }

    sort(_buildings);
  }

  void parseUnits(dynamic units) {
    _units.clear();

    if (units != null && units.length > 0) {
      for (final u in units) {
        var unit = Unit(u);
        _units.add(unit);
        _mapUnits[unit.guid] = unit;
      }
    }

    sort(_units);
  }

  void parseItems(dynamic items) {
    _logger.t("parseItems");

    _items.clear();

    if (items != null && items.length > 0) {
      for (final i in items) {
        _items.add(i);
        _mapItems[i["guid"]] = i;
      }
    }
  }
}
