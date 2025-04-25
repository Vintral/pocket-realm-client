import 'package:client/capitalize.dart';
import 'package:client/data/pantheon.dart';
import 'package:client/dictionary.dart';
import 'package:logger/logger.dart';

class DevotionData {
  final Logger _logger = Logger();

  late int level;
  late int upkeep;
  late String buff;
  late List<String> effect;
  late PantheonData pantheon;

  DevotionData(dynamic data, PantheonData pantheonName) {
    level = data["level"] as int;
    upkeep = data["upkeep"] as int;
    buff = data["buff"];
    effect = parseEffect(data["effect"] as String);
    pantheon = pantheonName;

    dump();
  }

  List<String> parseEffect(String effects) {
    List<String> ret = [];

    for (var effect in effects.split("|")) {
      var data = effect.split(",");
      ret.add(
          "${data[0]} ${Dictionary.get(data[1].toUpperCase()).capitalize()}");
    }

    return ret;
  }

  String dump({force = false}) {
    return """------------------------------------    
Level: $level
Upkeep: $upkeep
Buff: $buff
Effect: ${effect.join(", ")}
------------------------------------\n""";
  }
}
