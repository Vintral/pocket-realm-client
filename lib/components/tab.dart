import 'package:client/providers/theme.dart';
import 'package:flutter/material.dart';

class RealmTab extends StatelessWidget {
  RealmTab(
      {super.key,
      required this.label,
      this.active = false,
      this.handler,
      this.enabled = true});

  final ThemeProvider _theme = ThemeProvider();

  final void Function(String)? handler;
  final String label;
  final bool active;
  final bool enabled;

  Widget buildTab() {
    return Expanded(
      child: Center(child: Text(label, style: _theme.textMediumBold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // if( handler != null ) {
    //   return GestureDetector(
    //     //onTap: () => handler!( label ),
    //     child: buildTab(),
    //   );
    // }

    //return buildTab();

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
                      ? (active ? _theme.textMediumBold : _theme.textMedium)
                      : _theme.textMedium
                          .copyWith(color: _theme.colorDisabled))),
        ]),
      ),
    );
  }
}
