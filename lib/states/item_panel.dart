import 'package:client/components/item_with_border.dart';
import 'package:client/data/realm_object.dart';
import 'package:client/providers/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

abstract class ItemPanelState<T extends StatefulWidget> extends State<T> {
  final _theme = ThemeProvider();
  final _logger = Logger( level: Logger.level, );

  late List<RealmObject> items;
  late String type;

  void onTap( String guid ) {
    _logger.i( "onTap: $guid" );
  }

  List<Widget> buildChildren() {
    var ret = <Widget> [];

    for( int n = 0; n < items.length; n++ ) {      
      ret.add(
        ItemWithBorder(
          item: items[ n ],
          handler: onTap,          
          padding: EdgeInsets.all( _theme.gap ),
        )
      );
    }

    return ret;
  }
}