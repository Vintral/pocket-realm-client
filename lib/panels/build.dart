import 'package:client/components/panel.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/actions.dart';
import 'package:client/providers/library.dart';
import 'package:client/settings.dart';
import 'package:client/states/item_panel.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class BuildPanel extends StatefulWidget {
  const BuildPanel({super.key, required this.callback});

  final void Function(BuildContext) callback;

  @override
  State<BuildPanel> createState() => _BuildPanelState();
}

class _BuildPanelState extends ItemPanelState<BuildPanel> {
  final LibraryProvider _library = LibraryProvider();
  final ActionProvider _provider = ActionProvider();

  final Logger _logger = Logger();  

  @override
  void initState() {
    super.initState();

    _logger.t( "initState" );

    type = "building";
    items = _library.buildings.where( ( building ) => building.buildable ).toList();
  }

  @override
  void onTap( String guid ) {
    _logger.d( "onTap: $guid" );

    _provider.building = _library.getBuilding( guid );
    Navigator.pushNamed( context, "build-details" );
  }

  @override
  Widget build(BuildContext context) {    
    widget.callback( context );
    
    return Panel(
      label: Dictionary.get( "BUILD" ),
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: Settings.gap,
        mainAxisSpacing: Settings.gap,
        children: buildChildren(),
      ),
    );
  }
}