import 'package:logger/logger.dart';

import 'package:client/data/message.dart';

class ConversationData {
  final Logger _logger = Logger( level: Level.trace );
  
  late String guid;
  late String username;
  late String characterClass;
  late String avatar;  
  late DateTime lastRead;
  late DateTime updated;
  late bool reply;
  late String message;

  List<MessageData> messages = <MessageData>[];

  ConversationData( dynamic data ) {    
    guid = data[ "guid" ] ?? "";
    username = data[ "username" ] ?? "";
    avatar = data[ "avatar" ] ?? "";    

    //characterClass = data[ "character_class" ];

    reply = data[ "last_message" ][ "reply" ];
    message = data[ "last_message" ][ "text" ];

    lastRead = DateTime.parse( "2024-05-02T10:23:06.75-07:00" );

    lastRead = DateTime.parse( data[ "last_read" ] ?? "" );
    updated = DateTime.parse( data[ "updated" ] ?? "" );

    dump();    
  }
  
  void dump() {    
    _logger.t( "====================================" );
    _logger.t( "Username: $username" );
    _logger.t( "Avatar: $avatar" );
    _logger.t( "Reply: $reply" );
    _logger.t( "Message: $message" );
    _logger.t( "Last Read: $lastRead" );
    _logger.t( "Updated: $updated" );
    _logger.t( "====================================" );
  }
}