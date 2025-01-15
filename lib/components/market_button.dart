import 'package:flutter/material.dart';

import 'package:client/components/base_button.dart';
import 'package:client/data/resource.dart';
import 'package:client/settings.dart';
import 'package:logger/logger.dart';

class MarketButton extends StatefulWidget {
  const MarketButton({
    super.key,
    required this.handler,
    this.borderRadius = BorderRadius.zero,
    this.topAmount = 0,
    this.topResource,
    this.bottomAmount = 0,
    this.bottomResource,
    this.busy = false,
  });

  final int topAmount;
  final Resource? topResource;
  final int bottomAmount;
  final Resource? bottomResource;
  final void Function() handler;
  final BorderRadius borderRadius;
  final bool busy;

  @override
  State<MarketButton> createState() => _MarketButtonState();
}

class _MarketButtonState extends State<MarketButton> {
  final _logger = Logger();

  Widget getImage(Resource? resource) {
    _logger.t("getImage");

    var size = MediaQuery.of(context).size.width / 30;
    return Image.asset(
      resource != null
          ? "assets/${resource.folder}/${resource.name}.png"
          : "assets/none.png",
      width: size,
      height: size,
    );
  }

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize:
              (Theme.of(context).textTheme.bodySmall?.fontSize ?? 0) * 1.25,
        );

    return BaseButton(
      handler: widget.handler,
      busy: widget.busy,
      borderRadius: widget.borderRadius,
      child: Padding(
        padding: EdgeInsets.all(Settings.gap / 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.topAmount.toString(),
                  style: style,
                ),
                SizedBox(
                  width: Settings.gap / 3,
                ),
                getImage(widget.topResource),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  widget.bottomAmount.toString(),
                  style: style,
                ),
                SizedBox(
                  width: Settings.gap / 3,
                ),
                getImage(widget.bottomResource),
              ],
            ),
          ],
        ),
      ),
    );

    // return BaseButton(
    //   handler: widget.handler,
    //   borderRadius: widget.borderRadius,
    //   child: Stack(
    //     children: [
    //       Positioned(
    //         left: Settings.gap / 2,
    //         top: Settings.gap / 2,
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           children: [
    //             Text(
    //               widget.topAmount.toString(),
    //               style: style,
    //             ),
    //             getImage(widget.topResource),
    //           ],
    //         ),
    //       ),
    //       Positioned(
    //         right: Settings.gap / 2,
    //         bottom: Settings.gap / 2,
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.end,
    //           children: [
    //             Text(
    //               widget.bottomAmount.toString(),
    //               style: style,
    //             ),
    //             getImage(widget.bottomResource),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
