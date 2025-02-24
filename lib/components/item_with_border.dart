import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:client/components/base_display.dart';
import 'package:client/data/realm_object.dart';
import 'package:client/providers/theme.dart';

class ItemWithBorder extends StatelessWidget {
  ItemWithBorder(
      {super.key,
      this.item,
      this.image,
      this.color,
      this.backgroundColors,
      this.handler,
      this.width,
      this.height,
      this.padding,
      this.active = false,
      this.quantity,
      this.reflect = false});

  final _theme = ThemeProvider();
  final _logger = Logger();

  final RealmObject? item;
  final String? image;
  final bool active;
  final Function(String)? handler;
  final double? width;
  final double? height;
  final Color? color;
  final List<Color>? backgroundColors;
  final EdgeInsetsGeometry? padding;
  final String? quantity;
  final bool reflect;

  Widget buildImage(ImageProvider img) {
    _logger.t("buildImage");

    Image image = Image(
      image: img,
      fit: BoxFit.fill,
    );
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

    return SizedBox(
      height: height,
      width: width,
      child: AspectRatio(
        aspectRatio: 1,
        child: GestureDetector(
          onTap: handler != null ? () => handler!(item?.guid ?? "") : null,
          child: Stack(
            children: [
              Positioned.fill(
                child: BaseDisplay(
                  colors: backgroundColors,
                  child: Padding(
                    padding: padding ?? EdgeInsets.zero,
                    child: img != null ? buildImage(img) : const Placeholder(),
                  ),
                ), //
              ),
              Positioned.fill(
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      active
                          ? _theme.activeBorderColor
                          : (color != null
                              ? color as Color
                              : _theme.inactiveBorderColor),
                      BlendMode.modulate),
                  child: Image.asset(
                    "assets/ui/frame.png",
                    centerSlice: Rect.fromLTRB(5, 5, 6, 6),
                  ),
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
      ),
    );
  }
}
