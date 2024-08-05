import 'package:client/components/panel.dart';
import 'package:client/providers/actions.dart';
import 'package:client/providers/library.dart';
import 'package:client/settings.dart';
import 'package:client/states/item_panel.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class RecruitPanel extends StatefulWidget {
  const RecruitPanel({super.key, required this.callback});

  final void Function(BuildContext) callback;

  @override
  State<RecruitPanel> createState() => _RecruitPanelState();
}

class _RecruitPanelState extends ItemPanelState<RecruitPanel> {
  final LibraryProvider _library = LibraryProvider();
  final ActionProvider _provider = ActionProvider();

  final Logger logger = Logger();  

  @override
  void initState() {
    super.initState();

    type = "unit";
    items = _library.units.where( ( unit ) => unit.recruitable ).toList();    
  }

  @override
  void onTap( String guid ) {
    logger.d( "onTap: $guid" );

    _provider.unit = _library.getUnit( guid );
    Navigator.pushNamed( context, "recruit-details" );
  }

  @override
  Widget build(BuildContext context) {    
    widget.callback( context );
    
    return Panel(
      label: "Recruit",
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: Settings.gap,
        mainAxisSpacing: Settings.gap,
        children: buildChildren(),
      ),
    );
  }
}

// class RecruitPanel extends StatelessWidget {
//   const RecruitPanel({super.key, this.callback });

//   final void Function(BuildContext)? callback;
//   final BuildContext _context;

//   final List<String> _units = const <String> [ "peasant", "footman", "archer", "crusader", "cavalry" ];

//   List<Widget> buildChildren() {
//     var ret = <Widget> [];

//     for( int i = 0; i < 5; i++ ) {
//       for( int n = 0; n < _units.length; n++ ) {
//         ret.add(
//           GridItem(
//             filename: "unit-${_units[ n ]}",
//             type: _units[ n ],
//             handler: onTap,            
//           )          
//         );
//       }
//     }

//     return ret;
//   }

//   void onTap( String type ) {
//     print( "onTap: $type" );

//     Navigator.pushNamed( _context, "recruit-details" );
//   }

//   @override
//   Widget build(BuildContext context) {
//     _context = context;
    
//     return Panel(
//       label: "Recruit", 
//       child: GridView.count(
//         crossAxisCount: 3,
//         children: buildChildren(),
//       ),
//     );
//   }
// }