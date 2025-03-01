import 'package:client/components/base_button.dart';
import 'package:client/components/base_display.dart';
import 'package:client/providers/theme.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Note extends StatefulWidget {
  const Note({super.key});

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  final _logger = Logger();
  final _theme = ThemeProvider();
  final _controller = TextEditingController();

  String note = "";

  @override
  void initState() {
    super.initState();

    _controller.addListener(onNoteChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(onNoteChanged);
    _controller.dispose();

    super.dispose();
  }

  onNoteChanged() {
    _logger.w("onNoteChanged: ${_controller.text}");
  }

  onSubmit() {
    _logger.w("onSubmit");
  }

  onCancel() {
    _logger.w("onCancel");
  }

  @override
  Widget build(BuildContext context) {
    return BaseDisplay(
      child: Padding(
          padding: EdgeInsets.all(_theme.gap),
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
              ),
              Row(
                children: [
                  BaseButton(
                    handler: onCancel,
                  ),
                  BaseButton(
                    handler: onSubmit,
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
