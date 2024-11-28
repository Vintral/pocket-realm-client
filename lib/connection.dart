import 'dart:async';
import 'dart:convert';

import 'package:client/settings.dart';
import 'package:eventify/eventify.dart' as eventify;
import 'package:logger/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Connection extends eventify.EventEmitter {
  final Logger _logger = Logger(level: Level.warning);

  late WebSocketChannel _channel;

  bool _connected = false;
  Timer? _heartbeat;
  bool get connected => _connected;

  static final Connection _instance = Connection._internal();

  factory Connection() {
    return _instance;
  }

  Connection._internal() {
    _logger.d("_internal");
    //if( !_connected ) connect();
  }

  decodePayload(dynamic data) {
    _logger.t("decodePayload");
    _logger.f(data);

    if (data != null && data is String) {
      data = json.decode(utf8.decode(base64.decode(data)));
    }

    return data;
  }

  connect() async {
    _logger.d("connect");
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://${Settings.server}'),
    );

    _channel.stream.listen((message) {
      _logger.i("Message: ${message.toString()}");

      var data = json.decode(message);
      if (data is String) {
        _logger.d("IS STRING");
        data = json.decode(data);
      } else {
        _logger.d("IS NOT STRING");
      }
      _logger.w(data);

      if (data["type"] != null) {
        _logger.t("Type: ${data["type"]}");
        switch (data["type"]) {
          case "PONG":
            _logger.t("Received Pong");
            break;
          case "ERROR":
          case "ERROR_ROUND":
            _logger.w("Received Error");
            // if( data[ "data" ] ) {
            //   data[ "data" ] = base64.decode( data[ "data" ] );
            // }
            _logger.w(data);
            _logger.w(data["data"]["message"]);

            emit("ERROR", null, data["data"]["message"]);
            break;
          default:
            {
              _logger.w("EMITTING: ${data["type"]}");
              emit(data["type"], null, data);
            }
        }
      }

      if (data["user"] != null) {
        emit("PLAYER_UPDATE", null, data);
      }
    }, onError: (err) {
      _logger.e("DISCONNECTED");
      _logger.w('Error: ${err.toString()}');
      emit("ERROR");
    }, onDone: () async {
      if (_connected) {
        _connected = false;
        _logger.e('CLOSED');
        _heartbeat?.cancel();
        emit("DISCONNECTED");
      }
    });

    try {
      await _channel.ready;
      _connected = true;

      _heartbeat = Timer.periodic(const Duration(minutes: 1), onTick);
      emit("CONNECTED");
    } on Exception catch (_) {
      _logger.w("ERROR CONNECTING");
    }
  }

  disconnect() {
    _logger.d("disconnect");

    if (_connected) {
      _channel.sink.close();
    }
  }

  // Future<void> connect() async {
  //   _channel = await IOWebSocketChannel.connect( _url );

  //   if( _created ) return;
  //   _created = true;

  //   _connected = true;

  //   _channel.stream.listen( ( message ) {
  //     //_channel.sink.add( "received!" );
  //     print( 'Message: ' + message.toString() );
  //     var data = json.decode( message );

  //     if( data[ "type" ] != null )
  //       emit( data[ "type" ], null, data[ "data" ] );

  //     /*switch( data[ 'type' ] ) {
  //       case 'LOGIN_SUCCESS': emit( 'LOGIN_SUCCESS', null, data[ 'user' ] ); break;
  //       case 'LOGIN_ERROR': emit( 'LOGIN_ERROR', null, data[ 'error' ] ); break;
  //       case 'MESSAGE': emit( 'MESSAGE', null, { 'message':data[ 'message' ], 'user':data[ 'user' ], 'avatar':data[ 'avatar' ], 'chat':data[ 'chat' ] } ); break;
  //       case 'MESSAGE_SENT': emit( 'MESSAGE_SENT' ); break;
  //       case 'MESSAGE_ERROR': emit( 'MESSAGE_ERROR' ); break;
  //       case 'CONTACTS': emit( 'CONTACTS', null, data[ 'contacts' ] ); break;
  //       case 'CHATS': emit( 'CHATS', null, data[ 'chats' ] ); break;
  //       case 'CHAT': emit( 'CHAT', null, data[ 'data' ] ); break;
  //       case 'CHAT_ID': emit( 'CHAT_ID', null, data[ 'chat' ] ); break;
  //       case 'DIRECTORY': emit( 'DIRECTORY', null, data ); break;
  //       case 'CONTACT_ADDED': emit( 'CONTACT_ADDED', null, data[ "data" ] ); break;
  //       case 'ERROR_ADDING_CONTACT': emit( 'ERROR_ADDING_CONTACT', null ); break;
  //       case 'CONTACT_REMOVED': emit( 'CONTACT_REMOVED', null, data[ 'contact' ] ); break;
  //       case 'ERROR_REMOVING_CONTACT': emit( 'ERROR_REMOVING_CONTACT', null ); break;
  //     }*/
  //   }, onError: ( err ) {
  //     debug( 'Error: ' + err.toString() );
  //   }, onDone: () async {
  //     debug( 'CLOSED' );
  //     _connected = false;
  //   } );
  // }

  void _send(Object data) {
    _channel.sink.add(json.encode(data));
  }

  void sendExplore({int energy = 1}) {
    _logger.i("sendExplore: $energy");
    _send({'type': 'EXPLORE', 'energy': energy});
  }

  void sendGather({int energy = 1, required String resource}) {
    _logger.i("sendGather: $energy - $resource");
    _send({'type': 'GATHER', 'energy': energy, 'resource': resource});
  }

  void sendRetrieveLibrary({required String round}) {
    _logger.i("sendRetrieveLibrary: $round");
    _send({'type': 'ROUND', 'round': round});
  }

  void sendGetSelf() {
    _logger.i("sendGetSelf");
    _send({'type': 'GET_SELF'});
  }

  void getRules() {
    _logger.i("getRules");
    _send({'type': 'RULES'});
  }

  void getShouts() {
    _logger.i("getShouts");
    _send({'type': 'SHOUTS'});
  }

  void getNews() {
    _logger.i("getNews");
    _send({'type': 'NEWS'});
  }

  void sendRecruit({required int energy, required String unit}) {
    _logger.i("sendRecruit: $energy - $unit");
    _send({'type': 'RECRUIT', 'energy': energy, 'unit': unit});
  }

  void sendBuild({required int energy, required String building}) {
    _logger.i("sendBuild: $energy - $building");
    _send({'type': 'BUILD', 'energy': energy, 'building': building});
  }

  void sendShout(String shout) {
    _logger.i("sendShout: $shout");
    _send({"type": "SHOUT", "shout": shout});
  }

  void sendMessage(String message, String to) {
    _logger.i("sendMessage: $message to $to");
    _send({"type": "MESSAGE", "message": message, "to": to});
  }

  void sendSubscribeShouts() {
    _logger.i("sendSubscribeShouts");
    _send({"type": "SUBSCRIBE_SHOUTS"});
  }

  void sendUnubscribeShouts() {
    _logger.i("sendUnubscribeShouts");
    _send({"type": "UNSUBSCRIBE_SHOUTS"});
  }

  void getConversations() {
    _logger.i("getConversations");
    _send({"type": "GET_CONVERSATIONS"});
  }

  void getMessages({required String conversation}) {
    _logger.i("getMessages: $conversation");
    _send({"type": "GET_MESSAGES", "conversation": conversation});
  }

  void getEvents(int page) {
    _logger.i("getEvents: $page");
    _send({"type": "GET_EVENTS", "page": page});
  }

  void getRounds() {
    _logger.i("getRounds");
    _send({"type": "GET_ROUNDS"});
  }

  void getRankings() {
    _logger.i("getRankings");
    _send({"type": "GET_RANKINGS"});
  }

  void markEventSeen(String event) {
    _logger.i("markEventSeen: $event");
    _send({"type": "MARK_EVENT_SEEN", "event": event});
  }

  void playRound(String round) {
    _logger.i("playRound");
    _send({"type": "PLAY_ROUND", "round": round});
  }

  void getMarketInfo() {
    _logger.i("getMarketInfo");
    _send({"type": "GET_MARKET_INFO"});
  }

  // void sendLogin( { String username, String password } ) {
  //   debug( "sendLogin" );
  //   _send( { 'command': 'login', 'username': username, 'password': password } );
  // }

  // void sendRegister( { String firstName, String lastName, String email, String password, String numberNPS } ) {
  //   _send( { 'command': 'register', 'firstName': firstName, 'lastName': lastName, 'email': email, 'password': password, 'numberNPS': numberNPS } );
  // }

  // void sendMessage( { int chat, String message } ) {
  //   debug( 'sendMessage' );
  //   _send( { 'command': 'message', 'chatid': chat, 'message': message } );
  // }

  // void sendToken( { String token } ) {
  //   debug( 'sendToken' );
  //   _send( { 'command': 'register_token', 'token': token } );
  // }

  // void getContacts() {
  //   debug( 'getContacts' );
  //   _send( { 'command': 'get_contacts' } );
  // }

  // void getDirectory( { String search, int page } ) {
  //   debug( 'getDirectory: ' + search );
  //   _send( { 'command': 'get_directory', 'needle': search, 'page': page } );
  // }

  // void getChats() {
  //   debug( 'getChats' );
  //   _send( { 'command': 'get_chats' } );
  // }

  // void getChat( { int ID } ) {
  //   debug( 'getChat: ' + ID.toString() );
  //   _send( { 'command': 'get_chat', 'id': ID } );
  // }

  // void getChatID( { int person } ) {
  //   debug( 'getChatID: ' + person.toString() );
  //   _send( { 'command': 'get_chat_id', 'person':person } );
  // }

  // void addContact( { int ID } ) {
  //   debug( 'addContact: ' + ID.toString() );
  //   _send( { 'command': 'add_contact', 'id': ID } );
  // }

  // void removeContact( { int ID } ) {
  //   debug( 'removeContact: ' + ID.toString() );
  //   _send( { 'command': 'remove_contact', 'id': ID } );
  // }

  // void createGroupChat( String name, List<int> people, String description ) {
  //   debug( "createGroupChat" );
  //   _send( { "command": "create_group_chat", "name": name, "people": people, "description": description } );
  // }

  // getMapMarkers( double south, double west, double north, double east ) {
  //   debug( "getMapMarkers" );
  //   _send( { "command": "get_markers", "south":south, "west":west, "north":north, "east":east } );
  // }

  /*bool get connected => _connected;

  void test() {
    emit( "TESTING", this, { "message":"Hello World" } );
  }

  Map<String, String> _getHeaders() {
    return <String, String>{
      'Content-Type': 'application/json',
    };    
  }

  Future<Response> sendRequest( path, Method method, String data ) async {
    debug( 'sendRequest: ' + path + ' - ' + method.toString() + ' - ' + data );

    switch( method ) {
      case Method.get: return await http.get( _url + path, headers:_getHeaders() );
      case Method.post: return await http.post( _url + path, headers:_getHeaders(), body:data );        
    }
  }

  Future<dynamic> sendLogin( username, password ) async {
    debug( "sendLogin: " + username + ' - ' + password );
        
    var payload = { 
      'sessions': { 
        'email':username, 
        'password':password 
      } 
    };
    var response = await sendRequest( 'sessions', Method.post, JsonEncoder().convert( payload ) );        

    return jsonDecode( response.body );
  }

  Future<dynamic> sendRegister( firstName, lastName, email, password, password2, nps ) async {
    debug( "sendRegister: " + firstName + " - " + lastName + " - " + email + " - " + nps );

    var payload = {    
      "registrations": { 
        'email': email, 
        'password': password, 
        'password_confirmation': password2,
        'profile_attributes': {
          'first_name': firstName, 
          'last_name': lastName, 
          'state_license_number': nps
        },
      }
    };
    var response = await sendRequest( 'registrations', Method.post, JsonEncoder().convert(payload ) );
    return jsonDecode( response.body );
  }*/

  void onTick(timer) {
    _logger.t("onTick");

    // if (_connected) {
    //   _send({'type': 'PING'});
    // }
  }
}
