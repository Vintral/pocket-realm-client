import 'dart:async';

import 'package:client/connection.dart';
import 'package:eventify/eventify.dart';
import 'package:client/components/notification.dart' as realm;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class NotificationProvider extends EventEmitter {
  static final NotificationProvider _instance = NotificationProvider._internal();

  factory NotificationProvider() {
    return _instance;
  }
  
  final Logger _logger = Logger( level: Logger.level);
  final Connection _connection = Connection();

  final List<realm.Notification> _notifications = <realm.Notification>[];
  List<Widget> get notifications {    
    List<Widget> ret = _notifications.cast<Widget>();    
    return ret;
  }

  bool _busy = false;
  bool get busy => _busy;
  set busy( value ) => _busy = value;  

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

  NotificationProvider._internal() {
    _logger.d( "Created" );
    _connection.on( "ERROR", null, onError );
  }

  void onError( e, o ) {
    _logger.d( "onError" );

    if( e.eventData != null ) {
      var message = e.eventData as String;
      notifyError( message );  
    }
  }

  void notifySuccess( message ) {
    _logger.i( "notifyError: $message" );

    _notifications.add( realm.Notification( message:message ) );

    Timer( const Duration( seconds: 3 ), () {
      _notifications.removeAt( 0 );
      emit( "NOTIFICATIONS_UPDATED" );
    } );    
    emit( "NOTIFICATIONS_UPDATED" );
  }

  void notifyError( message ) {
    _logger.w( "notifyError: $message" );

    _notifications.add( realm.Notification( message:message, error: true, ) );

    Timer( const Duration( seconds: 10 ), () {
      _notifications.removeAt( 0 );
      emit( "NOTIFICATIONS_UPDATED" );
    } );    
    emit( "NOTIFICATIONS_UPDATED" );
  }
}