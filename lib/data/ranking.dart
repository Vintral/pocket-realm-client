import 'package:logger/logger.dart';

class RankingData {
  final Logger _logger = Logger();

  late int rank;
  late String username;
  late String avatar;
  late int score;

  RankingData(dynamic data) {
    rank = data["rank"] ?? 0;
    username = data["username"] ?? data["name"] ?? "";
    avatar = data["avatar"];
    score = data["score"] is double
        ? (data["score"] as double).floor()
        : data["score"] as int;

    dump();
  }

  void dump() {
    _logger.t("""=================================
Rank: $rank
Username: $username
Avatar: $avatar
Score: $score
=================================""");
  }
}
