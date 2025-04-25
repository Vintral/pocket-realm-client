import 'package:client/data/devotion.dart';
import 'package:logger/logger.dart';

class PantheonData {
  final Logger _logger = Logger();

  late String guid;
  late String name;
  late List<DevotionData> devotions;

  PantheonData(dynamic data) {
    guid = data["guid"];
    name = data["category"];

    devotions = <DevotionData>[];
    for (int i = 0; i < (data["devotions"] as List<dynamic>).length; i++) {
      devotions.add(DevotionData(data["devotions"][i], this));
    }

    dump();
  }

  void dump({force = false}) {
    var devotionDump = "";
    for (int i = 0; i < devotions.length; i++) {
      devotionDump += devotions[i].dump();
    }

    var log = force ? _logger.w : _logger.t;
    log("""============PantheonData============
GUID: $guid
Name: $name
$devotionDump
====================================""");
  }
}
