import 'package:client/components/item_with_border.dart';
import 'package:client/data/realm_object.dart';
import 'package:client/providers/theme.dart';
import 'package:client/settings.dart';
import 'package:flutter/material.dart';

class RealmDisplayObject extends StatelessWidget {
  RealmDisplayObject( { super.key, this.item, this.child, this.image, this.color, this.message, this.padding, this.canGrow = false } );

  final _theme = ThemeProvider();

  final String? message;
  final bool canGrow;
  final RealmObject? item;
  final String? image;
  final Color? color;
  final Widget? child;
  final EdgeInsets? padding;

  @override
  Widget build( BuildContext context ) {
    var size = MediaQuery.of( context ).size.width / 5;

    Widget content = SizedBox(
      height: canGrow ? null : size,
      child: Container(
        color: Colors.blue,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  _theme.colorAccent,
                  _theme.blendMode,
                ),
                child: Image.asset( 
                  "assets/result-message-background.png", 
                  fit: BoxFit.fill,                  
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB( _theme.gap, _theme.gap, _theme.gap * 1.5, _theme.gap ),
              child: Align(                
                alignment: Alignment.centerLeft,
                child: child ?? Text( message ?? "", style: _theme.resultStyle, softWrap: true, ),
              ),
            ),
          ]
        ),
      ),
    );

    if( item != null || image != null ) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: ItemWithBorder(
              item: item,
              image: image,
              color: color,
              padding: padding,
            )
          ),
          SizedBox( width: Settings.horizontalGap / 2 ),
          Expanded(              
            child: content,
          ),
        ],
      );
    }

    return content;
  }
}