import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Notification extends StatefulWidget {
  const Notification( { super.key, required this.message, this.error = false } );

  final String message;
  final bool error;

  @override
  State<Notification> createState() => _NotificationState();
}

class _NotificationState extends State<Notification> with SingleTickerProviderStateMixin {
  final Logger _logger = Logger();
  
  late AnimationController _controller;
  late Animation<double> _curve;
  late Animation<double> _opacityTween;
  late Animation<double> _scaleTween;  
  Timer? hideTimer;  

  @override
  void initState() {
    super.initState();

    _logger.t( "initState" );    

    _controller = AnimationController(
      vsync: this,
      duration: const Duration( milliseconds: 250 ),
    );

    _curve = CurvedAnimation(
      parent: _controller, curve: Curves.bounceInOut
    );

    _opacityTween = Tween<double>( begin: 0.0, end: 1.0 ).animate( _curve );

    _scaleTween = Tween<double>( begin: 0.8, end: 1.0 ).animate( _curve )
      ..addListener( () => setState(() {} ) )
      ..addStatusListener( ( status ) {
        hideTimer ??= Timer( const Duration( seconds: 5 ), onHideTimer );
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _logger.t( "dispose" );

    hideTimer?.cancel();
    _controller.dispose();

    super.dispose();    
  }  

  @override
  Widget build(BuildContext context) {
    _logger.t( "build" );
    var baseY = MediaQuery.of( context ).size.width / 5;

    return Positioned(
      //bottom: baseY + 10,
      bottom: baseY + 10,
      left: 10,      
      child: Transform.scale(
        scale: _scaleTween.value,
        child: Opacity(
          opacity: _opacityTween.value,
          child: Container(                        
            color: widget.error ? Colors.red : Colors.green,
            child: SizedBox(
              width: MediaQuery.of( context ).size.width - 20,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all( 20 ),
                  child: Text( widget.message, style: const TextStyle( fontSize: 23, fontWeight: FontWeight.bold, decoration: TextDecoration.none, color: Colors.white, ), ),
                ),
              ),
            ),
          ),
        ),        
      ),
    );
  }

  void onHideTimer() {
    _logger.d( "onHideTimer" );
    _controller.reverse();
  }
}