import 'package:logger/logger.dart';

class MessageData {
  final Logger _logger = Logger( level: Level.off );
  
  late String guid;
  late String username;  
  late String message;
  late DateTime time;

  MessageData( dynamic data ) {
    guid = data[ "guid" ] ?? "";
    username = data[ "username" ] ?? "";       
    message = data[ "message" ];
    
    time = DateTime.parse( data[ "time" ] ?? "" );

    dump();    
  }
  
  void dump() {    
    _logger.t( "====================================" );
    _logger.t( "GUID: $guid" );
    _logger.t( "Username: $username" );    
    _logger.t( "Message: $message" );
    _logger.t( "Time: $time" );    
    _logger.t( "====================================" );
  }
}