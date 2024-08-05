import 'package:logger/logger.dart';

class EventData {
  final Logger _logger = Logger( level: Level.trace );
  
  late String round;
  late String message;
  late String guid;
  late bool seen;
  late DateTime time;
  
  EventData( dynamic data ) {  
    time = DateTime.parse( data[ "time" ] );
    message = data[ "event" ] ?? "";
    round = data[ "round" ] ?? "";
    seen = data[ "seen" ] ?? "";    
    guid = data[ "guid" ] ?? "";

    dump();    
  }

  void dump() {    
    _logger.t( "====================================" );
    _logger.t( "GUID: $guid" );
    _logger.t( "Message: $message" );
    _logger.t( "Round: $round" );
    _logger.t( "Seen: $seen" );        
    _logger.t( "time: $time" );
    _logger.t( "====================================" );
  }
}