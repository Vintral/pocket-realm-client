import 'package:flutter/material.dart';

import 'package:client/capitalize.dart';
import 'package:client/components/base_display.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/theme.dart';

class Loading extends StatelessWidget {
  Loading({super.key, this.text = ""});

  final _theme = ThemeProvider();

  final String text;

  @override
  Widget build(BuildContext context) {
    return BaseDisplay(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: _theme.gap * 3,
          horizontal: _theme.gap * 2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: _theme.gap,
          children: [
            text.isNotEmpty
                ? Text(Dictionary.getLoading(text).capitalize(),
                    style: _theme.textLargeBold)
                : SizedBox.shrink(),
            SizedBox(
              height: MediaQuery.of(context).size.height / 40,
              width: MediaQuery.of(context).size.height / 40,
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
