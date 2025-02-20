import 'package:logger/logger.dart';

import 'package:client/data/message.dart';

class ConversationData {
  final Logger _logger = Logger();

  late String guid;
  late String username;
  late String characterClass;
  late String avatar;
  late DateTime lastRead;
  late DateTime updated;
  late bool reply;
  late String message;

  List<MessageData> messages = <MessageData>[];

  ConversationData(dynamic data) {
    guid = data["guid"] ?? "";
    username = data["username"] ?? "";
    avatar = data["avatar"] ?? "";

    reply = data["last_message"]["reply"];
    message = data["last_message"]["text"];

    lastRead = DateTime.parse("2024-05-02T10:23:06.75-07:00");

    lastRead = DateTime.parse(data["last_read"] ?? "");
    updated = DateTime.parse(data["updated"] ?? "");

    dump();
  }

  void dump() {
    _logger.t("""====================================
Username: $username
Avatar: $avatar
Reply: $reply
Message: $message
Last Read: $lastRead
Updated: $updated
====================================""");
  }
}
