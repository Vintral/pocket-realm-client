import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:client/capitalize.dart';
import 'package:client/components/base_button.dart';
import 'package:client/components/base_display.dart';
import 'package:client/components/title_bar.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/modal.dart';
import 'package:client/providers/social.dart';
import 'package:client/providers/theme.dart';
import 'package:client/utilities.dart';

class Note extends StatefulWidget {
  const Note({super.key, required this.category});

  final String category;

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  final _logger = Logger();
  final _theme = ThemeProvider();
  final _modals = ModalProvider();
  final _provider = SocialProvider();
  final _controller = TextEditingController();

  final FocusNode _focus = FocusNode();
  String note = "";

  @override
  void initState() {
    super.initState();

    _controller.addListener(onNoteChanged);

    _focus.requestFocus();
  }

  @override
  void dispose() {
    _controller.removeListener(onNoteChanged);
    _controller.dispose();

    _focus.dispose();

    super.dispose();
  }

  onNoteChanged() {
    _logger.w("onNoteChanged: ${_controller.text}");
    setState(() {});
  }

  onSubmit() {
    _logger.w("onSubmit");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      constraints: BoxConstraints(
        minHeight: 0,
        maxHeight: MediaQuery.of(context).size.width * .85,
        maxWidth: MediaQuery.of(context).size.width * .85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TitleBar(
            text: "TITLE",
            child: getCloseButton(
              context,
              handler: () => _modals.popModal(),
            ),
          ),
          BaseDisplay(
            child: Padding(
              padding: EdgeInsets.all(_theme.gap),
              child: Row(
                spacing: _theme.gap,
                children: [
                  Expanded(
                    child: Material(
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: Dictionary.get("OPTIONAL").capitalize(),
                          contentPadding: EdgeInsets.all(_theme.gap),
                        ),
                        focusNode: _focus,
                        controller: _controller,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                    width: 100,
                    child: BaseButton(
                      handler: onSubmit,
                      borderRadius: BorderRadius.circular(_theme.gap / 2),
                      child: Text(
                          Dictionary.get(
                            _controller.text.isEmpty ? "SKIP" : "OKAY",
                          ).toUpperCase(),
                          style: _theme.textLargeBold),
                    ),
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
