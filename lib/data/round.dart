import 'package:logger/logger.dart';

class RoundData {
  final Logger _logger = Logger(level: Level.trace);

  late String title;
  late String guid;
  late int energyMax;
  late int energyRegen;
  late int energyTick;
  late DateTime nextTick;
  late DateTime starts;
  late DateTime ends;
  late bool finished;

  RoundData(dynamic data) {
    guid = data["guid"] ?? "";

    title = data["title"] ?? "Standard";

    energyMax = int.tryParse(data["energy_max"].toString()) ?? 0;
    energyRegen = int.tryParse(data["energy_regen"].toString()) ?? 0;
    energyTick = int.tryParse(data["tick"].toString()) ?? 0;

    starts = DateTime.tryParse(data["starts"] ?? "") ?? DateTime.now();
    ends = DateTime.tryParse(data["ends"]) ?? DateTime.now();
    nextTick = ends;
    finished = DateTime.now().compareTo(ends) < 0;
  }

  void dump() {
    _logger.t("====================================");
    _logger.t("GUID: $guid");
    _logger.t("Energy Max: $energyMax");
    _logger.t("Energy Regen: $energyRegen");
    _logger.t("Energy Tick: $energyTick");
    _logger.t("Next Tick: $nextTick");
    _logger.t("Ends: $ends");
    _logger.t("Finished: $finished");
    _logger.t("====================================");
  }
}
