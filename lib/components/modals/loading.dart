import 'package:client/components/base_display.dart';
import 'package:client/providers/theme.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  Loading({super.key, this.text = ""});

  final _theme = ThemeProvider();

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height / 10,
        maxWidth: MediaQuery.of(context).size.width / 2.5,
      ),
      child: BaseDisplay(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: _theme.gap,
              horizontal: _theme.gap * 2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: _theme.gap,
              children: [
                text.isNotEmpty
                    ? Text(text, style: _theme.textLargeBold)
                    : SizedBox.shrink(),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 40,
                  width: MediaQuery.of(context).size.height / 40,
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
