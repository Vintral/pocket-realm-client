import 'package:flutter/material.dart';

class PanelPageRoute<T> extends MaterialPageRoute<T> {
  PanelPageRoute({ required super.builder, super.settings });

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {        
            
    // Fades between routes. (If you don't want any animation,
    // just return child.)
    return FadeTransition(opacity: animation, child: child);
  }
}