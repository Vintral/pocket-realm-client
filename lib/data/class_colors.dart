import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

class ClassColors {
  final Logger _logger = Logger(level: Level.off);

  final alpha = 50;
  final accent = 50;
  final gradientOpacity = 100;

  late Color color;
  late BlendMode blendMode;
  late Color shadowColor;
  late Color colorAccent;
  late Color colorActiveTab;
  late Color colorDisabled;
  late Color activeBorderColor;
  late Color inactiveBorderColor;
  late Color colorBackground;
  late Color colorBackgroundGradiantLight;
  late Color colorBackgroundGradiantDark;
  late Color colorText;
  late Color? gradient1;
  late Color? gradient2;

  static ClassColors forClass(String c) {
    var colors = ClassColors(base: Colors.white);

    colors.shadowColor = Colors.pinkAccent;
    colors.colorAccent = Colors.greenAccent;
    colors.activeBorderColor = Colors.yellowAccent;
    colors.inactiveBorderColor = Colors.purpleAccent;
    colors.colorDisabled = Colors.deepPurpleAccent;
    colors.colorText = Colors.deepOrange;

    switch (c) {
      case "mage":
        {
          colors.colorText = Colors.white70;
          colors.blendMode = BlendMode.color;
          colors.color = const Color.fromARGB(255, 30, 136, 229);
          colors.colorBackground = const Color.fromARGB(255, 10, 51, 113);
          colors.colorBackgroundGradiantLight =
              const Color.fromARGB(255, 22, 100, 168);
          colors.colorBackgroundGradiantDark =
              const Color.fromARGB(255, 12, 62, 106);
          colors.colorActiveTab = const Color.fromARGB(255, 255, 255, 0);
        }
        break;
    }

    return colors;
  }

  ClassColors({required Color base, BlendMode mode = BlendMode.modulate}) {
    color = base;
    blendMode = mode;
    shadowColor = color == Colors.white
        ? Color.fromARGB(gradientOpacity, 0, 0, 0)
        : Color.fromARGB(gradientOpacity, 255, 255, 255);

    colorAccent = Color.fromARGB(
        255,
        math.min(color.r.toInt() + accent, 255),
        math.min(color.g.toInt() + accent, 255),
        math.min(color.b.toInt() + accent, 255));
    activeBorderColor =
        Color.fromARGB(255, color.r.toInt(), color.g.toInt(), color.b.toInt());
    inactiveBorderColor = Color.fromARGB(
        alpha, color.r.toInt(), color.g.toInt(), color.b.toInt());
    colorDisabled = Color.fromARGB(255, (color.r * .7).floor(),
        (color.g * .7).floor(), (color.b * .7).floor());
    colorBackground = Color.fromARGB(
        alpha, color.r.toInt(), color.g.toInt(), color.b.toInt());

    colorText = color == Colors.white
        ? const Color.fromARGB(255, 0, 0, 0)
        : const Color.fromARGB(255, 255, 255, 255);

    dump();
  }

  void dump() {
    _logger.t("====================================");
    _logger.t("Color: $color");
    _logger.t("Blend Mode: $blendMode");
    _logger.t("Shadow Color: $shadowColor");
    _logger.t("Accent Color: $colorAccent");
    _logger.t("Active Border Color: $activeBorderColor");
    _logger.t("Inactive Border Color: $inactiveBorderColor");
    _logger.t("Background Color: $colorBackground");
    _logger.t("Disabled Color: $colorDisabled");
    _logger.t("Text Color: $colorText");
    _logger.t("====================================");
  }
}
