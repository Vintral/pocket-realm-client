import 'package:logger/logger.dart';

class RealmObject {
  final bool _debug = false;
  final Logger _logger = Logger();

  late int order;
  late String guid;
  late String folder;  
  late String name;
  
  RealmObject( dynamic data ) {
    folder = "";
    order = data[ "order" ];
    guid = data[ "guid" ];
    name = ( data[ "name" ] as String ).toLowerCase();
  } 

  void dumpBorder() {     
    _logger.t( "====================================" );
  }

  void dump() {
    if( _debug ) {
      dumpBorder();
      _logger.t( "Order: $order" );
      _logger.t( "GUID: $guid" );
      _logger.t( "Name: $name" );
      _logger.t( "Folder: $folder" );
    }
  }
}