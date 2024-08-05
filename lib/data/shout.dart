import 'package:logger/logger.dart';

class ShoutData {
  final Logger _logger = Logger( level: Level.trace );
  
  late String username;
  late String avatar;
  late String characterClass;
  late String shout;  
  late DateTime time;

  ShoutData( dynamic data ) {  
    time = DateTime.parse( data[ "created_at" ] ?? ( data[ "time" ] ?? "" ) );
    username = data[ "username" ] ?? "";
    characterClass = data[ "character_class" ] ?? "";
    avatar = data[ "avatar" ] ?? "";    
    shout = data[ "shout" ] ?? "";    

    dump();    
  }
  
  void dump() {    
    _logger.t( "====================================" );
    _logger.t( "Username: $username" );
    _logger.t( "Avatar: $avatar" );
    _logger.t( "Class: $characterClass" );
    _logger.t( "Shout: $shout" );
    _logger.t( "time: $time" );
    _logger.t( "====================================" );
  }
}