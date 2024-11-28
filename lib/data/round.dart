import 'dart:convert';

import 'package:client/data/ranking.dart';
import 'package:logger/logger.dart';

class RoundData {
  final Logger _logger = Logger();

  late String title;
  late String guid;
  late int energyMax;
  late int energyRegen;
  late int energyTick;
  late int players;
  late bool playing;
  late DateTime nextTick;
  late DateTime starts;
  late DateTime ends;
  late bool finished;
  late List<RankingData>? ranks;

  bool get available =>
      DateTime.now().compareTo(starts) >= 0 &&
      DateTime.now().compareTo(ends) < 0;

  RoundData(dynamic data) {
    guid = data["guid"] ?? "";

    title = data["title"] ?? "Standard";

    energyMax = int.tryParse(data["energy_max"].toString()) ?? 0;
    energyRegen = int.tryParse(data["energy_regen"].toString()) ?? 0;
    energyTick = int.tryParse(data["tick"].toString()) ?? 0;

    starts = DateTime.tryParse(data["starts"] ?? "") ?? DateTime.now();
    ends = DateTime.tryParse(data["ends"]) ?? DateTime.now();
    nextTick = ends;
    finished = DateTime.now().compareTo(ends) > 0;

    ranks = data["top"] != null
        ? (data["top"] as List<dynamic>).map((r) => RankingData(r)).toList()
        : null;

    players = 0;
    playing = false;

    dump();
  }

  void dump() {
    _logger.t("====================================");
    _logger.t("GUID: $guid");
    _logger.t("Energy Max: $energyMax");
    _logger.t("Energy Regen: $energyRegen");
    _logger.t("Energy Tick: $energyTick");
    _logger.t("Next Tick: $nextTick");
    _logger.t("Players: $players");
    _logger.t("Ends: $ends");
    _logger.t("Finished: $finished");
    _logger.t("Playing: ${playing.toString()}");
    _logger.t("Ranks: $ranks");
    _logger.t("====================================");
  }
}
