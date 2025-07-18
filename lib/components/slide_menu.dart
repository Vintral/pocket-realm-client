import 'package:flutter/material.dart';

import 'package:client/providers/theme.dart';
import 'package:logger/logger.dart';

class SlideMenu extends StatefulWidget {
  const SlideMenu(
      {super.key,
      required this.active,
      required this.offset,
      required this.alignment,
      required this.children});

  final bool active;
  final int offset;
  final AlignmentGeometry alignment;
  final List<Widget> children;

  @override
  State<SlideMenu> createState() => _SlideMenuState();
}

class _SlideMenuState extends State<SlideMenu> {
  final _key = GlobalKey();
  final _theme = ThemeProvider();

  Size _getSize() {
    if (_key.currentContext == null) return Size.zero;
    return (_key.currentContext?.findRenderObject()! as RenderBox).size;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var offset = size.width / 5;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      top: _getSize() == Size.zero
          ? size.height
          : size.height -
              _theme.footerHeight -
              MediaQueryData.fromView(View.of(context)).padding.top -
              (widget.active ? _getSize().height : 0),
      left: widget.alignment == Alignment.centerRight
          ? null
          : widget.offset * offset,
      right: widget.alignment == Alignment.centerRight ? 0 : null,
      child: Column(
        key: _key,
        mainAxisSize: MainAxisSize.min,
        children: widget.children,
      ),
    );
  }
}
