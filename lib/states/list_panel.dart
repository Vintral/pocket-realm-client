import 'package:flutter/widgets.dart';

abstract class ListPanelState<T extends StatefulWidget> extends State<T> {
  late List<String> items;
  late String type;  

  List<Widget> buildChildren() {
    var ret = <Widget> [];

    for( int i = 0; i < 5; i++ ) {
      for( int n = 0; n < items.length; n++ ) {
        ret.add(
          // GridItem(
          //   filename: "${type}-${items[ n ]}",
          //   type: items[ n ],
          //   handler: onTap,            
          // )    
          const Placeholder(),      
        );
      }
    }

    return ret;
  }
}