import 'dart:math' as math;

import 'package:client/components/header_stat.dart';
import 'package:client/components/item_with_border.dart';
import 'package:client/components/tab_bar.dart';
import 'package:client/data/building.dart';
import 'package:client/data/realm_object.dart';
import 'package:client/data/resource.dart';
import 'package:client/data/unit.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/library.dart';
import 'package:client/providers/player.dart';
import 'package:client/providers/theme.dart';
import 'package:flutter/material.dart';

import 'package:eventify/eventify.dart' as eventify;
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

class Header extends StatefulWidget {
  const Header({super.key, this.neverShow = false});

  final bool neverShow;

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> with TickerProviderStateMixin {
  final Logger _logger = Logger();
  final _player = PlayerProvider();
  final _library = LibraryProvider();
  final _theme = ThemeProvider();
  final _key = GlobalKey();
  final _keyWrap = GlobalKey();

  late final AnimationController _controllerLowerDrawerOffset =
      AnimationController(
    duration: Duration(milliseconds: _theme.animationSpeed),
    vsync: this,
  );

  late final AnimationController _controllerOffset = AnimationController(
    duration: Duration(milliseconds: _theme.animationSpeed),
    vsync: this,
  );

  Animation<double>? _offsetAnimation;
  Animation<double>? _offsetLowerDrawerAnimation;

  late final AnimationController _controllerRotation = AnimationController(
    duration: Duration(milliseconds: _theme.animationSpeed * 1),
    vsync: this,
  );
  late final Animation<double> _rotateAnimation = Tween<double>(
    begin: 0,
    end: math.pi,
  ).animate(CurvedAnimation(
    parent: _controllerRotation,
    curve: Curves.easeInOut,
  ))
    ..addListener(() => setState(() {}));

  late eventify.Listener _onPlayerUpdatedListener;
  bool _shown = false;
  bool _open = false;
  String _activeTab = Dictionary.get("RESOURCES");

  double moveDistance = 0;
  double drawerIconSize = 0;

  late final CurvedAnimation _animationUpperDrawer = CurvedAnimation(
    parent: _controllerOffset,
    curve: Curves.linear,
  );

  late final CurvedAnimation _animationLowerDrawer = CurvedAnimation(
    parent: _controllerLowerDrawerOffset,
    curve: Curves.linear,
  )
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_open) {
          moveDistance = _getSize(_keyWrap).height + _theme.gap * 2;
        } else {
          moveDistance = 0;
        }
      }
    })
    ..addListener(() => setState(() {}));

  @override
  void initState() {
    super.initState();

    _logger.d("initState");
    _onPlayerUpdatedListener =
        _player.on("UPDATED", null, (e, o) => setState(() {}));
  }

  @override
  void dispose() {
    _logger.d("dispose");
    _onPlayerUpdatedListener.cancel();

    super.dispose();
  }

  Size _getSize(GlobalKey<State<StatefulWidget>> key) {
    if (key.currentContext == null) {
      _logger.w("No Context");
      return Size.zero;
    }
    return (key.currentContext?.findRenderObject()! as RenderBox).size;
  }

  void setOffsetAnimation(double start, double finish) {
    _logger.t("setOffsetAnimation: $start -> $finish");

    _offsetAnimation = Tween<double>(
      begin: start,
      end: finish,
    ).animate(_animationUpperDrawer);

    _controllerOffset.reset();
    _controllerOffset.forward();
  }

  void setLowerDrawerAnimation(double start, double finish) {
    _logger.t("setLowerDrawerAnimation: $start -> $finish  | $_open");

    _controllerLowerDrawerOffset.reset();

    _offsetLowerDrawerAnimation = Tween<double>(
      begin: start,
      end: finish,
    ).animate(_animationLowerDrawer);

    _controllerLowerDrawerOffset.forward();
  }

  Widget buildCell({required Widget child, required String image}) {
    return Expanded(
      child: Stack(
        children: [
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                _theme.color,
                _theme.blendMode,
              ),
              child: Image.asset(
                "assets/ui/header-$image-bar.png",
                fit: BoxFit.fill,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: _theme.gapHorizontal * 2),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  void openUpperDrawer() {
    _logger.d("openUpperDrawer");
    setOffsetAnimation(0, _theme.headerDrawerCap);
    openLowerDrawer();
    _controllerRotation.forward();
  }

  void closeUpperDrawer() {
    _logger.d("closeUpperDrawer");
    setOffsetAnimation(_theme.headerDrawerCap, 0);
  }

  void openLowerDrawer() {
    _logger.d("openLowerDrawer: ${_getSize(_keyWrap).height}");
    setLowerDrawerAnimation(0, _getSize(_keyWrap).height + _theme.gap * 2);
  }

  void closeLowerDrawer() {
    _logger.d("closeLowerDrawer");
    closeUpperDrawer();
    setLowerDrawerAnimation(_getSize(_keyWrap).height + _theme.gap * 2, 0);
    _controllerRotation.reverse();
  }

  void onTap() {
    _logger.i("onTap");

    _open = !_open;
    setState(() {
      if (!_open) {
        closeLowerDrawer();
      } else {
        openUpperDrawer();
      }
    });
  }

  void onTab(String tab) {
    _logger.i("onTab: $tab");
    setState(() {
      _activeTab = tab.toLowerCase();
    });
  }

  Widget buildItem(RealmObject item, String quantity) {
    return ItemWithBorder(
      width: drawerIconSize,
      height: drawerIconSize,
      item: item,
      quantity: quantity,
    );
  }

  Widget buildResource(Resource resource) {
    var quantity = "--";

    switch (resource.name) {
      case "gold":
        quantity = _player.gold.toString();
        break;
      case "wood":
        quantity = _player.wood.toString();
        break;
      case "food":
        quantity = _player.food.toString();
        break;
      case "metal":
        quantity = _player.metal.toString();
        break;
      case "stone":
        quantity = _player.stone.toString();
        break;
      case "mana":
        quantity = _player.mana.toString();
        break;
      case "faith":
        quantity = _player.faith.toString();
        break;
      case "research":
        quantity = _player.research.toString();
        break;
      default:
        return Container();
    }

    return buildItem(resource, quantity);
  }

  List<Widget> getDrawerContent() {
    _logger.t("getDrawerContent: $_activeTab");

    if (_activeTab == Dictionary.get("RESOURCES")) {
      return [
        ..._library.resources
            // .where(
            //     (element) => element.name != "mana" && element.name != "faith")
            .map((resource) => buildResource(resource)),
        ..._library.resources
            // .where(
            //     (element) => element.name != "mana" && element.name != "faith")
            .map((resource) => buildResource(resource)),
      ];
    }

    if (_activeTab == Dictionary.get("UNITS")) {
      return _player.units
          .where((u) =>
              (u.quantity >= 1) || (u.quantity > 0 && u.unit!.supportPartial))
          .map((u) {
        return buildItem(
          u.unit as Unit,
          u.quantity < 0
              ? "${(u.quantity * 100).floor()}%"
              : u.quantity.floor().toString(),
        );
      }).toList();
    }

    if (_activeTab == Dictionary.get("BUILDINGS")) {
      return _player.buildings
          .where((b) =>
              (b.quantity >= 1) ||
              (b.quantity > 0 && b.building!.supportPartial))
          .map((b) {
        return buildItem(
          b.building as Building,
          b.quantity < 0
              ? "${(b.quantity * 100).floor()}%"
              : b.quantity.floor().toString(),
        );
      }).toList();
    }

    return [];
  }

  double getOffsetForWrap() {
    _logger.t("getOffsetForWrap");
    return _open ? _getSize(_keyWrap).height + _theme.gap * 2 : 0;
  }

  Widget getInnerDrawer() {
    return Positioned(
      bottom: 0,
      child: Stack(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              _theme.color,
              _theme.blendMode,
            ),
            child: Image.asset("assets/ui/drawer-background.png",
                key: _key,
                width: _theme.width,
                height: _theme.width,
                fit: BoxFit.cover),
          ),
          Positioned(
            bottom: _theme.gapVertical,
            left: _theme.gapHorizontal,
            right: _theme.gapHorizontal,
            child: Wrap(
              key: _keyWrap,
              crossAxisAlignment: WrapCrossAlignment.start,
              runAlignment: WrapAlignment.start,
              alignment: WrapAlignment.start,
              spacing: _theme.gapHorizontal,
              runSpacing: _theme.gapVertical,
              children: getDrawerContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget getDrawer() {
    return Positioned(
      top: _theme.headerHeight + (_offsetAnimation?.value ?? 0),
      child: SizedBox(
        height:
            _theme.headerDrawerCap + (_offsetLowerDrawerAnimation?.value ?? 0),
        child: Stack(
          children: [
            getInnerDrawer(),
            SizedBox(
              width: _theme.width,
              height: _theme.headerDrawerCap,
              child: RealmTabBar(
                tabs: [
                  Dictionary.get("RESOURCES").toUpperCase(),
                  Dictionary.get("UNITS").toUpperCase(),
                  Dictionary.get("BUILDINGS").toUpperCase(),
                ],
                active: _activeTab,
                handler: onTab,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    var targetItems =
        math.max(4, (MediaQuery.of(context).size.width / 125).ceil());
    drawerIconSize =
        (_theme.width - _theme.gapHorizontal * (targetItems + 1)) / targetItems;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.neverShow) return;

      if (_getSize(_key).height > 0) {
        _theme.headerDrawerBackground = _getSize(_key).height;
      }

      if (_open &&
          _controllerLowerDrawerOffset.status == AnimationStatus.completed) {
        var distance = getOffsetForWrap();
        if (distance != moveDistance) {
          _logger.t(
              "Move to $distance from $moveDistance   ${_controllerLowerDrawerOffset.status}");
          setLowerDrawerAnimation(moveDistance, distance);
        }
      }

      if (!_shown) {
        setState(() {
          _shown = true;
        });
      }
    });

    _theme.width = MediaQuery.of(context).size.width;

    return Offstage(
      offstage: !_shown,
      child: SizedBox(
        height: _theme.headerHeight +
            _theme.headerDrawerCap +
            (_offsetAnimation?.value ?? 0) +
            (_offsetLowerDrawerAnimation?.value ?? 0),
        child: Stack(
          children: [
            getDrawer(),
            SizedBox(
              width: _theme.width,
              height: _theme.headerHeight + _theme.headerDrawerCap,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            height: _theme.headerHeight,
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                _theme.color,
                                _theme.blendMode,
                              ),
                              child: Image.asset(
                                "assets/ui/header-avatar.png",
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(_theme.gap / 2),
                            child: SizedBox(
                              height:
                                  math.max(_theme.headerHeight - _theme.gap, 0),
                              child: Image.asset(
                                  "assets/${_player.avatar.isNotEmpty ? "avatars/${_player.avatar}" : "none"}.png",
                                  fit: BoxFit.fill),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: SizedBox(
                          height: _theme.headerHeight,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildCell(
                                child: HeaderStat(
                                    icon: "energy", value: _player.energy),
                                image: "top",
                              ),
                              buildCell(
                                  child: HeaderStat(
                                      icon: "land", value: "${_player.land}"),
                                  image: "middle"),
                              buildCell(
                                  child: HeaderStat(
                                      icon: "tree",
                                      value: "${_player.landFree}"),
                                  image: "bottom"),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: _theme.headerHeight,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              buildCell(child: Container(), image: "top"),
                              buildCell(child: Container(), image: "middle"),
                              buildCell(child: Container(), image: "bottom"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    color: Colors.yellow,
                    child: GestureDetector(
                      onTap: onTap,
                      child: SizedBox(
                        height: _theme.headerDrawerCap,
                        width: _theme.width,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  _theme.color,
                                  _theme.blendMode,
                                ),
                                child: Image.asset(
                                  "assets/ui/panel-header.png",
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Center(
                              child: Transform.rotate(
                                angle: _rotateAnimation.value,
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    _theme.color,
                                    // _theme.blendMode,
                                    BlendMode.modulate,
                                  ),
                                  child:
                                      Image.asset("assets/ui/drawer-arrow.png"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
