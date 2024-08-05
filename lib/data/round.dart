import 'package:logger/logger.dart';

class RoundData {
  final Logger _logger = Logger(level: Logger.level);

  late String guid;
  late int energyMax;
  late int energyRegen;
  late int energyTick;
  late DateTime nextTick;
  late DateTime ends;

  RoundData(dynamic data) {
    guid = data["guid"] ?? "";

    energyMax = int.parse(data["energy_max"] ?? "0");
    energyRegen = int.parse(data["energy_regen"] ?? "0");
    energyTick = int.parse(data["tick"] ?? "0");

    nextTick = DateTime.parse(data["posted"] ?? "");
    ends = DateTime.parse(data["posted"] ?? "");

    dump();
  }

  void dump() {
    _logger.t("====================================");
    _logger.t("GUID: $guid");
    _logger.t("Energy Max: $energyMax");
    _logger.t("Energy Regen: $energyRegen");
    _logger.t("Energy Tick: $energyTick");
    _logger.t("Next Tick: $nextTick");
    _logger.t("Ends: $ends");
    _logger.t("====================================");
  }
}
