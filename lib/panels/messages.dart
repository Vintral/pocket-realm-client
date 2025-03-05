import 'package:client/components/conversation.dart';
import 'package:client/components/panel.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/social.dart';
import 'package:client/providers/theme.dart';
import 'package:client/states/list_panel.dart';
import 'package:eventify/eventify.dart' as eventify;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class MessagesPanel extends StatefulWidget {
  const MessagesPanel({super.key, required this.callback});

  final void Function(BuildContext) callback;

  @override
  State<MessagesPanel> createState() => _MessagesPanelState();
}

class _MessagesPanelState extends ListPanelState<MessagesPanel> {
  final Logger _logger = Logger(level: Level.off);

  final ThemeProvider _theme = ThemeProvider();
  final _provider = SocialProvider();
  late eventify.Listener _onConversationsListener;

  @override
  void initState() {
    super.initState();

    _logger.t("initState");

    _onConversationsListener =
        _provider.on("CONVERSATIONS", null, onConversations);

    if (_provider.conversations.isEmpty) {
      _provider.getConversations();
    }
  }

  @override
  void dispose() {
    _logger.t("dispose");

    _onConversationsListener.cancel();

    super.dispose();
  }

  void onConversations(e, o) {
    _logger.d("onConversations");
    setState(() {});
  }

  void onTap(String conversation) {
    _logger.d("onTap: $conversation");

    _provider.conversationMap[conversation]?.dump();

    _provider.conversationAvatar =
        _provider.conversationMap[conversation]!.avatar;
    _provider.conversationUser =
        _provider.conversationMap[conversation]!.username;
    _provider.conversationGuid = _provider.conversationMap[conversation]!.guid;

    Navigator.pushNamed(context, "conversation");
  }

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    widget.callback(context);

    _logger.d("Loaded: ${_provider.conversations.isNotEmpty}");

    return Panel(
      loaded: _provider.conversations.isNotEmpty,
      label: Dictionary.get("MESSAGES"),
      child: ListView.separated(
          itemBuilder: (context, index) => Conversation(
              data: _provider.conversations[index], handler: onTap),
          separatorBuilder: (context, index) => SizedBox(height: _theme.gap),
          itemCount: _provider.conversations.length),
    );
  }
}
