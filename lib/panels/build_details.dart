import 'package:client/components/button.dart';
import 'package:client/components/panel.dart';
import 'package:client/connection.dart';
import 'package:client/data/building.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/actions.dart';
import 'package:eventify/eventify.dart' as eventify;
import 'package:client/providers/notification.dart';
import 'package:client/providers/player.dart';
import 'package:client/providers/theme.dart';
import 'package:client/settings.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class BuildDetailsPanel extends StatefulWidget {
  const BuildDetailsPanel({super.key});

  @override
  State<BuildDetailsPanel> createState() => _BuildDetailsPanelState();
}

class _BuildDetailsPanelState extends State<BuildDetailsPanel> {
  final Connection connection = Connection();
  final Logger _logger = Logger( level: Logger.level );
  final NotificationProvider _notification = NotificationProvider();
  final ActionProvider _provider = ActionProvider();
  final PlayerProvider _player = PlayerProvider();
  final ThemeProvider _theme = ThemeProvider();

  eventify.Listener? _onBuiltSuccessListener;  
  
  late Building _building;

  @override
  void initState() {    
    super.initState();

    _onBuiltSuccessListener = _provider.on( "BUILD_SUCCESS", null, onBuildSuccess );
  }

  @override
  void dispose() {
    _onBuiltSuccessListener?.cancel();

    super.dispose();
  }

  void onBuildSuccess( e, o ) {
    _notification.notifySuccess("Built");
    Navigator.pop( context );
  }

  Text buildHeader( String headerText ) {
    return Text(
      headerText,
      style: _theme.headerStatStyle
    );
  }

  Widget buildStat( String val, String? icon) {
    List<Widget> children = <Widget>[];

    children.add( Text( val, style: _theme.headerStatStyle, ) );
    if( icon != null ) children.add( Image.asset( "assets/icons/$icon.png", width: MediaQuery.of( context ).size.width / 32, ) );

    return SizedBox(
      width: MediaQuery.of( context ).size.width / 7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }

  List<Widget> getCosts() {
    List<Widget> ret = <Widget>[];

    List<Widget> children = <Widget>[];
    if( _building.costPoints > 0 ) children.add( buildStat( _building.costPoints.toString(), "energy" ) );
    if( _building.costGold > 0 ) children.add( buildStat( _building.costGold.toString(), "gold" ) );
    if( _building.costFood > 0 ) children.add( buildStat( _building.costFood.toString(), "food" ) );
    if( _building.costWood > 0 ) children.add( buildStat( _building.costWood.toString(), "wood" ) );
    if( _building.costStone > 0 ) children.add( buildStat( _building.costStone.toString(), "stone" ) );
    if( _building.costMetal > 0 ) children.add( buildStat( _building.costMetal.toString(), "metal" ) );
    if( _building.costFaith > 0 ) children.add( buildStat( _building.costFaith.toString(), "faith" ) );
    if( _building.costMana > 0 ) children.add( buildStat( _building.costMana.toString(), "mana" ) );

    ret.add( buildHeader( "Cost" ) );    
    ret.add( Wrap(
      children: children,    
    ) );    

    return ret;
  }

  List<Widget> getUpkeeps() {
    List<Widget> ret = <Widget>[];

    List<Widget> children = <Widget>[];    
    if( _building.upkeepGold > 0 ) children.add( buildStat( _building.upkeepGold.toString(), "gold" ) );
    if( _building.upkeepFood > 0 ) children.add( buildStat( _building.upkeepFood.toString(), "food" ) );
    if( _building.upkeepWood > 0 ) children.add( buildStat( _building.upkeepWood.toString(), "wood" ) );
    if( _building.upkeepStone > 0 ) children.add( buildStat( _building.upkeepStone.toString(), "stone" ) );
    if( _building.upkeepMetal > 0 ) children.add( buildStat( _building.upkeepMetal.toString(), "metal" ) );
    if( _building.upkeepFaith > 0 ) children.add( buildStat( _building.upkeepFaith.toString(), "faith" ) );
    if( _building.upkeepMana > 0 ) children.add( buildStat( _building.upkeepMana.toString(), "mana" ) );

    if( children.isEmpty ) {
      //children.add( Text( "---", style: _theme.resultStyle ) );
      return [];
    }

    ret.add( buildHeader( "Upkeep" ) );    
    ret.add( Wrap(
      children: children,    
    ) );

    return ret;
  }

  List<Widget> getStats() {
    List<Widget> ret = <Widget>[];

    if( _provider.building == null ) return ret;
    _building = _provider.building as Building;
    
    ret.add( buildHeader( "Stats" ) );
    ret.add( Wrap(
      children: [
        buildStat( _building.bonusValue.toString(), "energy" ),        
      ],    
    ) );

    return ret;
  }

  List<Widget> getDetails() {
    return [
      ...getStats(),
      ...getCosts(),
      ...getUpkeeps(),
    ];
  }

  bool isEnabled( int energy ) {
    _logger.i( "isEnabled: $energy" );

    _logger.d( "Build Power: ${_player.buildPower}" );
    var buildings = ( _player.buildPower * energy ) / _building.costPoints;
    _logger.w( "Buildings: $buildings" );
    if( buildings < 1 && !_building.supportPartial ) return false;

    return canAfford( energy );
  }

  bool canAfford( int energy ) {    
    _logger.d( "canAfford: $energy" );        

    if( _player.energy < energy ) return false;

    var buildings = ( _player.buildPower * energy ) / _building.costPoints;
    _logger.d( "Buildings For Energy: $buildings");

    _player.dump();

    _logger.d( "Player Wood: ${_player.wood}" );
    _logger.d( "Required Wood: ${buildings * _building.costWood}" );

    if( _player.wood < buildings * _building.costWood ) return false;
    if( _player.gold < buildings * _building.costGold ) return false;
    if( _player.food < buildings * _building.costFood ) return false;
    if( _player.stone < buildings * _building.costStone ) return false;
    if( _player.metal < buildings * _building.costMetal ) return false;
    if( _player.faith < buildings * _building.costFaith ) return false;
    if( _player.mana < buildings * _building.costMana ) return false;

    _logger.d("returning true from canAfford" );
    return true;    
  }

  void onTap( { required int energy } ) {
    _logger.i( "onTap: $energy" );    

    if( canAfford( energy ) ) {
      _provider.build( energy: energy );      
    } else {
      if( _player.energy < energy ) {
        _notification.notifyError( Dictionary.errors[ "NOT_ENOUGH_ENERGY" ] );
      }  else {
        _notification.notifyError( Dictionary.errors[ "CANT_AFFORD" ] );
      }
      _player.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Panel(
      label: Dictionary.get( "BUILD" ),
      closable: true,
      child: SizedBox(
        width: MediaQuery.of( context ).size.width,
        child: Column(
          children: [
            Container(         
              color: _theme.colorBackground,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Expanded(
                        child: Container(
                          color: _theme.colorBackground,
                          child: Image.asset("assets/buildings/${_provider.building?.name ?? "none"}.png", fit: BoxFit.cover, ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all( Settings.horizontalGap ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: getDetails(),
                          ),
                        ),
                      ), 
                    ]
                  ),
                  Padding(                    
                    padding: EdgeInsets.all( Settings.gap ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Button(
                            text: "1", 
                            handler: () => onTap( energy: 1 ), 
                            image: "assets/icons/energy.png",
                            enabled: isEnabled( 1 ),
                          ),
                        ),
                        SizedBox(width: Settings.gap,),
                        Expanded(
                          child: Button(
                            text: "5", 
                            handler: () => onTap( energy: 5 ), 
                            image: "assets/icons/energy.png",                             
                            enabled: isEnabled( 5 ),
                          ),
                        ),
                        SizedBox(width: Settings.gap,),
                        Expanded(
                          child: Button(
                            text: "25", 
                            handler: () => onTap( energy: 25 ), 
                            image: "assets/icons/energy.png",
                            enabled: isEnabled( 25 ),                             
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),      
    );
  }
}