import 'package:client/components/avatar.dart';
import 'package:client/components/base_display.dart';
import 'package:client/data/contact.dart';
import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:logger/logger.dart';

import 'package:client/components/item_with_border.dart';
import 'package:client/providers/theme.dart';

class Contact extends StatelessWidget {
  final Logger _logger = Logger();

  final _theme = ThemeProvider();

  final ContactData data;

  Contact(
    this.data, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    var size = MediaQuery.of(context).size.width / 5;

    return BaseDisplay(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: _theme.gap,
        children: [
          Avatar(data.avatar, "", size),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(_theme.gap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: _theme.gap,
                children: [
                  Text(data.username, style: _theme.textExtraLargeBold),
                  Text(
                    data.note,
                    style:
                        _theme.textLarge.copyWith(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
