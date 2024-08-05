import 'dart:async';

import 'package:client/components/header.dart';
import 'package:client/connection.dart';
import 'package:client/providers/theme.dart';
import 'package:eventify/eventify.dart' as eventify;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {  
  final Logger _logger = Logger();  
  final ThemeProvider _theme = ThemeProvider();

  late Connection _connection;
  BuildContext? _context;
  late eventify.Listener _onConnectedListener;
  late eventify.Listener _onConnectionError;

  @override
  void initState() {  
    super.initState();
        
    _logger.t( "initState" );
    
    _connection = Connection();    
    _onConnectedListener = _connection.on( "CONNECTED", null, onConnected );
    _onConnectionError = _connection.on( "ERROR", null, onError );
    _connection.connect();
  }

  initialize() async {
    _logger.t( "initialize" );    
  }

  @override
  void dispose() {
    clearListeners();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _logger.t( "build" );

    _context = context;    
    
    
    return const Stack(
      children: [
        Center(                            
          child: Text( "Splash Screen", style: TextStyle( fontSize: 26 ), ),      
        ),
        Header( neverShow: true, ),
      ]
    );      
  }

  void initializeTheme() {
    _logger.t( "initializeTheme" );
    
    if( _context != null ) {
      var size = MediaQuery.of( _context as BuildContext ).size;

      _theme.width = size.width;
      _theme.height = size.height;      

      _theme.headerHeight = size.width / 4;
      _theme.headerDrawerCap = _theme.headerHeight / 2.5;
    }
  }

  void onConnected( ev, context ) {
    _logger.i( "CONNECTED" );
    
    if( _context != null ) {
      initializeTheme();
      Navigator.popAndPushNamed(_context as BuildContext, "login");    
    }
  }

  void onError( ev, context ) {
    _logger.e( "onError" );

    Timer(const Duration(seconds: 5), () {
      _logger.d( "Retrying" );
      
      _connection.connect();
    });
  }

  void clearListeners() {
    _onConnectedListener.cancel();
    _onConnectionError.cancel();
  }
}