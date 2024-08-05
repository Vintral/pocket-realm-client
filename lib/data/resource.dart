import 'package:client/data/realm_object.dart';
import 'package:logger/logger.dart';

class Resource extends RealmObject {
  final Logger _logger = Logger();
  
  late bool canGather;
  late bool canMarket;

  Resource( dynamic data ) : super( data ) {
    folder = "resources";

    canGather = data[ "can_gather" ];        
    canMarket = data[ "can_market" ];

    dump();
  }

  @override
  void dump() {    
    super.dump();

    _logger.t( "Gatherable: ${canGather ? "Yes" : "No"}" );
    _logger.t( "Marketable: ${canMarket ? "Yes" : "No"}" );

    dumpBorder();
  }
}