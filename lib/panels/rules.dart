import 'package:client/components/panel.dart';
import 'package:client/components/realm_display_object.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/application.dart';
import 'package:client/providers/theme.dart';
import 'package:client/states/list_panel.dart';
import 'package:eventify/eventify.dart' as eventify;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class RulesPanel extends StatefulWidget {
  const RulesPanel({super.key, required this.callback});

  final void Function(BuildContext) callback;

  @override
  State<RulesPanel> createState() => _RulesPanelState();
}

class _RulesPanelState extends ListPanelState<RulesPanel> {
  final Logger _logger = Logger( level: Logger.level );

  final ThemeProvider _theme = ThemeProvider();
  final _provider = ApplicationProvider();  
  late eventify.Listener _onRulesListener;

  bool showButton = true;

  @override
  void initState() {
    super.initState();

    _logger.t( "initState" );

    _onRulesListener = _provider.on( "RULES", null, onRules );
    if( _provider.rules.isEmpty ) {
      _provider.getRules();
    }
  }

  @override
  void dispose() {    
    _logger.t( "dispose" );
    _onRulesListener.cancel();

    super.dispose();
  }    

  void onRules( e, o ) {
    _logger.d( "onRules" );
    setState(() {});
  }

  Widget buildResults() {
    List<Widget> widgets = <Widget>[];
    for( int i = 0; i < _provider.rules.length; i++ ) {
      widgets.add( RealmDisplayObject( message: Dictionary.get( _provider.rules[ i ].text ) ) );
      widgets.add( SizedBox( height: _theme.gap, ) );
    }

    return ListView(
      children: [
        ...widgets
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _logger.t( "build" );
    
    widget.callback( context );

    _logger.d( "Loaded: ${_provider.rules.isNotEmpty}" );

    return Panel(
      loaded: _provider.rules.isNotEmpty,
      label: Dictionary.get( "RULES" ),
      child: buildResults(),
    );
  }
}