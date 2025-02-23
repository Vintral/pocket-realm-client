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
  final Logger _logger = Logger();

  final _theme = ThemeProvider();
  final _notification = NotificationProvider();
  final _provider = SocialProvider();

  late eventify.Listener _onShoutsListener;
  late eventify.Listener _onShoutSuccessListener;
  late eventify.Listener _onShoutErrorListener;

  final _shoutController = TextEditingController();

  bool _busy = false;

  @override
  void initState() {
    super.initState();

    _logger.t("initState");

    _onShoutsListener = _provider.on("SHOUTS", null, onShouts);
    _onShoutSuccessListener =
        _provider.on("SHOUT_SUCCESS", null, onShoutSuccess);
    _onShoutErrorListener = _provider.on("SHOUT_ERROR", null, onShoutError);

    _shoutController.addListener(onShoutChanged);

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

  void onShoutChanged() {
    _logger.d("onShoutChanged");
    setState(() {});
  }

  void onShouts(e, o) {
    _logger.d("onShouts");
    setState(() {});
  }

  void onShoutSuccess(e, o) {
    _logger.d("onShoutSuccess");

    setState(() {
      _shoutController.text = "";
      _busy = false;
    });
  }

  void onShoutError(e, o) {
    _logger.e("onShoutError");

    _notification.notifyError(Dictionary.get("shout-0"));
    setState(() {
      _busy = false;
    });
  }

  void onTap() {
    _logger.i("onTap: ${_shoutController.text}");

    // _shoutController.
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    _provider.sendShout(_shoutController.text);
    setState(() {
      _busy = true;
    });
  }

  Widget buildForm() {
    _logger.t("buildForm: ${_shoutController.text.isNotEmpty}");

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
                          controller: _shoutController,
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
                    enabled: _shoutController.text.isNotEmpty,
                    busy: _busy,
                    child: Text(Dictionary.get("SHOUT").toUpperCase(),
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

    return Panel(
      loaded: _provider.shouts.isNotEmpty,
      form: buildForm(),
      label: Dictionary.get("SHOUTBOX"),
      child: ListView.separated(
        itemBuilder: (context, index) => Shout(_provider.shouts[index]),
        separatorBuilder: (context, index) => SizedBox(height: _theme.gap),
        itemCount: _provider.shouts.length,
      ),
    );
  }
}
