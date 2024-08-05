import 'package:logger/logger.dart';

class RankingData {
  final Logger _logger = Logger(level: Logger.level);

  late int place;
  late String username;
  late int avatar;
  late int power;
  late int land;

  RankingData(dynamic data) {
    place = 1;
    username = data["username"] ?? "";
    avatar = data["avatar"] ?? "";
    power = data["power"] ?? 0;
    land = data["land"] ?? 0;

    dump();
  }

  void dump() {
    _logger.t("=================================");
    _logger.t("Place: $place");
    _logger.t("Username: $username");
    _logger.t("Avatar: $avatar");
    _logger.t("Power: $power");
    _logger.t("Land: $land");
    _logger.t("=================================");
  }
}
