import 'dart:collection';

import 'package:client/data/message.dart';
import 'package:eventify/eventify.dart';
import 'package:logger/logger.dart';

import 'package:client/connection.dart';
import 'package:client/data/conversation.dart';
import 'package:client/data/shout.dart';
import 'package:client/settings.dart';

class SocialProvider extends EventEmitter {
  static final SocialProvider _instance = SocialProvider._internal();

  factory SocialProvider() {
    return _instance;
  }
  
  final Logger _logger = Logger( level: Level.warning );
  final Connection _connection = Connection();  

  bool _busy = false;
  bool get busy => _busy;
  set busy( value ) => _busy = value;

  final List<ShoutData> _shouts = <ShoutData>[];
  List<ShoutData> get shouts => _shouts;

  final Map<String,ConversationData> _conversationMap = HashMap();
  Map<String,ConversationData> get conversationMap => _conversationMap;

  final List<ConversationData> _conversations = <ConversationData>[];
  List<ConversationData> get conversations => _conversations;

  // String conversation = "";
  String conversationAvatar = "";

  ConversationData? currentConversation;

  ConversationData? _conversation;
  ConversationData? get conversation => _conversation;
  set conversation( value ) {
    _conversation = _conversations.where( ( curr ) => curr.username == value ).first;
    _conversation?.dump();
  }

  // List<Widget> notifications( BuildContext context ) { 
  //   var size = MediaQuery.of( context ).size.width / 5;

  //   return _notifications.map( 
  //     ( notification ) => AnimatedPositioned(
  //       duration: Duration( microseconds: 250 ),
  //       child: Container(
  //         color: Colors.blue,
  //         child: SizedBox( height: 50, ),
  //       ),
  //     ),
  //   );
  // }  

  SocialProvider._internal() {
    _logger.d( "Created" );

    _connection.on( "SHOUTS", null, onShouts );
    _connection.on( "SHOUT", null, onShout );
    _connection.on( "SEND_SHOUT", null, onShoutSent );

    _connection.on( "CONVERSATIONS", null, onConversations );
    _connection.on( "MESSAGES", null, onMessages );
    _connection.on( "MESSAGE", null, onMessage );
    _connection.on( "MESSAGE_SENT", null, onMessageSent );
    _connection.on( "MESSAGE_ERROR", null, onMessageError );
  }

  void onConversations( e, o ) {
    _logger.w( "onConversations" );
    _logger.w( e.eventData );

    _conversations.addAll( ( ( e.eventData as dynamic )[ "conversations" ] as List<dynamic> ).map<ConversationData>( ( data ) {
      var conversation = ConversationData( data );
      _conversationMap[ conversation.guid ] = conversation;
      return conversation;
    } ) );
    emit( "CONVERSATIONS" );
  }

  void onMessage( e, o ) {
    _logger.d( "onMessage" );

    _conversations.clear();
    emit( "CONVERSATIONS" );
  }

  void onMessages( e, o ) {
    _logger.w( "onMessages" );
    _logger.w( e.eventData );

    var data = e.eventData;
    if( data[ "conversation" ] != _conversation?.guid ) {
      return;
    }

    _conversation?.messages = ( data[ "messages" ] as List<dynamic> ).map<MessageData>( ( data ) => MessageData( data ) ).toList();
    emit( "MESSAGES" );
  }

  void onShoutSent( e, o ) {
    _logger.d( "onShoutSent" );
    _logger.d( e.eventData );

    if( ( e.eventData as dynamic )[ "success" ] ) {
      emit( "SHOUT_SUCCESS" );
    } else {            
      emit( "SHOUT_ERROR" );
    }
  }

  void onShout( e, o ) {
    _logger.d( "onShout" );

    _shouts.insert(0, ShoutData( ( e.eventData as dynamic )[ "shout" ] ) );
    while( _shouts.length > Settings.maxResults ) {
      _shouts.removeLast();
    }

    emit( "SHOUTS" );
  }

  void onMessageSent( e, o ) {
    _logger.d( "onMessageSent" );
    emit( "MESSAGE_SENT" );
  }

  void onMessageError( e, o ) {
    _logger.d( "onMessageError" );
    emit( "MESSAGE_ERROR" );
  }

  void subscribe() {
    _logger.d( "subscribe" );
    _connection.sendSubscribeShouts();
  }

  void unsubscribe() {
    _logger.d( "unsubscribe" );
    _connection.sendUnubscribeShouts();
  }

  void onShouts( e, o ) {
    _logger.d( "onShouts" );
    _logger.d( e.eventData );

    _shouts.addAll( ( ( e.eventData as dynamic )[ "shouts" ] as List<dynamic> ).map( ( data ) => ShoutData( data ) ) );
    emit( "SHOUTS" );
  }

  void sendShout( String shout ) {
    _logger.d( "sendShout: $shout" );
    _connection.sendShout( shout );
  }

  void sendMessage( String message ) {
    _logger.w( "sendMessage: $message to ${_conversation?.username}" );
    _connection.sendMessage( message, _conversation?.username ?? "" );
  }

  void getConversations() {
    _logger.d( "getConversations" );
    _connection.getConversations();
  }

  void getMessages() {
    _logger.d( "getMessages" );

    if( _conversation != null ) {
      _connection.getMessages( conversation: _conversation!.guid );
    }
  }
  // void onError( e, o ) {
  //   _logger.d( "onError" );

  //   if( e.eventData != null ) {
  //     var message = e.eventData as String;
  //     notifyError( message );  
  //   }
  // }

  void getShouts() {
    _shouts.clear();
    _connection.getShouts();
  }  
}