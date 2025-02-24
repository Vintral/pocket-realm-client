import 'package:logger/logger.dart';

class SearchResultData {
  final Logger _logger = Logger();

  late String guid;
  late String username;
  late String avatar;
  late String classType;
  late int rank;
  late int score;
  late DateTime? lastSeen;

  SearchResultData(dynamic data) {
    guid = data["guid"] ?? "";
    username = data["username"] ?? "";
    avatar = data["avatar"] ?? "";
    rank = data["rank"] ?? 0;
    score = data["score"] ?? 0;
    classType = data["class"] ?? "";
    lastSeen = DateTime.tryParse(data["last_seen"]);

    dump();
  }

  void dump() {
    _logger.w("""====================================
GUID: $guid
Username: $username
Avatar: $avatar
Class: $classType
Rank: $rank
Score: $score
Seen: $lastSeen
====================================""");
  }
}
