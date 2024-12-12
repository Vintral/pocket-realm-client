import 'package:client/providers/theme.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class BaseButton extends StatefulWidget {
  const BaseButton(
      {super.key,
      this.padding = EdgeInsets.zero,
      this.enabled = true,
      this.busy = false,
      this.borderRadius = BorderRadius.zero,
      required this.handler,
      this.children = const <Widget>[]});

  @protected
  final void Function() handler;

  final bool enabled;
  final bool busy;
  final EdgeInsets padding;
  final List<Widget> children;
  final BorderRadius borderRadius;

  @override
  State<BaseButton> createState() => _BaseButtonState();
}

class _BaseButtonState extends State<BaseButton> {
  final _logger = Logger();
  final _theme = ThemeProvider();

  bool _pressed = false;

  void onTapDown(TapDownDetails details) {
    if (!widget.enabled || widget.busy) return;

    _logger.d("onTapDown");

    setState(() {
      _pressed = true;
    });
  }

  void onTapUp(TapUpDetails details) {
    if (!widget.enabled || widget.busy) return;

    _logger.d("onTapUp");

    setState(() {
      _pressed = false;
      widget.handler();
    });
  }

  void onTapCancel() {
    if (!widget.enabled || widget.busy) return;

    _logger.d("onTapCancel");

    setState(() {
      _pressed = false;
    });
  }

  Widget handleBorderRadius() {
    Widget background = ColorFiltered(
      colorFilter: ColorFilter.mode(
        widget.busy || !widget.enabled ? _theme.colorDisabled : _theme.color,
        _theme.blendMode,
      ),
      child: Image.asset(
        "assets/ui/button-${_pressed ? "down" : "up"}.png",
        fit: BoxFit.fill,
      ),
    );

    if (widget.borderRadius != BorderRadius.zero) {
      background = ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: background,
      );
    }

    return Positioned.fill(
      child: background,
    );
  }

  List<Widget> handleChildren() {
    return [
      Positioned.fill(
        top: _pressed ? _theme.gap / 2 : 0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.children,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var children = [handleBorderRadius(), ...handleChildren()];

    return Container(
        // color: Colors.yellow,
        child: GestureDetector(
            onTapDown: onTapDown,
            onTapUp: onTapUp,
            onTapCancel: onTapCancel,
            child: Stack(
              children: children,
            )));
  }
}
