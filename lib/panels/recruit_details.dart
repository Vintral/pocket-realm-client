import 'package:client/components/button.dart';
import 'package:client/components/panel.dart';
import 'package:client/connection.dart';
import 'package:client/data/unit.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/actions.dart';
import 'package:eventify/eventify.dart' as eventify;
import 'package:client/providers/notification.dart';
import 'package:client/providers/player.dart';
import 'package:client/providers/theme.dart';
import 'package:client/settings.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class RecruitDetailsPanel extends StatefulWidget {
  const RecruitDetailsPanel({super.key});

  @override
  State<RecruitDetailsPanel> createState() => _RecruitDetailsPanelState();
}

class _RecruitDetailsPanelState extends State<RecruitDetailsPanel> {
  final Logger logger = Logger(level: Level.debug);
  final Connection connection = Connection();
  final NotificationProvider _notification = NotificationProvider();
  final ActionProvider _provider = ActionProvider();
  final PlayerProvider _player = PlayerProvider();
  final ThemeProvider _theme = ThemeProvider();

  eventify.Listener? _onRecruitSuccessListener;

  late Unit _unit;

  @override
  void initState() {
    super.initState();

    _onRecruitSuccessListener =
        _provider.on("RECRUIT_SUCCESS", null, onRecruitSuccess);
  }

  @override
  void dispose() {
    _onRecruitSuccessListener?.cancel();

    super.dispose();
  }

  void onRecruitSuccess(e, o) {
    _notification.notifySuccess("Recruited");
    Navigator.pop(context);
  }

  Text buildHeader(String headerText) {
    return Text(headerText, style: _theme.textMedium);
  }

  Widget buildStat(String val, String? icon) {
    List<Widget> children = <Widget>[];

    children.add(Text(
      val,
      style: _theme.textMediumBold,
    ));
    if (icon != null) {
      children.add(Image.asset(
        "assets/icons/$icon.png",
        width: MediaQuery.of(context).size.width / 32,
      ));
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width / 7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }

  List<Widget> getCosts() {
    List<Widget> ret = <Widget>[];

    List<Widget> children = <Widget>[];
    if (_unit.costPoints > 0) {
      children.add(buildStat(_unit.costPoints.toString(), "energy"));
    }
    if (_unit.costGold > 0) {
      children.add(buildStat(_unit.costGold.toString(), "gold"));
    }
    if (_unit.costFood > 0) {
      children.add(buildStat(_unit.costFood.toString(), "food"));
    }
    if (_unit.costWood > 0) {
      children.add(buildStat(_unit.costWood.toString(), "wood"));
    }
    if (_unit.costStone > 0) {
      children.add(buildStat(_unit.costStone.toString(), "stone"));
    }
    if (_unit.costMetal > 0) {
      children.add(buildStat(_unit.costMetal.toString(), "metal"));
    }
    if (_unit.costFaith > 0) {
      children.add(buildStat(_unit.costFaith.toString(), "faith"));
    }
    if (_unit.costMana > 0) {
      children.add(buildStat(_unit.costMana.toString(), "mana"));
    }

    ret.add(buildHeader("Cost"));
    ret.add(Wrap(
      children: children,
    ));

    return ret;
  }

  List<Widget> getUpkeeps() {
    List<Widget> ret = <Widget>[];

    List<Widget> children = <Widget>[];
    if (_unit.upkeepGold > 0)
      children.add(buildStat(_unit.upkeepGold.toString(), "gold"));
    if (_unit.upkeepFood > 0)
      children.add(buildStat(_unit.upkeepFood.toString(), "food"));
    if (_unit.upkeepWood > 0)
      children.add(buildStat(_unit.upkeepWood.toString(), "wood"));
    if (_unit.upkeepStone > 0)
      children.add(buildStat(_unit.upkeepStone.toString(), "stone"));
    if (_unit.upkeepMetal > 0)
      children.add(buildStat(_unit.upkeepMetal.toString(), "metal"));
    if (_unit.upkeepFaith > 0)
      children.add(buildStat(_unit.upkeepFaith.toString(), "faith"));
    if (_unit.upkeepMana > 0)
      children.add(buildStat(_unit.upkeepMana.toString(), "mana"));

    ret.add(buildHeader("Upkeep"));
    ret.add(Wrap(
      children: children,
    ));

    return ret;
  }

  List<Widget> getStats() {
    List<Widget> ret = <Widget>[];

    if (_provider.unit == null) return ret;
    _unit = _provider.unit as Unit;

    ret.add(buildHeader("Stats"));
    ret.add(Wrap(
      children: [
        buildStat(_unit.attack.toString(), "energy"),
        buildStat(_unit.defense.toString(), "energy"),
        buildStat(_unit.power.toString(), "energy"),
        buildStat(_unit.health.toString(), "energy"),
        buildStat((_unit.ranged ? "Ranged" : "Melee"), "energy"),
      ],
    ));

    return ret;
  }

  List<Widget> getDetails() {
    return [
      ...getStats(),
      ...getCosts(),
      ...getUpkeeps(),
    ];
  }

  bool canAfford(int energy) {
    logger.d("canAfford: $energy");

    if (_player.energy < energy) return false;

    var units = (_player.recruitPower * energy) / _unit.costPoints;
    logger.d("Units For Energy: $units");

    if (units < 1 && !_unit.supportPartial) return false;

    if (_player.wood < units * _unit.costWood) return false;
    if (_player.gold < units * _unit.costGold) return false;
    if (_player.food < units * _unit.costFood) return false;
    if (_player.stone < units * _unit.costStone) return false;
    if (_player.metal < units * _unit.costMetal) return false;
    if (_player.faith < units * _unit.costFaith) return false;
    if (_player.mana < units * _unit.costMana) return false;

    logger.d("returning true from canAfford");
    return true;
  }

  void onTap({required int energy}) {
    logger.i("onTap: $energy");

    if (canAfford(energy)) {
      _provider.recruit(energy: energy);
    } else {
      if (_player.energy < energy) {
        _notification.notifyError(Dictionary.errors["NOT_ENOUGH_ENERGY"]);
      } else {
        _notification.notifyError(Dictionary.errors["CANT_AFFORD"]);
      }
      _player.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Panel(
      label: Dictionary.get("RECRUIT"),
      closable: true,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Column(
              children: [
                Container(
                  color: _theme.colorBackground,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                color: _theme.colorBackground,
                                child: Image.asset(
                                  "assets/units/${_provider.unit?.name ?? "none"}.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(Settings.horizontalGap),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: getDetails(),
                                ),
                              ),
                            ),
                          ]),
                      Padding(
                        padding: EdgeInsets.all(Settings.gap),
                        child: Row(
                          children: [
                            Expanded(
                              child: Button(
                                text: "1",
                                handler: () => onTap(energy: 1),
                                image: "assets/icons/energy.png",
                              ),
                            ),
                            SizedBox(
                              width: Settings.gap,
                            ),
                            Expanded(
                              child: Button(
                                text: "5",
                                handler: () => onTap(energy: 5),
                                image: "assets/icons/energy.png",
                              ),
                            ),
                            SizedBox(
                              width: Settings.gap,
                            ),
                            Expanded(
                              child: Button(
                                text: "25",
                                handler: () => onTap(energy: 25),
                                image: "assets/icons/energy.png",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
