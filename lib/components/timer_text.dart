import 'dart:async';

import 'package:client/dictionary.dart';
import 'package:client/providers/theme.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class TimerText extends StatefulWidget {
  const TimerText({
    super.key,
    this.style,
    this.prefix,
    this.onFlip,
    this.verbose = false,
    required this.datetime,
  });

  final String? prefix;
  final void Function()? onFlip;
  final TextStyle? style;
  final DateTime datetime;
  final bool verbose;

  @override
  State<TimerText> createState() => _TimerTextState();
}

class _TimerTextState extends State<TimerText> {
  final _logger = Logger();
  final _theme = ThemeProvider();

  Timer? _timer;
  Duration _difference = Duration.zero;

  bool _isBefore = true;
  bool get isBefore => _isBefore;
  set isBefore(bool val) {
    if (!_isBefore && val) {
      if (widget.onFlip != null) {
        widget.onFlip!();
      }
    }

    _isBefore = val;
  }

  @override
  void initState() {
    super.initState();

    createTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    return Text(
      (widget.prefix ?? "") + getTimerText(),
      style: widget.style ?? _theme.textMedium,
    );
  }

  String getTimerText() {
    var ret = "";

    if (_difference.inDays > 1) {
      ret += "${_difference.inDays.toString()} ${Dictionary.get("DAYS")}";
    } else if (_difference.inDays == 1) {
      ret += "${_difference.inDays.toString()} ${Dictionary.get("DAY")}";
    } else if (_difference.inHours > 1) {
      ret += "${_difference.inHours.toString()} ${Dictionary.get("HOURS")}";
    } else if (_difference.inHours == 1) {
      ret += "${_difference.inHours.toString()} ${Dictionary.get("HOUR")}";
    } else if (_difference.inMinutes > 1) {
      ret += "${_difference.inMinutes.toString()} ${Dictionary.get("MINUTES")}";
    } else if (_difference.inMinutes == 1) {
      ret += "${_difference.inMinutes.toString()} ${Dictionary.get("MINUTE")}";
    } else {
      if (widget.datetime.isBefore(DateTime.now())) {
        return Dictionary.get("RECENTLY").toUpperCase();
      } else {
        return Dictionary.get("SOON").toUpperCase();
      }
    }

    if (widget.verbose) {
      if (widget.datetime.isBefore(DateTime.now())) {
        ret = "$ret ${Dictionary.get("AGO")}";
      } else {
        ret = "${Dictionary.get("IN")} $ret";
      }
    }

    return ret.toUpperCase();
  }

  void onTimerTick() {
    _logger.w("onTimerTick");

    createTimer();
    setState(() {});
  }

  void createTimer() {
    _logger.t("createTimer");

    setDifference();

    _timer?.cancel();

    if (_difference.inDays >= 1) {
      return;
    }
    if (_difference.inHours > 1) {
      _timer = Timer(Duration(hours: 1), onTimerTick);
      return;
    }

    if (_difference.inHours == 1) {
      _timer =
          Timer(Duration(minutes: _difference.inMinutes % 60), onTimerTick);
      return;
    }

    _timer = Timer(Duration(minutes: 1), onTimerTick);
    return;
  }

  void setDifference() {
    isBefore = widget.datetime.isBefore(DateTime.now());
    _difference = widget.datetime.isAfter(DateTime.now())
        ? widget.datetime.difference(DateTime.now())
        : DateTime.now().difference(widget.datetime);
  }
}
