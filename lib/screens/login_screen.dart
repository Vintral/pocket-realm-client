import 'package:client/connection.dart';
import 'package:client/providers/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:eventify/eventify.dart' as eventify;
import 'package:logger/logger.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});  

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Logger logger = Logger( level: Logger.level );
  
  final PlayerProvider _player = PlayerProvider();
  final Connection _connection = Connection();

  late eventify.Listener _onLoadedListener;

  @override
  void initState() {  
    super.initState();
    
    logger.t( "initState" );
    
    _player.loaded = false;
    _player.busy = false;
    _onLoadedListener = _player.on( "USER_LOADED", null, onUserLoaded );
    _connection.sendGetSelf();
  }

  @override
  void dispose() {
    logger.t( "dispose" );
    _onLoadedListener.cancel();

    super.dispose();    
  }

  void onUserLoaded( e, o ) {
    logger.d( "onUserLoaded" );

    Navigator.popAndPushNamed(context, "game" );
  }

  @override
  Widget build(BuildContext context) {
    logger.t( "build" );  

    // Timer(const Duration(seconds: 0), () {  
    //   Navigator.popAndPushNamed(context, "game" );
    // });
    
    return const Center(
      widthFactor: 1,
      child: Text( "Login Screen", style: TextStyle( fontSize: 26 ), ),
    );
  }
}