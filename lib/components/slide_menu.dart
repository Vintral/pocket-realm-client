import 'package:flutter/material.dart';

class SlideMenu extends StatefulWidget {  
  const SlideMenu({super.key, required this.active, required this.offset, required this.alignment, required this.children});

  final bool active;
  final int offset;
  final AlignmentGeometry alignment;
  final List<Widget> children;
  
  @override
  State<SlideMenu> createState() => _SlideMenuState();
}

class _SlideMenuState extends State<SlideMenu> {
  final _key = GlobalKey();
  bool shown = false;

  Size _getSize() {
    if( _key.currentContext == null ) return Size.zero;
    return ( _key.currentContext?.findRenderObject()! as RenderBox ).size;    
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of( context ).size;
    var offset = size.width / 5;
    shown = shown || widget.active;    

    var padding = MediaQuery.of(context).padding.top;

    return Offstage(
      offstage: !shown,
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            top: size.height - offset * 1.25 - ( widget.active ? _getSize().height - padding : 0 ),
            left: widget.alignment == Alignment.centerRight ? null : widget.offset * offset,
            right: widget.alignment == Alignment.centerRight ? 0 : null,
            child: Column(
              key: _key,
              mainAxisSize: MainAxisSize.min,    
              children: widget.children,
            ),
          ),
        ]
      ),
    );
  }
}