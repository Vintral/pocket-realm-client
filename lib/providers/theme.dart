import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:eventify/eventify.dart';
import 'package:logger/logger.dart';

import 'package:client/data/class_colors.dart';
import 'package:client/settings.dart';

class ThemeProvider extends EventEmitter {
  static final ThemeProvider _instance = ThemeProvider._internal();

  factory ThemeProvider() {
    return _instance;
  }

  final Logger _logger = Logger(level: Logger.level);

  int animationSpeed = 300;

  late ThemeData activeTheme;

  double width = 0.0;
  double height = 0.0;

  Color disabledColor = Colors.grey;

  double gap = 10.0;

  double headerHeight = 0.0;
  double headerDrawerBackground = 0.0;
  double headerDrawerCap = 0.0;

  double quantityPadding = 2.0;

  int gradientOpacity = 200;

  Color color = const Color.fromARGB(200, 0, 0, 0);
  Color colorAccent = const Color.fromARGB(200, 0, 0, 0);
  Color colorActiveTab = const Color.fromARGB(200, 0, 0, 0);
  Color colorBackground = const Color.fromARGB(200, 0, 0, 0);
  Color colorDisabled = const Color.fromARGB(200, 0, 0, 0);
  Color colorBackgroundGradiantDark = const Color.fromARGB(200, 0, 0, 0);
  Color colorBackgroundGradiantLight = const Color.fromARGB(200, 0, 0, 0);
  Color colorText = Colors.white;
  BlendMode blendMode = BlendMode.darken;

  Color shadowColor = const Color.fromARGB(
    200,
    0,
    0,
    0,
  );
  Color inactiveBorderColor = const Color.fromARGB(255, 127, 127, 127);
  Color activeBorderColor = const Color.fromARGB(255, 255, 255, 0);

  final Map<String, ClassColors> _classColorsMap = HashMap();
  Map<String, ClassColors> get classColorsMap => _classColorsMap;

  static const baseFontSize = 10.0;

  late TextStyle textBase;

  late TextStyle textSmall;
  late TextStyle textMedium;
  late TextStyle textLarge;
  late TextStyle textExtraLarge;

  late TextStyle textSmallBold;
  late TextStyle textMediumBold;
  late TextStyle textLargeBold;
  late TextStyle textExtraLargeBold;

  late BoxShadow boxShadow;

  late RadialGradient gradient;

  // late TextStyle styleMissing;
  // late TextStyle resultStyle;
  // late TextStyle styleHeader;
  // late TextStyle headerStatStyle;
  // late TextStyle headerStatStyleLarge;
  // late TextStyle styleTab;
  // late TextStyle styleActiveTab;
  // late TextStyle styleDisabledTab;
  // late TextStyle styleQuantitySmall;
  // late TextStyle styleNewsTitle;
  // late TextStyle styleNewsPosted;
  // late TextStyle styleNewsBody;
  // late TextStyle styleShoutUsername;
  // late TextStyle styleShoutDate;
  // late TextStyle styleShoutMessage;
  // late TextStyle styleTextInput;
  // late TextStyle styleConversationMessage;
  // late TextStyle styleConversationReplied;
  // late TextStyle styleConversationRepliedMessage;
  // late TextStyle styleRankingRank;
  // late TextStyle styleRankingName;
  // late TextStyle styleRankingStat;

  ThemeProvider._internal() {
    _logger.d('Created');

    initialize();
    activeTheme = setTheme("mage");
  }

  initialize() {
    _logger.d("initialize");

    _classColorsMap["druid"] = ClassColors(base: Colors.green);
    _classColorsMap["merchant"] = ClassColors(base: Colors.yellow);
    _classColorsMap["mage"] = ClassColors.forClass("mage");
    _classColorsMap["priest"] = ClassColors(base: Colors.white);
    _classColorsMap["warlord"] = ClassColors(base: Colors.red);
    _classColorsMap["necromancer"] = ClassColors(base: Colors.blueGrey);
    _classColorsMap[""] =
        ClassColors(base: const Color.fromARGB(255, 75, 75, 75));

    boxShadow = BoxShadow(
      color: shadowColor.withAlpha(200),
      blurRadius: Settings.gap * 3,
      spreadRadius: -Settings.gap * 2,
      blurStyle: BlurStyle.outer,
    );
  }

  setTextStyles(Color color) {
    _logger.d("setTextStyles");

    textBase = TextStyle(
      fontSize: baseFontSize,
      decoration: TextDecoration.none,
      color: color,
    );

    textSmall = textBase.copyWith(fontSize: baseFontSize * 0.8);
    textMedium = textBase;
    textLarge = textBase.copyWith(
      fontSize: baseFontSize * 1.4,
    );
    textExtraLarge = textBase.copyWith(
      fontSize: baseFontSize * 1.8,
    );

    const fontWeight = FontWeight.bold;
    textSmallBold = textSmall.copyWith(fontWeight: fontWeight);
    textMediumBold = textMedium.copyWith(fontWeight: fontWeight);
    textLargeBold = textLarge.copyWith(fontWeight: fontWeight);
    textExtraLargeBold = textExtraLarge.copyWith(fontWeight: fontWeight);

    // styleMissing = const TextStyle(
    //     fontSize: baseFontSize * 2,
    //     fontWeight: FontWeight.bold,
    //     fontStyle: FontStyle.italic,
    //     color: Color.fromARGB(255, 255, 0, 255));

    // resultStyle = TextStyle(
    //   fontSize: baseFontSize * 1.4,
    //   fontWeight: FontWeight.normal,
    //   decoration: TextDecoration.none,
    //   color: color,
    // );
    // styleHeader = TextStyle(
    //   fontSize: baseFontSize * 1.8,
    //   fontWeight: FontWeight.normal,
    //   decoration: TextDecoration.none,
    //   color: color,
    // );
    // headerStatStyle = TextStyle(
    //   fontSize: baseFontSize,
    //   fontWeight: FontWeight.normal,
    //   decoration: TextDecoration.none,
    //   color: color,
    // );
    // headerStatStyleLarge = TextStyle(
    //   fontSize: baseFontSize * 1.6,
    //   fontWeight: FontWeight.normal,
    //   decoration: TextDecoration.none,
    //   color: color,
    // );
    // styleTab = TextStyle(
    //   fontSize: baseFontSize * 1.8,
    //   fontWeight: FontWeight.bold,
    //   decoration: TextDecoration.none,
    //   color: color,
    // );
    // styleActiveTab = const TextStyle(
    //     fontSize: baseFontSize * 1.8,
    //     fontWeight: FontWeight.bold,
    //     decoration: TextDecoration.none,
    //     color: Colors.yellow,
    //     shadows: [
    //       Shadow(color: Colors.black, blurRadius: 15, offset: Offset(5, 5))
    //     ]);
    // styleDisabledTab = const TextStyle(
    //     fontSize: baseFontSize * 1.8,
    //     fontWeight: FontWeight.bold,
    //     decoration: TextDecoration.none,
    //     color: Color.fromARGB(255, 200, 200, 200),
    //     shadows: [Shadow(color: Colors.black, blurRadius: 5)]);
    // styleQuantitySmall = TextStyle(
    //   fontSize: baseFontSize,
    //   fontWeight: FontWeight.bold,
    //   decoration: TextDecoration.none,
    //   color: color,
    // );
    // styleNewsTitle = TextStyle(
    //   fontSize: baseFontSize * 1.8,
    //   fontWeight: FontWeight.bold,
    //   decoration: TextDecoration.none,
    //   color: color,
    // );
    // styleNewsPosted = const TextStyle(
    //   fontSize: baseFontSize,
    //   fontWeight: FontWeight.bold,
    //   decoration: TextDecoration.none,
    //   color: Colors.grey,
    // );
    // styleNewsBody = TextStyle(
    //   fontSize: baseFontSize,
    //   fontWeight: FontWeight.bold,
    //   decoration: TextDecoration.none,
    //   color: color,
    // );
    // styleShoutUsername = TextStyle(
    //   fontSize: baseFontSize * 1.2,
    //   fontWeight: FontWeight.bold,
    //   decoration: TextDecoration.none,
    //   color: color,
    // );
    // styleShoutDate = const TextStyle(
    //   fontSize: baseFontSize,
    //   fontWeight: FontWeight.bold,
    //   decoration: TextDecoration.none,
    //   color: Colors.grey,
    // );
    // styleShoutMessage = TextStyle(
    //   fontSize: baseFontSize,
    //   fontWeight: FontWeight.normal,
    //   decoration: TextDecoration.none,
    //   color: color,
    // );
    // styleTextInput = TextStyle(
    //   fontSize: baseFontSize,
    //   fontWeight: FontWeight.normal,
    //   decoration: TextDecoration.none,
    //   color: color,
    // );
    // styleConversationMessage = TextStyle(
    //   fontSize: baseFontSize,
    //   fontWeight: FontWeight.normal,
    //   decoration: TextDecoration.none,
    //   color: color,
    // );
    // styleConversationReplied = const TextStyle(
    //   fontSize: baseFontSize,
    //   fontWeight: FontWeight.bold,
    //   decoration: TextDecoration.none,
    //   color: Color.fromARGB(210, 255, 255, 255),
    // );
    // styleConversationRepliedMessage = const TextStyle(
    //   fontSize: baseFontSize,
    //   fontWeight: FontWeight.normal,
    //   fontStyle: FontStyle.italic,
    //   decoration: TextDecoration.none,
    //   color: Color.fromARGB(179, 255, 255, 255),
    // );

    // styleRankingRank = const TextStyle(
    //   fontSize: baseFontSize * 1.8,
    //   fontWeight: FontWeight.bold,
    //   decoration: TextDecoration.none,
    //   color: Color.fromARGB(255, 200, 200, 200),
    // );
    // styleRankingName = const TextStyle(
    //   fontSize: baseFontSize * 1.6,
    //   fontWeight: FontWeight.bold,
    //   decoration: TextDecoration.none,
    //   color: Color.fromARGB(255, 200, 200, 200),
    // );
    // styleRankingStat = const TextStyle(
    //   fontSize: baseFontSize * 1.6,
    //   decoration: TextDecoration.none,
    //   color: Color.fromARGB(255, 200, 200, 200),
    // );
  }

  setTheme(String type) {
    _logger.d("setTheme: $type");

    var classColors = _classColorsMap[type];

    color = classColors?.color ?? Colors.transparent;
    blendMode = classColors?.blendMode ?? BlendMode.modulate;
    colorAccent = classColors?.colorAccent ?? Colors.transparent;
    activeBorderColor = classColors?.activeBorderColor ?? Colors.transparent;
    inactiveBorderColor =
        classColors?.inactiveBorderColor ?? Colors.transparent;
    colorBackground = classColors?.colorBackground ?? Colors.transparent;
    colorText = classColors?.colorText ?? Colors.white;
    colorActiveTab = classColors?.colorActiveTab ?? Colors.yellow;
    colorDisabled = classColors?.colorDisabled ?? Colors.transparent;
    colorBackgroundGradiantDark =
        classColors?.colorBackgroundGradiantDark ?? Colors.transparent;
    colorBackgroundGradiantLight =
        classColors?.colorBackgroundGradiantLight ?? Colors.transparent;

    setTextStyles(colorText);

    gradient = RadialGradient(
      radius: 1.5,
      colors: [
        colorBackgroundGradiantLight.withAlpha(220),
        colorBackgroundGradiantDark.withAlpha(220),
      ],
    );

    var theme = ThemeData();
    var baseSize = theme.textTheme.bodyMedium?.fontSize ?? 12;

    return ThemeData(
      primaryColor: classColors?.color ?? Colors.transparent,
      colorScheme: ColorScheme.fromSeed(
          seedColor: classColors?.color ?? Colors.transparent),
      textTheme: TextTheme(
        bodyLarge: theme.textTheme.bodyLarge?.copyWith(
            // color: classColors?.colorText ?? Colors.pink[300],
            fontSize: baseSize * 1.4),
        bodyMedium: theme.textTheme.bodyMedium,
        // ?.copyWith(color: classColors?.colorText ?? Colors.pink[300]),
        bodySmall: theme.textTheme.bodySmall?.copyWith(
            // color: classColors?.colorText ?? Colors.pink[300],
            fontSize: baseSize * .8),
      ),
    );
  }
}
