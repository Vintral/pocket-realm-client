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

    reply = data["replied"];
    message = data["message"];

    lastRead = DateTime.parse(data["last_read"] ?? "");
    updated = DateTime.parse(data["updated"] ?? "");

    dump();
  }

  void dump() {
    _logger.t("""
====================================
GUID: $guid
Username: $username
Avatar: $avatar
Reply: $reply
Message: $message
Last Read: $lastRead
Updated: $updated
====================================""");
  }
}
