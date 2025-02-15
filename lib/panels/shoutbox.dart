import 'package:flutter/material.dart';

import 'package:eventify/eventify.dart' as eventify;
import 'package:logger/logger.dart';

import 'package:client/components/base_button.dart';
import 'package:client/components/panel.dart';
import 'package:client/components/shout.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/notification.dart';
import 'package:client/providers/social.dart';
import 'package:client/providers/theme.dart';
import 'package:client/states/list_panel.dart';

class ShoutboxPanel extends StatefulWidget {
  const ShoutboxPanel({super.key, required this.callback});

  final void Function(BuildContext) callback;

  @override
  State<ShoutboxPanel> createState() => _ShoutboxPanelState();
}

class _ShoutboxPanelState extends ListPanelState<ShoutboxPanel> {
  final Logger _logger = Logger(level: Level.debug);

  final ThemeProvider _theme = ThemeProvider();
  final _notification = NotificationProvider();
  final _provider = SocialProvider();
  late eventify.Listener _onShoutsListener;
  late eventify.Listener _onShoutSuccessListener;
  late eventify.Listener _onShoutErrorListener;
  final _shoutController = TextEditingController();

  bool showButton = true;
  bool _enabled = true;

  @override
  void initState() {
    super.initState();

    _logger.t("initState");

    _onShoutsListener = _provider.on("SHOUTS", null, onShouts);
    _onShoutSuccessListener =
        _provider.on("SHOUT_SUCCESS", null, onShoutSuccess);
    _onShoutErrorListener = _provider.on("SHOUT_ERROR", null, onShoutError);

    _provider.getShouts();
    _provider.subscribe();
  }

  @override
  void dispose() {
    _logger.t("dispose");

    _onShoutsListener.cancel();
    _onShoutSuccessListener.cancel();
    _onShoutErrorListener.cancel();

    _provider.unsubscribe();

    super.dispose();
  }

  void onShouts(e, o) {
    _logger.d("onShouts");
    setState(() {});
  }

  void onShoutSuccess(e, o) {
    _logger.d("onShoutSuccess");

    setState(() {
      _shoutController.text = "";
      _enabled = true;
    });
  }

  void onShoutError(e, o) {
    _logger.e("onShoutError");

    _notification.notifyError(Dictionary.get("shout-0"));
    setState(() {
      _enabled = true;
    });
  }

  Widget buildResults() {
    List<Widget> widgets = <Widget>[];
    //for( int i = 0; i < _provider.shouts.length; i++ ) {
    for (var shout in _provider.shouts) {
      widgets.add(Shout(
        avatar: shout.avatar,
        username: shout.username,
        time: shout.time,
        message: shout.shout,
        characterClass: shout.characterClass,
      ));
      widgets.add(SizedBox(
        height: _theme.gap,
      ));
    }

    return ListView(
      children: [...widgets],
    );
  }

  void onTap() {
    _logger.f("onTap: ${_shoutController.text}");

    _provider.sendShout(_shoutController.text);
    setState(() {
      _enabled = false;
    });
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
          padding: EdgeInsets.symmetric(
              horizontal: _theme.gap, vertical: _theme.gap / 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Card(
                      color: _theme.color,
                      child: TextField(
                        controller: _shoutController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        maxLength: 250,
                        scrollPadding: EdgeInsets.all(_theme.gap / 4),
                        style: _theme.textMedium,
                        decoration: InputDecoration(
                          enabledBorder: border,
                          focusedBorder: border,
                          fillColor: Colors.transparent,
                          filled: true,
                          counterText: "",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: _theme.gap,
              ),
              Padding(
                padding: EdgeInsets.only(top: _theme.gap / 2),
                child: SizedBox(
                  width: _theme.width / 5,
                  child: BaseButton(
                    handler: onTap,
                    enabled: _enabled,
                    child: Text(Dictionary.get("SHOUT"),
                        style: _theme.textExtraLargeBold),
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

    _logger.d("Loaded: ${_provider.shouts.isNotEmpty}");

    return Panel(
      loaded: _provider.shouts.isNotEmpty,
      form: buildForm(),
      label: Dictionary.get("SHOUTBOX"),
      child: buildResults(),
    );
  }
}
