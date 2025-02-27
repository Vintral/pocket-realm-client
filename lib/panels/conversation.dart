import 'package:flutter/material.dart';

import 'package:eventify/eventify.dart' as eventify;
import 'package:logger/logger.dart';

import 'package:client/capitalize.dart';
import 'package:client/components/base_button.dart';
import 'package:client/components/message.dart';
import 'package:client/components/panel.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/social.dart';
import 'package:client/providers/theme.dart';
import 'package:client/states/list_panel.dart';

class ConversationPanel extends StatefulWidget {
  const ConversationPanel({super.key, required this.callback});

  final void Function(BuildContext) callback;

  @override
  State<ConversationPanel> createState() => _ConversationPanelState();
}

class _ConversationPanelState extends ListPanelState<ConversationPanel> {
  final Logger _logger = Logger();

  final ThemeProvider _theme = ThemeProvider();
  final _provider = SocialProvider();
  final _messageController = TextEditingController();
  late eventify.Listener _onMessagesListener;
  late eventify.Listener _onMesssageSentListener;
  late eventify.Listener _onMesssageErrorListener;

  bool _busy = false;

  @override
  void initState() {
    super.initState();

    _logger.t("initState");

    _onMessagesListener = _provider.on("MESSAGES", null, onMessages);
    _onMesssageSentListener = _provider.on("MESSAGE_SENT", null, onMessageSent);
    _onMesssageErrorListener =
        _provider.on("MESSAGE_ERROR", null, onMessageError);

    _messageController.addListener(onMessageChanged);

    _provider.getMessages();
  }

  @override
  void dispose() {
    _logger.t("dispose");

    _onMessagesListener.cancel();
    _onMesssageSentListener.cancel();
    _onMesssageErrorListener.cancel();

    super.dispose();
  }

  void onMessageChanged() {
    _logger.d("onMessageChanged");
    setState(() {});
  }

  void onMessages(e, o) {
    _logger.d("onMessages");
    setState(() {});
  }

  void onMessageSent(e, o) {
    _logger.d("onMessageSent");

    _messageController.text = "";
    _busy = false;
    _provider.getMessages();
  }

  void onMessageError(e, o) {
    _logger.d("onMessageError");

    setState(() {
      _busy = false;
    });
  }

  void onTap() {
    _logger.w("onTap: ${_messageController.text}");

    _provider.sendMessage(_messageController.text);
    setState(() {
      _busy = true;
    });
  }

  Widget buildResults() {
    _logger.d("buildResults");

    List<Widget> widgets = <Widget>[];
    for (var message in _provider.conversation?.messages ?? []) {
      widgets.add(Message(
        data: message,
      ));
      widgets.add(SizedBox(
        height: _theme.gap,
      ));
    }

    return ListView(
      children: [...widgets],
    );
  }

  Widget buildForm() {
    _logger.t("buildForm");

    _logger.w("Empty?: ${_messageController.text.isNotEmpty ? "NO" : "YES"}");

    var border = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(_theme.gap)),
        borderSide: BorderSide(
          color: _theme.color,
          width: 2,
          style: BorderStyle.solid,
        ));

    return SizedBox(
      width: _theme.width,
      child: Container(
        decoration: BoxDecoration(
          color: _theme.colorBackground,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: _theme.colorBackground,
              spreadRadius: -5.0,
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(_theme.gap),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: _theme.gap,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.zero,
                      child: Material(
                        borderRadius: BorderRadius.circular(_theme.gap / 2),
                        color: _theme.color,
                        child: TextField(
                          controller: _messageController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          maxLength: 250,
                          scrollPadding: EdgeInsets.all(_theme.gap / 4),
                          style: _theme.textLarge,
                          decoration: InputDecoration(
                            enabledBorder: border,
                            focusedBorder: border,
                            fillColor: Colors.transparent,
                            filled: true,
                            counterText: "",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: _theme.width / 5,
                child: AspectRatio(
                  aspectRatio: 1.5,
                  child: BaseButton(
                    borderRadius: BorderRadius.circular(_theme.gap * .75),
                    handler: onTap,
                    enabled: _messageController.text.isNotEmpty,
                    busy: _busy,
                    child: Text(Dictionary.get("SEND").toUpperCase(),
                        style: _theme.textLargeBold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    widget.callback(context);

    _logger.w(_provider.conversation?.username);

    return Panel(
      loaded: _provider.conversations.isNotEmpty,
      closable: true,
      form: buildForm(),
      capitalize: false,
      label:
          "${Dictionary.get("CHAT-WITH").capitalize()} ${_provider.conversation?.username ?? "--"}",
      child: buildResults(),
    );
  }
}
