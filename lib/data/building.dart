import 'package:client/data/realm_object.dart';
import 'package:logger/logger.dart';

class Building extends RealmObject {
  final Logger _logger = Logger();
  
  late int costPoints;
  late int costWood;
  late int costStone;  
  late int costGold;
  late int costMetal;
  late int costFood;
  late int costMana;
  late int costFaith;
  late int upkeepGold;
  late int upkeepFood;
  late int upkeepWood;
  late int upkeepMetal;
  late int upkeepFaith;
  late int upkeepStone;
  late int upkeepMana;
  late String bonusField;
  late int bonusValue;
  late bool buildable;
  late bool available;
  late bool supportPartial;

  Building( dynamic data ) : super( data ) {    
    folder = "buildings";

    costPoints = data[ "cost_points" ];
    costWood = data[ "cost_wood" ];
    costStone = data[ "cost_stone" ];    
    costFood = data[ "cost_food" ];
    costGold = data[ "cost_gold" ];
    costMetal = data[ "cost_metal" ];
    costFaith = data[ "cost_faith" ];
    costMana = data[ "cost_mana" ];

    upkeepGold = data[ "upkeep_gold" ];
    upkeepFood = data[ "upkeep_food" ];
    upkeepWood = data[ "upkeep_wood" ];
    upkeepMetal = data[ "upkeep_metal" ];
    upkeepFaith = data[ "upkeep_faith" ];
    upkeepStone = data[ "upkeep_stone" ];
    upkeepMana = data["upkeep_mana" ];

    bonusField = data[ "bonus_field" ];
    bonusValue = data[ "bonus_value" ];

    available = data[ "available" ];
    buildable = data[ "buildable" ];
    supportPartial = data[ "supports_partial" ];

    dump();    
  }

  @override
  void dump() {    
    super.dump();

    _logger.t( "CostPoints: $costPoints" );
    _logger.t( "CostWood: $costWood" );    
    _logger.t( "CostStone: $costStone" );    
    _logger.t( "CostGold: $costGold" );    
    _logger.t( "CostFood: $costFood" );
    _logger.t( "CostMetal: $costMetal" );    
    _logger.t( "CostFaith: $costFaith" );
    _logger.t( "CostMana: $costMana" );
    _logger.t( "BonusField: $bonusField" );
    _logger.t( "BonusValue: $bonusValue" );
    _logger.t( "Available: ${available ? "Yes" : "No"}" );

    dumpBorder();
  }
}