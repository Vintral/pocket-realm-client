import 'package:logger/logger.dart';

class ContactData {
  final Logger _logger = Logger(level: Level.debug);

  late String avatar;
  late String username;
  late String guid;
  late String note;
  late String category;

  ContactData(dynamic data) {
    category = data["category"] ?? "";
    username = data["username"] ?? data["name"] ?? "";
    avatar = data["avatar"] ?? "";
    guid = data["guid"] ?? "";
    note = data["note"] ?? "";

    dump();
  }

  void dump() {
    _logger.t("""=================================
Username: $username
Avatar: $avatar
Guid: $guid
Note: $note
Category: $category
=================================""");
  }
}
