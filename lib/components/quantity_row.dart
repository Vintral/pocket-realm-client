import 'package:client/components/base_button.dart';
import 'package:client/providers/theme.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class QuantityRow extends StatefulWidget {
  const QuantityRow({super.key});

  @override
  State<QuantityRow> createState() => _QuantityRowState();
}

class _QuantityRowState extends State<QuantityRow> {
  final _theme = ThemeProvider();
  final _logger = Logger(level: Level.debug);

  // int _quantity = 0;

  @override
  void initState() {
    super.initState();

    _logger.t("Created");
  }

  Widget buildButton(Widget child, {int size = 1}) {
    _logger.t("buildButton");

    return Flexible(
      flex: size,
      child: BaseButton(
        children: [child],
        handler: () {
          _logger.t("TAP TAP");
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buildButton(
            Text(
              "build X for Y",
              style: _theme.textLargeBold,
            ),
            size: 2),
        buildButton(Text("+1", style: _theme.textLarge)),
        buildButton(Text("+10", style: _theme.textLarge)),
        buildButton(Text("+100", style: _theme.textLarge)),
        buildButton(Text("X", style: _theme.textLarge)),
      ],
    );
  }
}
