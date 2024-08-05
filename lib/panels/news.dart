import 'package:client/components/news_item.dart';
import 'package:client/components/panel.dart';
import 'package:client/components/realm_display_object.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/application.dart';
import 'package:client/providers/theme.dart';
import 'package:client/states/list_panel.dart';
import 'package:eventify/eventify.dart' as eventify;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class NewsPanel extends StatefulWidget {
  const NewsPanel({super.key, required this.callback});

  final void Function(BuildContext) callback;

  @override
  State<NewsPanel> createState() => _NewsPanelState();
}

class _NewsPanelState extends ListPanelState<NewsPanel> {
  final Logger _logger = Logger( level: Logger.level );

  final ThemeProvider _theme = ThemeProvider();
  final _provider = ApplicationProvider();  
  late eventify.Listener _onRulesListener;

  bool showButton = true;

  @override
  void initState() {
    super.initState();

    _logger.t( "initState" );

    _onRulesListener = _provider.on( "NEWS", null, onNews );
    if( _provider.news.isEmpty ) {
      _provider.getNews();
    }
  }

  @override
  void dispose() {    
    _logger.t( "dispose" );
    _onRulesListener.cancel();

    super.dispose();
  }    

  void onNews( e, o ) {
    _logger.d( "onNews" );
    setState(() {});
  }

  Widget buildResults() {
    List<Widget> widgets = <Widget>[];
    for( int i = 0; i < _provider.news.length; i++ ) {
      widgets.add( RealmDisplayObject( canGrow: true, child: NewsItem( item: _provider.news[ i ] ), ) );
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

    _logger.d( "Loaded: ${_provider.news.isNotEmpty}" );

    return Panel(
      loaded: _provider.news.isNotEmpty,
      label: Dictionary.get( "NEWS" ),
      child: buildResults(),
    );
  }
}