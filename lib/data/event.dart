import 'package:logger/logger.dart';

class EventData {
  final Logger _logger = Logger();

  late String round;
  late String message;
  late String guid;
  late bool seen;
  late DateTime time;

  EventData(dynamic data) {
    time = DateTime.parse(data["time"]);
    message = data["event"] ?? "";
    round = data["round"] ?? "";
    seen = data["seen"] ?? "";
    guid = data["guid"] ?? "";

    dump();
  }

  void dump() {
    _logger.t("""
====================================
GUID: $guid
Message: $message
Round: $round
Seen: $seen
time: $time
====================================""");
  }
}
