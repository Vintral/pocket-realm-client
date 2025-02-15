import 'package:client/data/realm_object.dart';
import 'package:logger/logger.dart';

class Unit extends RealmObject {
  final Logger _logger = Logger();

  late int attack;
  late int defense;
  late int power;
  late int health;
  late bool ranged;
  late int costPoints;
  late int costGold;
  late int costFood;
  late int costStone;
  late int costWood;
  late int costMetal;
  late int costMana;
  late int costFaith;
  late int upkeepGold;
  late int upkeepFood;
  late int upkeepWood;
  late int upkeepMetal;
  late int upkeepFaith;
  late int upkeepStone;
  late int upkeepMana;
  late bool available;
  late bool recruitable;
  late bool supportPartial;

  Unit(dynamic data) : super(data) {
    _logger.t("Created");

    folder = "units";

    attack = data["attack"];
    defense = data["defense"];
    power = data["power"];
    health = data["health"];
    ranged = data["ranged"];

    costPoints = data["cost_points"];
    costGold = data["cost_gold"];
    costFood = data["cost_food"];
    costWood = data["cost_wood"];
    costStone = data["cost_stone"];
    costMetal = data["cost_metal"];
    costMana = data["cost_mana"];
    costFaith = data["cost_faith"];

    upkeepGold = data["upkeep_gold"];
    upkeepFood = data["upkeep_food"];
    upkeepWood = data["upkeep_wood"];
    upkeepMetal = data["upkeep_metal"];
    upkeepFaith = data["upkeep_faith"];
    upkeepStone = data["upkeep_stone"];
    upkeepMana = data["upkeep_mana"];

    available = data["available"];
    recruitable = data["recruitable"];
    supportPartial = data["supports_partial"];
  }

  @override
  void dump() {
    super.dump();

    var logger = Logger(level: Level.trace);
    logger.t("""
Name: $name
Attack: $attack
Defense: $defense
Power: $power
Health: $health
Ranged: ${ranged ? "Yes" : "No"}
Cost Points: $costPoints
Cost Gold: $costGold
Cost Food: $costFood
Cost Wood: $costWood
Cost Stone: $costStone
Cost Metal: $costMetal
Cost Mana: $costMana
Cost Faith: $costFaith
Upkeep Gold: $upkeepGold
Upkeep Food: $upkeepFood
Upkeep Wood: $upkeepWood
Upkeep Metal: $upkeepMetal
Upkeep Faith: $upkeepFaith
Upkeep Stone: $upkeepStone
Upkeep Mana: $upkeepMana
Available: ${available ? "Yes" : "No"}
Recruitable: ${recruitable ? "Yes" : "No"}
    """);

    dumpBorder();
  }
}
