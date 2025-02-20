import 'package:client/providers/theme.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class RealmTab extends StatelessWidget {
  RealmTab(
      {super.key,
      required this.label,
      this.active = false,
      this.handler,
      this.enabled = true});

  final ThemeProvider _theme = ThemeProvider();
  final _logger = Logger();

  final void Function(String)? handler;
  final String label;
  final bool active;
  final bool enabled;

  Widget buildTab() {
    return Flexible(
      flex: 1,
      child: Center(child: Text(label, style: _theme.textMediumBold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    return Expanded(
      child: GestureDetector(
        onTap: enabled && handler != null ? () => handler!(label) : null,
        child: Stack(children: [
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                _theme.color,
                _theme.blendMode,
              ),
              child: Image.asset(
                "assets/ui/tab.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
              child: Text(label,
                  style: enabled
                      ? (active
                          ? _theme.textLarge
                              .copyWith(color: _theme.colorActiveTab)
                          : _theme.textLarge)
                      : _theme.textLarge
                          .copyWith(color: _theme.colorDisabled))),
        ]),
      ),
    );
  }
}
