import 'package:client/capitalize.dart';
import 'package:client/components/item_with_border.dart';
import 'package:client/data/conversation.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/social.dart';
import 'package:client/providers/theme.dart';
import 'package:client/utilities.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Conversation extends StatelessWidget {
  Conversation({super.key, required this.data, this.handler});

  final _logger = Logger(level: Level.warning);
  final _theme = ThemeProvider();
  final _provider = SocialProvider();

  final ConversationData data;
  final Function(String)? handler;

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    var size = _theme.width / 5;

    Widget ret = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(
                  (_theme.gradientOpacity / 60).floor(),
                  _theme.colorAccent.red,
                  _theme.colorAccent.green,
                  _theme.colorAccent.blue),
              Color.fromARGB(_theme.gradientOpacity, _theme.color.red,
                  _theme.color.green, _theme.color.blue),
            ]),
        borderRadius: BorderRadius.all(Radius.circular(_theme.gap)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ItemWithBorder(
            image: "assets/avatars/${data.avatar}.png",
            height: size,
          ),
          SizedBox(width: _theme.gap),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(_theme.gap / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(data.username, style: _theme.textMediumBold),
                      Text(timeSince(data.updated),
                          style: _theme.textMedium
                              .copyWith(fontStyle: FontStyle.italic)),
                    ],
                  ),
                  SizedBox(height: _theme.gap / 2),
                  !data.reply
                      ? Text(data.message, style: _theme.textMedium)
                      :
                      //Text( "Replied: ${data.message}", style: _theme.styleShoutMessage ),
                      Text.rich(TextSpan(children: [
                          TextSpan(
                              text:
                                  "${Dictionary.get("REPLIED").capitalize()}: ",
                              style: _theme.textSmall
                                  .copyWith(fontStyle: FontStyle.italic)),
                          TextSpan(text: data.message, style: _theme.textSmall)
                        ])),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (handler != null) {
      ret = GestureDetector(
        onTap: () {
          _provider.conversationAvatar = data.avatar;
          handler!(data.guid);
        },
        child: ret,
      );
    }

    return ret;
  }
}
