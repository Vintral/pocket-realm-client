import 'dart:math' as math;

import 'package:client/data/realm_object.dart';
import 'package:client/providers/theme.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ItemWithBorder extends StatelessWidget {
  ItemWithBorder(
      {super.key,
      this.item,
      this.image,
      this.color,
      this.backgroundColor,
      this.handler,
      this.width,
      this.height,
      this.padding,
      this.active = false,
      this.quantity,
      this.reflect = false});

  final _theme = ThemeProvider();
  final _logger = Logger(level: Logger.level);

  final RealmObject? item;
  final String? image;
  final bool active;
  final Function(String)? handler;
  final double? width;
  final double? height;
  final Color? color;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final String? quantity;
  final bool reflect;

  Widget buildImage(ImageProvider img) {
    _logger.t("buildImage");

    Image image = Image(image: img);
    return reflect ? flipImage(image) : image;
  }

  Widget flipImage(Widget child) {
    return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(math.pi),
        child: child);
  }

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    ImageProvider? img;
    if (item != null) {
      img = AssetImage("assets/${item?.folder}/${item?.name}.png");
    } else if (image != null && image!.isNotEmpty) {
      img = AssetImage(image as String);
    }

    _logger.d("$active ::: ${color != null}");

    return SizedBox(
      width: width,
      height: height,
      child: GestureDetector(
        onTap: handler != null ? () => handler!(item?.guid ?? "") : null,
        child: Stack(
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                backgroundColor ?? _theme.color,
                _theme.blendMode,
              ),
              child: Image.asset("assets/item-background.png"),
            ),
            Padding(
              padding: padding ?? EdgeInsets.zero,
              child: img != null ? buildImage(img) : const Placeholder(),
            ),
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                  active
                      ? _theme.activeBorderColor
                      : (color != null
                          ? color as Color
                          : _theme.inactiveBorderColor),
                  BlendMode.modulate),
              child: Image.asset(
                "assets/ui/frame.png",
              ),
            ),
            quantity != null
                ? Container(
                    color: active
                        ? _theme.activeBorderColor
                        : _theme.inactiveBorderColor,
                    padding: EdgeInsets.all(_theme.quantityPadding),
                    child: Text(quantity as String, style: _theme.textSmall),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
