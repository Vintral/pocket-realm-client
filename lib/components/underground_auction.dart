import 'dart:async';

import 'package:client/capitalize.dart';
import 'package:client/components/cost_button.dart';
import 'package:client/components/item_with_border.dart';
import 'package:client/components/timer_text.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/library.dart';
import 'package:client/providers/market.dart';
import 'package:client/providers/theme.dart';
import 'package:client/settings.dart';
import 'package:eventify/eventify.dart' as eventify;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class UndergroundAuction extends StatefulWidget {
  const UndergroundAuction({
    super.key,
    required this.item,
    required this.auction,
    required this.cost,
    required this.expires,
    required this.purchased,
  });

  final String auction;
  final String item;
  final int cost;
  final DateTime expires;
  final DateTime purchased;

  @override
  State<UndergroundAuction> createState() => _UndergroundAuctionState();
}

class _UndergroundAuctionState extends State<UndergroundAuction> {
  final _logger = Logger();
  final _theme = ThemeProvider();
  final _library = LibraryProvider();

  Timer? _timer;
  eventify.Listener? _marketListener;

  @override
  void initState() {
    super.initState();

    _marketListener = MarketProvider().on("BUSY_CHANGED", null, onBusyChanged);
    _timer?.cancel();

    var expiresIn = widget.expires.difference(DateTime.now());
    if (expiresIn.inDays > 0) {
      _logger.e("DAYS AWAY: ${expiresIn.inDays}");
    } else if (expiresIn.inHours > 0) {
      _logger.e("HOURS AWAY: ${expiresIn.inHours}");
    } else if (expiresIn.inMinutes > 0) {
      _logger.e("MINUTES AWAY: ${expiresIn.inMinutes}");
    } else {
      _logger.e("SECONDS AWAY: ${expiresIn.inSeconds}");
    }

    // _timer = Timer.periodic(Duration(seconds: 1), (_) => _logger.w("TICK"));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _marketListener?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    var item = _library.getItem(widget.item);
    var size = MediaQuery.of(context).size;

    var border = BorderSide(
      color: _theme.shadowColor,
    );

    return SizedBox(
      height: size.width / 4,
      child: Stack(
        children: [
          Row(
            children: [
              ItemWithBorder(
                  image:
                      "assets/items/${item["name"].toString().toLowerCase().replaceAll(RegExp(r' '), "-")}.png"),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [_theme.boxShadow],
                  border: Border(bottom: border, top: border, right: border),
                  gradient: _theme.gradient,
                ),
                child: SizedBox(
                  height: size.width / 4,
                  width: size.width * 3 / 4 - Settings.gap * 3,
                  child: Padding(
                    padding: EdgeInsets.all(Settings.gap),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                Dictionary.get(
                                        widget.expires.isBefore(DateTime.now())
                                            ? "EXPIRED"
                                            : "EXPIRES")
                                    .toUpperCase(),
                                style: _theme.textLargeBold,
                              ),
                              SizedBox(
                                width: Settings.gap / 2,
                              ),
                              TimerText(
                                datetime: widget.expires,
                                style: _theme.textLargeBold,
                                onFlip: () => setState(() {}),
                                verbose: true,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: CostButton(
                            busy: MarketProvider().busy,
                            borderRadius:
                                BorderRadius.all(Radius.circular(Settings.gap)),
                            handler: () =>
                                MarketProvider().buyAuction(widget.auction),
                            text: widget.cost.toString(),
                            image: "assets/icons/gold.png",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          widget.purchased.year != 1
              ? Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      scale: 0.3,
                      image: Image.asset(
                        "assets/none.png",
                        color: Colors.blue,
                        scale: 0.3,
                      ).image,
                      repeat: ImageRepeat.repeat,
                      opacity: 0.8,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(150),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: Settings.gap * 3,
                            spreadRadius: Settings.gap,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(Settings.gap),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(Dictionary.get("REFRESHES_IN").capitalize(),
                                style: _theme.textExtraLarge),
                            SizedBox(
                              width: Settings.gap / 2,
                            ),
                            TimerText(
                                datetime: widget.expires,
                                verbose: false,
                                onFlip: () => setState(() {}))
                          ],
                        ),
                      ),
                    ),
                  ),
                  // height: 100,
                  // width: 100,
                )
              : SizedBox(),
        ],
      ),
    );
  }

  void onBusyChanged(ev, o) {
    _logger.d("onBusyChanged");

    setState(() {});
  }
}
