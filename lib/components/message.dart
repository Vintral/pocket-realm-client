import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:client/components/avatar.dart';
import 'package:client/components/base_display.dart';
import 'package:client/data/message.dart';
import 'package:client/providers/player.dart';
import 'package:client/providers/social.dart';
import 'package:client/providers/theme.dart';
import 'package:client/utilities.dart';

class Message extends StatelessWidget {
  Message({super.key, required this.data});

  final _logger = Logger();
  final _theme = ThemeProvider();
  final _player = PlayerProvider();
  final _provider = SocialProvider();

  final MessageData data;

  Widget buildImage(double size, bool incoming) {
    return Avatar(
        avatar: !incoming ? _provider.conversationAvatar : _player.avatar,
        size: size,
        username: !incoming ? _provider.conversationUser : _player.username,
        reflect: incoming);
  }

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    var size = _theme.width / 5;
    var incoming = data.username != _player.username;

    return BaseDisplay(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: incoming ? TextDirection.ltr : TextDirection.rtl,
        children: [
          buildImage(size, !incoming),
          SizedBox(width: _theme.gap),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(_theme.gap / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.message, style: _theme.textMedium),
                  SizedBox(height: _theme.gap / 2),
                  Text(timeSince(data.time),
                      style: _theme.textMedium
                          .copyWith(fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
