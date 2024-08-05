import 'package:client/providers/library.dart';
import 'package:logger/logger.dart';

class GatherResult {
  final Logger _logger = Logger();

  final int gain;
  final int energy;
  final String type;
  late String message;

  final LibraryProvider _library = LibraryProvider();

  GatherResult( { required this.gain, required this.energy, required this.type } ) {
    message = getMessage();
    dump();
  }

  String getMessage() {
    switch( _library.getResource( type )?.name ?? "" ) {
      case "gold": {
        switch( gain ) {
          case 0: return "Your tax collectors failed to find any gold";
          case 1: return "A tax collector found 1 gold missed in their pockets";
          default: return "Your tax collectors found $gain misplaced gold";
        }
      }
      case "food": {
        switch( gain ) {
          case 0: return "Your farmers crops were lost";
          case 1: return "A farmer found a missed 1 food";
          default: return "Your farmers harvested $gain food";
        }
      }
      case "wood": {
        switch( gain ) {
          case 0: return "Your woodchoppers couldn't find any trees";
          case 1: return "A woodchopper found a bush, chopped down it yielded 1 wood";
          default: return "Your woodchoppers chopped down trees yielding $gain wood";
        }
      }
      case "stone": {
        switch( gain ) {
          case 0: return "Your masons were unable to excavate any stone";
          case 1: return "A mason collected enough gravel to gain 1 stone";
          default: return "Your masons excavated $gain stone from the quarries";
        }
      }
      case "metal": {
        switch( gain ) {
          case 0: return "Your miners couldn't locate any ore seams";
          case 1: return "A miner found enough scrap in a bucket for 1 metal";
          default: return "Your miners had a productive shift and mined $gain metal";
        }
      }
    }

    return "---";
  }
  
  void dump() {
    _logger.t( "==================================" );
    _logger.t( "Gain: $gain" );
    _logger.t( "Energy: $energy" );
    _logger.t( "Type: $type" );
    _logger.t( "Message: $message" );
    _logger.t( "==================================" );
  }
}