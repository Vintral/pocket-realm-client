import 'dart:math';

import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:client/providers/theme.dart';

class RealmMenuButton extends StatelessWidget {
  RealmMenuButton(
      {super.key,
      required this.handler,
      required this.type,
      required this.active,
      required this.image});

  final _theme = ThemeProvider();
  final _logger = Logger(level: Logger.level);

  final void Function(String) handler;
  final String type;
  final bool active;
  final ImageProvider<Object> image;

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    var horizontalSize = MediaQuery.of(context).size.width / 5;

    _theme.footerHeight = min(
      MediaQuery.of(context).size.width / 5,
      MediaQuery.of(context).size.height / 5,
    );

    return GestureDetector(
      onTap: () => handler(type),
      child: Transform.translate(
        offset: Offset(0, active ? 0 : 0),
        child: SizedBox(
          width: horizontalSize,
          height: _theme.footerHeight,
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: Colors.green,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      _theme.color,
                      _theme.blendMode,
                    ),
                    child: Image(
                      image: const AssetImage('assets/ui/footer-tab.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Center(
                child: Image(
                  image: image,
                  height: _theme.footerHeight / 2,
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.all(horizontalSize / 4),
              //   child: Image(
              //     alignment: Alignment.bottomRight,
              //     width: horizontalSize / 2,
              //     image: image,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
