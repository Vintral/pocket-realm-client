import 'package:flutter/material.dart';

import 'package:client/components/base_button.dart';
import 'package:client/providers/theme.dart';
import 'package:logger/logger.dart';

class CostButton extends StatefulWidget {
  const CostButton(
      {super.key,
      this.text,
      required this.handler,
      this.image,
      this.enabled = true,
      this.height,
      this.borderRadius = BorderRadius.zero,
      this.busy = false});

  final void Function() handler;
  final BorderRadius borderRadius;
  final String? text;
  final String? image;
  final double? height;
  final bool enabled;
  final bool busy;

  @override
  State<CostButton> createState() => _CostButtonState();
}

class _CostButtonState extends State<CostButton> {
  final _logger = Logger();
  final _theme = ThemeProvider();

  Widget buildContent(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(widget.text ?? "", style: _theme.textLargeBold),
        SizedBox(
          width: size.width / 32,
          child: Image(
            image: AssetImage(widget.image ?? ""),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _logger.w("build");

    return SizedBox(
      height: widget.height ?? MediaQuery.of(context).size.height / 20,
      child: BaseButton(
        handler: widget.handler,
        borderRadius: widget.borderRadius,
        busy: widget.busy,
        child: buildContent(context),
      ),
    );
  }
}
