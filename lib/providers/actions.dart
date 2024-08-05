import 'package:client/connection.dart';
import 'package:client/data/building.dart';
import 'package:client/data/explore_result.dart';
import 'package:client/data/gather_result.dart';
import 'package:client/data/unit.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/notification.dart';
import 'package:client/providers/player.dart';
import 'package:client/settings.dart';

import 'package:eventify/eventify.dart';
import 'package:logger/logger.dart';

class ActionProvider extends EventEmitter {
  static final ActionProvider _instance = ActionProvider._internal();

  factory ActionProvider() {
    return _instance;
  }

  final Logger _logger = Logger( level: Logger.level );

  final Connection _connection = Connection();
  final NotificationProvider _notification = NotificationProvider();
  final PlayerProvider _player = PlayerProvider();

  final List<ExploreResult> _explores = <ExploreResult>[];
  List<ExploreResult> get exploreResults => _explores;

  final List<GatherResult> _gathers = <GatherResult>[];
  List<GatherResult> get gatherResults => _gathers;

  String? _resource;
  String? get resource => _resource;
  set resource( val ) => _resource = val;

  Unit? _unit;
  Unit? get unit => _unit;
  set unit( val ) => _unit = val;

  Building? _building;
  Building? get building => _building;
  set building( val ) => _building = val;

  ActionProvider._internal() {
    _logger.d( 'Created' );

    _connection.on( "EXPLORE_SUCCESS", null, onExploreSuccess );
    _connection.on( "GATHER_SUCCESS", null, onGatherSuccess );
    _connection.on( "RECRUIT_SUCCESS", null, onRecruitSuccess );
    _connection.on( "BUILD_SUCCESS", null, onBuildSuccess );    
    _connection.on( "ERROR_BUILD", null, onError );
    _connection.on( "ERROR_RECRUIT", null, onError );
    _connection.on( "ERROR_EXPLORE", null, onError );
    _connection.on( "ERROR_GATHER", null, onError );
  }

  void onError( e, o ) {
    _logger.d( "onError" );
    _player.busy = false;
  }

  void onExploreSuccess( e, o ) {
    _logger.d( "onExploreSuccess" );

    _player.busy = false;
    var data = e.eventData as dynamic;
    data = _connection.decodePayload( data[ "data" ] );

    for( var key in data[ "gains" ].keys ) {
      if( key == "land" ) {
        _explores.insert( 0, ExploreResult(gain: data[ "gains" ][ "land" ], energy: data[ "spent" ][ "energy" ] ) );
        while( _explores.length > Settings.maxResults ) {
          _explores.removeLast();
        }
      } else {
        // TO DO
        _logger.e( "NYI - HANDLE FINDING OTHER THAN LAND" );
      }
    }
    emit( "EXPLORE_RESULTS" );
  }

  void onGatherSuccess( e, o ) {
    _logger.d( "onGatherSuccess" );

    _player.busy = false;
    var data = e.eventData as dynamic;
    data = _connection.decodePayload( data[ "data" ] );    

    for( var key in data[ "gains" ].keys ) {
      _gathers.insert( 0, GatherResult(
        gain: data[ "gains" ][ key ] is int ? data[ "gains" ][ key ] : ( data[ "gains" ][ key ] as double ).floor(),
        type: key,
        energy: data[ "spent" ][ "energy" ])
      );

      while( _gathers.length > Settings.maxResults ) {
        _gathers.removeLast();
      }
    }
    emit( "GATHER_RESULTS" );
  }

  void onBuildSuccess( e, o ) {
    _logger.f( "onBuildSuccess" );

    _player.busy = false;

    var data = e.eventData as dynamic;
    _logger.t( data );

    emit( "BUILD_SUCCESS" );
  }

  void onRecruitSuccess( e, o ) {
    _logger.d( "onRecruitSuccess" );

    _player.busy = false;

    var data = e.eventData as dynamic;
    _logger.t( data );

    emit( "RECRUIT_SUCCESS" );
  }

  void explore( { required int energy } ) {
    if( _player.busy ) return;
    _player.busy = true;

    _logger.i( "explore: $energy" );
    _connection.sendExplore( energy: energy );
  }

  void gather( { required int energy } ) {
    if( _player.busy ) return;
    _player.busy = true;

    _logger.i( "gather: $energy" );

    if( _resource == null ) {
      _player.busy = false;
      _logger.e( "Missing Resource" );
      _notification.notifyError( Dictionary.errors[ "NO_RESOURCE_SELECTED"] );
    } else {
      _connection.sendGather( energy: energy, resource: _resource ?? "" );
    }
  }

  void recruit( { required int energy } ) {
    _logger.w( "in Recruit: ${_player.busy ? "busy" : "not busy" }" );

    if( _player.busy ) return;
    _player.busy = true;

    if( _unit == null ) {
      _player.busy = false;
      _logger.e( "Missing Unit" );
      _notification.notifyError( Dictionary.errors[ "MISSING_UNIT"] );
    } else {
      _logger.i( "recruit: $energy - ${_unit?.guid ?? "--"}" );
      _connection.sendRecruit(energy: energy, unit: _unit?.guid.toString() ?? "" );
    }
  }

   void build( { required int energy } ) {
    _logger.w( "in Build: ${_player.busy ? "busy" : "not busy" }" );

    if( _player.busy ) return;
    _player.busy = true;

    if( _building == null ) {
      _player.busy = false;
      _logger.e( "Missing Building" );
      _notification.notifyError( Dictionary.errors[ "MISSING_BUILDING"] );
    } else {
      _logger.i( "build: $energy - ${_building?.guid ?? "--"}" );
      _connection.sendBuild(energy: energy, building: _building?.guid.toString() ?? "" );
    }
  }
}