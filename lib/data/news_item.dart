import 'package:logger/logger.dart';

class NewsItemData {
  final Logger _logger = Logger( level: Logger.level );
  
  late DateTime posted;
  late String body;
  late String title;

  NewsItemData( dynamic data ) {  
    posted = DateTime.parse( data[ "posted" ] ?? "" );
    title = data[ "title" ] ?? "";
    body = data[ "body" ] ?? "";    

    dump();    
  }
  
  void dump() {    
    _logger.t( "====================================" );
    _logger.t( "Posted: $posted" );
    _logger.t( "Title: $title" );
    _logger.t( "Body: $body" );
    _logger.t( "====================================" );
  }
}