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

  Unit( dynamic data ) : super( data ) {    
    folder = "units";

    attack = data[ "attack" ];
    defense = data[ "defense" ];
    power = data[ "power" ];
    health = data[ "health" ];
    ranged = data[ "ranged" ];

    costPoints = data[ "cost_points" ];
    costGold = data[ "cost_gold" ];    
    costFood = data[ "cost_food" ];
    costWood = data[ "cost_wood" ];
    costStone = data[ "cost_stone" ];
    costMetal = data[ "cost_metal" ];
    costMana = data[ "cost_mana" ];
    costFaith = data[ "cost_faith" ];

    upkeepGold = data[ "upkeep_gold" ];
    upkeepFood = data[ "upkeep_food" ];
    upkeepWood = data[ "upkeep_wood" ];
    upkeepMetal = data[ "upkeep_metal" ];
    upkeepFaith = data[ "upkeep_faith" ];
    upkeepStone = data[ "upkeep_stone" ];
    upkeepMana = data["upkeep_mana" ];

    available = data[ "available" ];
    recruitable = data[ "recruitable" ];
    supportPartial = data[ "supports_partial" ];

    dump();    
  }

  @override
  void dump() {    
    super.dump();    

    _logger.t( "Attack: $attack" );
    _logger.t( "Defense: $defense" );    
    _logger.t( "Power: $power" );
    _logger.t( "Health: $health" );
    _logger.t( "Ranged: ${ranged ? "Yes" : "No"}" );
    _logger.t( "Cost Points: $costPoints" );
    _logger.t( "Cost Gold: $costGold" );
    _logger.t( "Cost Food: $costFood" );
    _logger.t( "Cost Wood: $costWood" );
    _logger.t( "Cost Stone: $costStone" );
    _logger.t( "Cost Metal: $costMetal" );
    _logger.t( "Cost Mana: $costMana" );
    _logger.t( "Cost Faith: $costFaith" );
    _logger.t( "Upkeep Gold: $upkeepGold" );
    _logger.t( "Upkeep Food: $upkeepFood" );
    _logger.t( "Upkeep Wood: $upkeepWood" );
    _logger.t( "Upkeep Metal: $upkeepMetal" );
    _logger.t( "Upkeep Faith: $upkeepFaith" );
    _logger.t( "Upkeep Stone: $upkeepStone" );
    _logger.t( "Upkeep Mana: $upkeepMana" );    
    _logger.t( "Available: ${available ? "Yes" : "No"}" );
    _logger.t( "Recruitable: ${recruitable ? "Yes" : "No"}" );

    dumpBorder();
  }
}