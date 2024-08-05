import 'package:client/providers/player.dart';
import 'package:flutter/material.dart';
import 'package:eventify/eventify.dart' as eventify;
import 'package:logger/logger.dart';

class HeaderBar extends StatefulWidget {
  const HeaderBar({super.key});

  @override
  State<HeaderBar> createState() => _HeaderBarState();
}

class _HeaderBarState extends State<HeaderBar> {
  final Logger _logger = Logger();

  final PlayerProvider _player = PlayerProvider();
  late eventify.Listener _onPlayerUpdatedListener;

  @override
  void dispose() {
    _logger.t( "dispose" );

    _onPlayerUpdatedListener.cancel();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _logger.t( "initState" );

    _onPlayerUpdatedListener = _player.on( "UPDATED", null, onplayerUpdated );
  }

  @override
  Widget build(BuildContext context) {
    return const Image(image: AssetImage('assets/header-background.png'));
  }

  void onplayerUpdated( ev, obj ) {
    _logger.d( "onPlayerUpdated" );
    setState(() {});
  }
}