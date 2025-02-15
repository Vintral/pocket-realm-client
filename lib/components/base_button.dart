import 'package:client/providers/theme.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class BaseButton extends StatefulWidget {
  const BaseButton({
    super.key,
    this.padding = EdgeInsets.zero,
    this.enabled = true,
    this.busy = false,
    this.borderRadius = BorderRadius.zero,
    required this.handler,
    this.children = const <Widget>[],
    this.child,
  });

  final void Function() handler;

  final bool enabled;
  final bool busy;
  final EdgeInsets padding;
  final Widget? child;
  final List<Widget> children;
  final BorderRadius borderRadius;

  @override
  State<BaseButton> createState() => BaseButtonState();
}

class BaseButtonState extends State<BaseButton> {
  @protected
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

  List<Widget> handleChild() {
    Widget? child = widget.busy
        ? Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 20,
              height: MediaQuery.of(context).size.width / 20,
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.errorContainer,
                strokeWidth: MediaQuery.of(context).size.width / 200,
              ),
            ),
          )
        : null;

    child ??= widget.child;
    child ??= Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.children,
    );

    return [
      Positioned.fill(
        top: _pressed ? _theme.gap / 2 : 0,
        bottom: _pressed ? -_theme.gap / 2 : 0,
        child: child,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var children = [handleBorderRadius(), ...handleChild()];

    return GestureDetector(
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      child: Stack(
        children: children,
      ),
    );
  }
}
