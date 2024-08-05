import 'dart:collection';

import 'package:client/data/class_colors.dart';
import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ThemeProvider extends EventEmitter {
  static final ThemeProvider _instance = ThemeProvider._internal();

  factory ThemeProvider() {
    return _instance;
  }

  final Logger _logger = Logger( level: Logger.level );

  int animationSpeed = 300;

  double width = 0.0;
  double height = 0.0;

  double gap = 10.0;

  double headerHeight = 0.0;
  double headerDrawerBackground = 0.0;
  double headerDrawerCap = 0.0;  

  double quantityPadding = 2.0;

  int gradientOpacity = 100;

  Color color = const Color.fromARGB(200, 0, 0, 0 );
  Color colorAccent = const Color.fromARGB(200, 0, 0, 0 );
  Color colorBackground = const Color.fromARGB(200, 0, 0, 0 );
  Color colorDisabled = const Color.fromARGB(200, 0, 0, 0 );
  Color colorText = Colors.white;
  BlendMode blendMode = BlendMode.darken;

  Color shadowColor = const Color.fromARGB( 200, 0, 0, 0, );
  Color inactiveBorderColor = const Color.fromARGB( 255, 127, 127,127 );  
  Color activeBorderColor = const Color.fromARGB( 255, 255, 255, 0 );

  final Map<String,ClassColors> _classColorsMap = HashMap();
  Map<String,ClassColors> get classColorsMap => _classColorsMap;
  
  static const baseFontSize = 10.0;

  late TextStyle resultStyle;  
  late TextStyle styleHeader;
  late TextStyle headerStatStyle;
  late TextStyle headerStatStyleLarge;
  late TextStyle styleTab; 
  late TextStyle styleActiveTab;
  late TextStyle styleDisabledTab;
  late TextStyle styleQuantitySmall;
  late TextStyle styleNewsTitle;
  late TextStyle styleNewsPosted;
  late TextStyle styleNewsBody;
  late TextStyle styleShoutUsername;
  late TextStyle styleShoutDate;
  late TextStyle styleShoutMessage;
  late TextStyle styleTextInput;
  late TextStyle styleConversationMessage;
  late TextStyle styleConversationReplied;
  late TextStyle styleConversationRepliedMessage;
  
  ThemeProvider._internal() {
    _logger.d( 'Created' );

    initializeThemes();
    setTheme( "mage" );
  }

  initializeThemes() {
    _logger.d( "initializeThemes" );

    _classColorsMap[ "druid" ] = ClassColors( base: Colors.green );
    _classColorsMap[ "merchant" ] = ClassColors( base: Colors.yellow );
    _classColorsMap[ "mage" ] = ClassColors( base: Colors.blue );
    _classColorsMap[ "priest" ] = ClassColors( base: Colors.white );
    _classColorsMap[ "warlord" ] = ClassColors( base: Colors.red );
    _classColorsMap[ "necromancer" ] = ClassColors( base: Colors.blueGrey );
    _classColorsMap[ "" ] = ClassColors( base: const Color.fromARGB(255, 75, 75, 75) );
  }

  setTextStyles( Color color ) {
    _logger.d( "setTextStyles" );

    resultStyle = TextStyle( fontSize: baseFontSize * 1.4, fontWeight: FontWeight.normal, decoration: TextDecoration.none, color: color, );  
    styleHeader = TextStyle( fontSize: baseFontSize * 1.8, fontWeight: FontWeight.normal, decoration: TextDecoration.none, color: color, );  
    headerStatStyle = TextStyle( fontSize: baseFontSize, fontWeight: FontWeight.normal, decoration: TextDecoration.none, color: color, );
    headerStatStyleLarge = TextStyle( fontSize: baseFontSize * 1.6, fontWeight: FontWeight.normal, decoration: TextDecoration.none, color: color, );
    styleTab = TextStyle( fontSize: baseFontSize * 1.8, fontWeight: FontWeight.bold, decoration: TextDecoration.none, color: color, );  
    styleActiveTab = const TextStyle( fontSize: baseFontSize * 1.8, fontWeight: FontWeight.bold, decoration: TextDecoration.none, color: Colors.yellow, shadows: [ Shadow( color: Colors.black, blurRadius: 15, offset: Offset(5, 5))] );
    styleDisabledTab = const TextStyle( fontSize: baseFontSize * 1.8, fontWeight: FontWeight.bold, decoration: TextDecoration.none, color: Color.fromARGB(255, 200, 200, 200), shadows: [ Shadow( color: Colors.black, blurRadius: 5)] );
    styleQuantitySmall = TextStyle( fontSize: baseFontSize, fontWeight: FontWeight.bold, decoration: TextDecoration.none, color: color, );  
    styleNewsTitle = TextStyle( fontSize: baseFontSize * 1.8, fontWeight: FontWeight.bold, decoration: TextDecoration.none, color: color, );  
    styleNewsPosted =  const TextStyle( fontSize: baseFontSize, fontWeight: FontWeight.bold, decoration: TextDecoration.none, color: Colors.grey, );  
    styleNewsBody = TextStyle( fontSize: baseFontSize, fontWeight: FontWeight.bold, decoration: TextDecoration.none, color: color, ); 
    styleShoutUsername = TextStyle( fontSize: baseFontSize * 1.2, fontWeight: FontWeight.bold, decoration: TextDecoration.none, color: color, ); 
    styleShoutDate = const TextStyle( fontSize: baseFontSize, fontWeight: FontWeight.bold, decoration: TextDecoration.none, color: Colors.grey, ); 
    styleShoutMessage = TextStyle( fontSize: baseFontSize, fontWeight: FontWeight.normal, decoration: TextDecoration.none, color: color, );
    styleTextInput = TextStyle( fontSize: baseFontSize, fontWeight: FontWeight.normal, decoration: TextDecoration.none, color: color, ); 
    styleConversationMessage = TextStyle( fontSize: baseFontSize, fontWeight: FontWeight.normal, decoration: TextDecoration.none, color: color, ); 
    styleConversationReplied = const TextStyle( fontSize: baseFontSize, fontWeight: FontWeight.bold, decoration: TextDecoration.none, color: Color.fromARGB( 210, 255, 255, 255 ), ); 
    styleConversationRepliedMessage = const TextStyle( fontSize: baseFontSize, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic, decoration: TextDecoration.none, color: Color.fromARGB(179, 255, 255, 255), ); 
  }

  setTheme( String type ) {
    _logger.d( "setTheme: $type" );
    
    var classColors = _classColorsMap[ type ];        

    color = classColors?.color ?? Colors.transparent;
    blendMode = classColors?.blendMode ?? BlendMode.modulate;
    colorAccent = classColors?.colorAccent ?? Colors.transparent;
    activeBorderColor = classColors?.activeBorderColor ?? Colors.transparent;
    inactiveBorderColor = classColors?.inactiveBorderColor ?? Colors.transparent;
    colorBackground = classColors?.colorBackground ?? Colors.transparent;
    colorText = classColors?.colorText ?? Colors.white;
    colorDisabled = classColors?.colorDisabled ?? Colors.transparent;

    setTextStyles( colorText );
  }
}