import 'package:logger/logger.dart';

class TechnologyData {
  final Logger _logger = Logger();

  late String guid;
  late String name;
  late String description;
  late int level;
  late int cost;

  TechnologyData(dynamic data) {
    guid = data["guid"];
    name = data["name"];
    description = data["description"];
    level = data["level"] as int;
    cost = data["cost"] as int;

    dump();
  }

  void dump() {
    _logger.t("""====================================
GUID: $guid
Name: $name
Description: $description
Level: $level
Cost: $cost    
====================================""");
  }
}
