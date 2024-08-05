import 'package:flutter/material.dart';

import 'package:client/components/item_with_border.dart';
import 'package:client/providers/theme.dart';
import 'package:client/utilities.dart';

class Shout extends StatelessWidget {
  Shout( { super.key, required this.avatar, required this.username, required this.time, required this.message, required this.characterClass } );

  final _theme = ThemeProvider();

  final String avatar;
  final String username;
  final String characterClass;
  final DateTime time;
  final String message;

  @override
  Widget build( BuildContext context ) {
    var size = MediaQuery.of( context ).size.width / 6;

    var colors = _theme.classColorsMap[ characterClass ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors != null
              ? Color.fromARGB( ( _theme.gradientOpacity / 60 ).floor(), colors.colorAccent.red, colors.colorAccent.green, colors.colorAccent.blue )
              : Color.fromARGB( ( _theme.gradientOpacity / 60 ).floor(), _theme.colorAccent.red, _theme.colorAccent.green, _theme.colorAccent.blue ),
            colors != null 
              ? Color.fromARGB( _theme.gradientOpacity, colors.color.red, colors.color.green, colors.color.blue )
              : Color.fromARGB( _theme.gradientOpacity, _theme.color.red, _theme.color.green, _theme.color.blue ),
          ]
        ),
        borderRadius: BorderRadius.all( Radius.circular( _theme.gap ) ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ItemWithBorder( image: "assets/avatars/$avatar.png", height: size, backgroundColor: colors?.color, ),
          SizedBox( width: _theme.gap ),
          Expanded(            
            child: Padding(
              padding: EdgeInsets.all( _theme.gap / 2 ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(                    
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text( username, style: _theme.styleShoutUsername ),
                      Text( timeSince( time ), style: _theme.styleShoutDate ),
                    ],
                  ),
                  SizedBox( height: _theme.gap / 2 ),
                  Text( message, style: _theme.styleShoutMessage ),
                ],
              ),
            ),
          ),          
        ],
      ),
    );
  }
}