import 'dart:math';

import 'package:client/dictionary.dart';
import 'package:client/providers/theme.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

Logger _logger = Logger(level: Level.off);
var _theme = ThemeProvider();

int getIntVal(dynamic val) {
  if (val is int) return val;
  if (val is double) return val.truncate();

  return int.tryParse(val) ?? -1;
}

String capitalizeFirst(String str) {
  return str.substring(0, 1).toUpperCase() + str.substring(1);
}

Widget getCloseButton(BuildContext context, {Function()? handler}) {
  return SizedBox(
    height: MediaQuery.of(context).size.height / 20,
    child: GestureDetector(
      onTap: handler ?? () => Navigator.of(context).pop(),
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          _theme.colorAccent,
          _theme.blendMode,
        ),
        child: Image.asset(
          "assets/ui/close.png",
          fit: BoxFit.fitHeight,
        ),
      ),
    ),
  );

  return SizedBox(
    height: 32,
    child: GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          _theme.colorAccent,
          _theme.blendMode,
        ),
        child: Image.asset(
          "assets/ui/close.png",
          fit: BoxFit.fitHeight,
        ),
      ),
    ),
  );
}

String timeSince(DateTime val, {bool suffixFlag = true}) {
  var diff = DateTime.now().difference(val);
  _logger.t("timeSince: $diff");

  var suffix = suffixFlag ? Dictionary.get("AGO") : "";

  if (diff.inDays > 0) {
    if (diff.inDays > 7) {
      int weeks = (diff.inDays / 7).floor();
      return "$weeks ${Dictionary.get(weeks > 1 ? "WEEKS" : "WEEK")} $suffix";
    }
    return "${diff.inDays} ${Dictionary.get(diff.inDays > 1 ? "DAYS" : "DAY")} $suffix";
  }

  if (diff.inHours > 0) {
    return "${diff.inHours} ${Dictionary.get(diff.inHours > 1 ? "HOURS" : "HOUR")} $suffix";
  }

  if (diff.inMinutes > 0) {
    return "${diff.inMinutes} ${Dictionary.get(diff.inMinutes > 1 ? "MINUTES" : "MINUTE")} $suffix";
  }

  return Dictionary.get("NOW");
}

LinearGradient buildBackgroundGradiant(int stripes,
    {Color? dark, Color? light}) {
  _logger.t("buildGradiant");

  dark = dark ?? Color.fromARGB(150, 0, 0, 0);
  light = light ?? Color.fromARGB(75, 0, 0, 0);

  var colors = <Color>[];
  var stops = <double>[];
  var step = 1 / stripes;
  for (int i = 0; i < stripes; i++) {
    var base = step * i;
    colors.addAll(i % 2 == 0 ? [dark, dark] : [light, light]);
    stops.addAll([base, base + step]);
  }

  _logger.w(stops);

  return LinearGradient(
    begin: Alignment(0, 0),
    end: Alignment(.3, 0),
    tileMode: TileMode.repeated,
    colors: colors,
    stops: stops,
    transform: const GradientRotation(pi / 4),
  );
}
