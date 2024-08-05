import 'package:client/settings.dart';
import 'package:flutter/material.dart';

class HeaderStat extends StatelessWidget {
  const HeaderStat({super.key, required this.icon, required this.value});

  final String icon;
  final dynamic value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [        
        Text(
          value.toString(),
          style: Settings.headerStatStyle,
        ), 
        SizedBox(
          width: MediaQuery.of( context ).size.width / 64,
        ),
        SizedBox(
          width: MediaQuery.of( context ).size.width / 32,
          child: Image.asset( "assets/icons/$icon.png", fit: BoxFit.fitWidth, )
        ), 
      ],
    );
  }
}