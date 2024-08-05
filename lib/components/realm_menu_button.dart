import 'package:client/providers/theme.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class RealmMenuButton extends StatelessWidget {
  RealmMenuButton( { super.key, required this.handler, required this.type, required this.active, required this.image } );

  final _theme = ThemeProvider();
  final _logger = Logger( level: Logger.level );

  final void Function(String) handler;
  final String type;
  final bool active;
  final ImageProvider<Object> image;

  @override
  Widget build(BuildContext context) {
    _logger.t( "build" );

    var size = MediaQuery.of( context ).size.width / 5;

    return  GestureDetector(
      onTap: () => handler( type ),
      child: Transform.translate(
        offset: Offset( 0, active ? 0 : 0 ),
        child: Stack(
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                _theme.color,
                _theme.blendMode,
              ),
              child: Image(
                width: size,
                height: size,
                image: const AssetImage('assets/ui/footer-tab.png')
              ),
            ),
            Padding(
              padding: EdgeInsets.all( size / 4),
              child: Image(
                alignment: Alignment.bottomRight,
                width: size / 2,
                image: image,
              ),
            ),
          ],
        ),
      ),
    );
  }
}