import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

class ClassColors {
  final Logger _logger = Logger( level: Level.off );

  final alpha = 50;
  final accent = 50;
  final gradientOpacity = 100;

  late Color color;
  late BlendMode blendMode;
  late Color shadowColor;
  late Color colorAccent;
  late Color colorDisabled;
  late Color activeBorderColor;
  late Color inactiveBorderColor;
  late Color colorBackground;
  late Color colorText;

  ClassColors( { required Color base, BlendMode mode = BlendMode.modulate } ) {  
    color = base;
    blendMode = mode;
    shadowColor = color == Colors.white ? Color.fromARGB( gradientOpacity, 0, 0, 0 ) : Color.fromARGB( gradientOpacity, 255, 255, 255 );

    colorAccent = Color.fromARGB(255, math.min( color.red + accent, 255 ), math.min( color.green + accent, 255 ), math.min( color.blue + accent, 255 ) );
    activeBorderColor = Color.fromARGB( 255, color.red, color.green, color.blue );    
    inactiveBorderColor = Color.fromARGB( alpha, color.red, color.green, color.blue );
    colorDisabled = Color.fromARGB( 255, ( color.red * .7 ).floor(), ( color.green * .7 ).floor(), ( color.blue * .7 ).floor() );
    colorBackground = Color.fromARGB( alpha, color.red, color.green, color.blue );

    colorText = color == Colors.white ? const Color.fromARGB( 255, 0, 0, 0 ) : const Color.fromARGB( 255, 255, 255, 255 );    

    dump();    
  }
  
  void dump() {    
    _logger.t( "====================================" );
    _logger.t( "Color: $color" );
    _logger.t( "Blend Mode: $blendMode" );
    _logger.t( "Shadow Color: $shadowColor" );
    _logger.t( "Accent Color: $colorAccent" );
    _logger.t( "Active Border Color: $activeBorderColor" );
    _logger.t( "Inactive Border Color: $inactiveBorderColor" );
    _logger.t( "Background Color: $colorBackground" );
    _logger.t( "Disabled Color: $colorDisabled" );
    _logger.t( "Text Color: $colorText" );
    _logger.t( "====================================" );
  }
}