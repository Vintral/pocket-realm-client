import 'package:client/capitalize.dart';
import 'package:client/components/base_display.dart';
import 'package:client/components/search_result.dart';
import 'package:flutter/material.dart';

import 'package:eventify/eventify.dart' as eventify;
import 'package:logger/logger.dart';

import 'package:client/components/base_button.dart';
import 'package:client/components/panel.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/social.dart';
import 'package:client/providers/theme.dart';
import 'package:client/states/list_panel.dart';

class SearchPanel extends StatefulWidget {
  const SearchPanel({super.key, required this.callback});

  final void Function(BuildContext) callback;

  @override
  State<SearchPanel> createState() => _SearchPanelState();
}

class _SearchPanelState extends ListPanelState<SearchPanel> {
  final Logger _logger = Logger(level: Level.trace);

  final _theme = ThemeProvider();
  final _provider = SocialProvider();

  final _controller = TextEditingController();
  late eventify.Listener _onSearchResults;

  @override
  void initState() {
    super.initState();

    _logger.t("initState");

    _onSearchResults = _provider.on("SEARCH_RESULTS", null, onSearchResults);

    _controller.text = _provider.searchNeedle;
    _controller.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    _logger.t("dispose");

    _onSearchResults.cancel();

    super.dispose();
  }

  void onSearchChanged() {
    _logger.d("onSearchChanged");
    setState(() {});
  }

  void onSearchResults(e, o) {
    _logger.d("onSearchResults");
    setState(() {});
  }

  void onTap() {
    _logger.i("onTap: ${_controller.text}");

    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    _provider.searchUsers(_controller.text);
    setState(() {});
  }

  Widget buildForm() {
    _logger.t("buildForm: ${_controller.text.isNotEmpty}");

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
                          controller: _controller,
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
                    enabled: _controller.text.isNotEmpty,
                    busy: _provider.busy,
                    child: Text(Dictionary.get("SEARCH").toUpperCase(),
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

  Widget buildResults() {
    if (_provider.searchResults.isEmpty) {
      return Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: MediaQuery.of(context).size.width / 5,
          child: BaseDisplay(
            child: Center(
              child: Text(
                Dictionary.get("NO_USERS").capitalize(),
                style: _theme.textLargeBold,
              ),
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      itemBuilder: (context, index) =>
          SearchResult(_provider.searchResults[index]),
      separatorBuilder: (context, index) => SizedBox(height: _theme.gap),
      itemCount: _provider.searchResults.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    _logger.t("build: ${_provider.busy}");

    widget.callback(context);

    return Panel(
      loaded: !_provider.busy,
      form: buildForm(),
      label: Dictionary.get("SEARCH_USERS"),
      child: buildResults(),
    );
  }
}
