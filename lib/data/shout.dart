import 'package:logger/logger.dart';

class ShoutData {
  final Logger _logger = Logger();

  late String username;
  late String avatar;
  late String characterClass;
  late String shout;
  late DateTime time;

  ShoutData(dynamic data) {
    time = DateTime.parse(data["created_at"] ?? (data["time"] ?? ""));
    username = data["username"] ?? "";
    characterClass = data["character_class"] ?? "";
    avatar = data["avatar"] ?? "";
    shout = data["shout"] ?? "";

    dump();
  }

  void dump() {
    _logger.t("""====================================
Username: $username
Avatar: $avatar
Class: $characterClass
Shout: $shout
Time: $time
====================================""");
  }
}
