import 'package:logger/logger.dart';

class Rule {
  static int _id = 1;

  final Logger _logger = Logger( level: Logger.level );
  late String text;
  late int number;

  Rule( dynamic data ) {  
    number = _id++;
    text = data[ "rule" ] ?? "";

    dump();    
  }
  
  void dump() {    
    _logger.t( "====================================" );
    _logger.t( "Number: $number" );
    _logger.t( "Text: $text" );
    _logger.t( "====================================" );
  }
}