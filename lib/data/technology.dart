import 'package:logger/logger.dart';

class TechnologyData {
  final Logger _logger = Logger(level: Level.trace);

  TechnologyData(dynamic data) {
    dump();
  }

  void dump() {
    _logger.t("""====================================
====================================""");
  }
}
