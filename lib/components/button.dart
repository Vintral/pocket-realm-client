import 'package:client/components/base_button.dart';
import 'package:client/providers/theme.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Button extends StatefulWidget {
  const Button(
      {super.key,
      this.text,
      required this.handler,
      this.image,
      this.enabled = true,
      this.largeFont = false,
      this.content,
      this.busy = false});

  final Widget? content;
  final String? text;
  final void Function() handler;
  final String? image;
  final bool largeFont;
  final bool enabled;
  final bool busy;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  final Logger _logger = Logger();
  final ThemeProvider _theme = ThemeProvider();

  bool _pressed = false;

  List<Widget> buildContent(BuildContext context) {
    var size = MediaQuery.of(context).size;

    if (widget.busy) {
      return [
        SizedBox(
          width: size.width / 20,
          height: size.width / 20,
          child: CircularProgressIndicator(
            strokeWidth: _theme.gap / 5,
            color: _theme.colorText,
          ),
        ),
      ];
    }

    if (widget.content != null) {
      return [widget.content ?? Container()];
    }

    return [
      Text(widget.text ?? "",
          style:
              widget.largeFont ? _theme.textLargeBold : _theme.textMediumBold),
      if (widget.image != null) ...[
        SizedBox(
          width: size.width / 32,
          child: Image(
            image: AssetImage(widget.image ?? ""),
          ),
        ),
      ]
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BaseButton(
      handler: widget.handler,
      children: [
        Stack(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(_theme.gap),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                widget.busy || !widget.enabled
                    ? _theme.colorDisabled
                    : _theme.color,
                _theme.blendMode,
              ),
              child: Image.asset(
                "assets/ui/button-${_pressed ? "down" : "up"}.png",
              ),
            ),
          ),
          Positioned.fill(
            top: _pressed ? 5 : 0,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: buildContent(context),
            ),
          ),
        ]),
      ],
    );
  }
}
