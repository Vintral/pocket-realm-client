import 'package:flutter/material.dart';

import 'package:eventify/eventify.dart' as eventify;
import 'package:logger/logger.dart';

import 'package:client/capitalize.dart';
import 'package:client/components/base_button.dart';
import 'package:client/components/base_display.dart';
import 'package:client/components/message.dart';
import 'package:client/components/panel.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/social.dart';
import 'package:client/providers/theme.dart';
import 'package:client/states/list_panel.dart';

class SupportPanel extends StatefulWidget {
  const SupportPanel({super.key, required this.callback});

  final void Function(BuildContext) callback;

  @override
  State<SupportPanel> createState() => _SupportPanelState();
}

class _SupportPanelState extends ListPanelState<SupportPanel> {
  final Logger _logger = Logger();

  final ThemeProvider _theme = ThemeProvider();
  final _provider = SocialProvider();
  final _messageController = TextEditingController();
  late eventify.Listener _onSupportMessagesListener;
  late eventify.Listener _onSupportMesssageSentListener;

  bool _busy = false;

  @override
  void initState() {
    super.initState();

    _logger.w("initState");

    _onSupportMessagesListener = _provider.on("MESSAGES", null, onMessages);
    _onSupportMesssageSentListener =
        _provider.on("SEND_SUPPORT_MESSAGE", null, onSupportMessageSent);

    _messageController.addListener(onMessageChanged);

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _provider.getSupportMessages());
  }

  @override
  void dispose() {
    _logger.t("dispose");

    _onSupportMessagesListener.cancel();
    _onSupportMesssageSentListener.cancel();

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

  void onSupportMessageSent(e, o) {
    _logger.f("onMessageSent");

    if (e.eventData["success"]) {
      _messageController.text = "";
      _busy = false;
      _provider.getSupportMessages();
    } else {
      _logger.f("ERROR SENDING MESSAGE");
    }
  }

  void onTap() {
    _logger.w("onTap: ${_messageController.text}");

    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    _provider.sendSupportMessage(_messageController.text);
    setState(() {
      _busy = true;
    });
  }

  Widget buildContent() {
    _logger.t("buildContent");

    if (_provider.conversationMessages.isEmpty) {
      return Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: MediaQuery.of(context).size.width / 5,
          child: BaseDisplay(
            child: Center(
              child: Text(
                Dictionary.get("NO_MESSAGES").capitalize(),
                style: _theme.textLargeBold,
              ),
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      itemBuilder: (context, index) =>
          Message(data: _provider.conversationMessages[index]),
      separatorBuilder: (context, index) => SizedBox(height: _theme.gap),
      itemCount: _provider.conversationMessages.length,
    );
  }

  Widget buildForm() {
    _logger.t("buildForm");

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
    _logger.w("build");

    widget.callback(context);

    return Panel(
      // loaded: _provider.conversations.isNotEmpty,
      closable: true,
      form: buildForm(),
      capitalize: false,
      label:
          "${Dictionary.get("CONTACT_SUPPORT").split(" ").map((word) => word.capitalize()).join(" ")} ${_provider.conversationUser}",
      child: buildContent(),
    );
  }
}
