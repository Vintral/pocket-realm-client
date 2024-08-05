import 'package:client/providers/theme.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class SlideMenuButton extends StatelessWidget {
  SlideMenuButton({super.key, required this.text, required this.handler});

  final _theme = ThemeProvider();
  final _logger = Logger( level: Logger.level );

  final String text;  
  final void Function(String) handler;
  final TextStyle _style = const TextStyle( fontSize: 18, decoration: TextDecoration.none, color: Colors.white, );

  @override
  Widget build(BuildContext context) {
    _logger.t( "build" );

    return GestureDetector(
      onTap: () => handler( text.toLowerCase() ),
      child: SizedBox(
        width: 150,
        height: 48,
        child: Stack(          
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                _theme.color,
                _theme.blendMode,
              ),
              child: Image.asset( "assets/ui/slide-menu-button.png", fit: BoxFit.fill ),
            ),
            Center(
              child: Text( text, style: _style ),
            ),
          ]
        ),
      ),
    ); 
  }
}