import 'package:client/connection.dart';
import 'package:client/data/event.dart';
import 'package:flutter/material.dart';

import 'package:client/providers/theme.dart';
import 'package:client/utilities.dart';
import 'package:logger/logger.dart';

class Event extends StatelessWidget {
  Event( { super.key, required this.data } );
  
  final Logger _logger = Logger( level: Level.warning );

  final _theme = ThemeProvider();

  final EventData data;

  final Connection _connection = Connection();

  sendRead() {
    if( !data.seen ) {
      _logger.w( "SEND READ: ${data.guid}" );
      _connection.markEventSeen( data.guid );
    }
  }

  @override
  Widget build( BuildContext context ) {
    var size = MediaQuery.of( context ).size.width / 6;
    var scale = .65;

    _logger.t( "Message: ${data.message}" );
    _logger.t( "Time Since: ${timeSince( data.time )}" );

    var currentSeen = data.seen;
    sendRead();

    return Container(
      decoration: BoxDecoration(
        border: Border.all( width: _theme.gap, color: data.seen ? _theme.inactiveBorderColor : _theme.activeBorderColor ),
        gradient: RadialGradient(
          radius: size / 10,          
          colors: [
            Color.fromARGB( 
              _theme.color.alpha, 
              (_theme.color.red * scale).toInt(), 
              (_theme.color.green * scale).toInt(), 
              (_theme.color.blue * scale).toInt(),
            ),
            _theme.color,                     
          ]
        ),
        borderRadius: BorderRadius.all( Radius.circular( _theme.gap ) ),
      ),      
      child: Stack(
        children: [
          Text( data.message, style: _theme.styleHeader, ),          
          Positioned(                        
            child: Container(
              color: currentSeen ? _theme.activeBorderColor : _theme.colorBackground,
              child: Text( timeSince( data.time ), style: _theme.styleHeader ),
            )
          )
        ]
      ),
    );
  }
}