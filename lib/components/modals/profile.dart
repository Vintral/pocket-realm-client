import 'dart:async';
import 'dart:ui' as ui;

import 'package:client/components/modals/loading.dart';
import 'package:client/components/note.dart';
import 'package:client/providers/modal.dart';
import 'package:flutter/material.dart';

import 'package:eventify/eventify.dart' as eventify;
import 'package:logger/logger.dart';

import 'package:client/components/avatar.dart';
import 'package:client/components/base_button.dart';
import 'package:client/components/base_display.dart';
import 'package:client/components/tab_bar.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/profile.dart';
import 'package:client/providers/theme.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  final _theme = ThemeProvider();
  final _logger = Logger(level: Level.debug);
  final _profile = ProfileProvider();
  final _modal = ModalProvider();

  late eventify.Listener _onProfileLoadedListener;
  late TabController _tabController;

  String _activeTab = Dictionary.get("COMBAT");

  @override
  void initState() {
    super.initState();

    _logger.t("initState");

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(onTabChanged);

    _onProfileLoadedListener =
        _profile.on("PROFILE_LOADED", null, onProfileLoaded);
  }

  @override
  void dispose() {
    _logger.t("dispose");

    _tabController.removeListener(onTabChanged);
    _onProfileLoadedListener.cancel();

    super.dispose();
  }

  void onTabChanged() {
    _logger.w("onTabChanged: ${_tabController.index}");

    setState(() {
      switch (_tabController.index) {
        case 1:
          _activeTab = Dictionary.get("SOCIAL");
        default:
          _activeTab = Dictionary.get("COMBAT");
      }
    });
  }

  Widget buildButton(String label, double width, Function() handler) {
    _logger.t("buildButton");

    var buttonSize = MediaQuery.of(context).size.height / 20;

    return SizedBox(
      height: buttonSize,
      width: width,
      child: BaseButton(
        borderRadius: BorderRadius.circular(_theme.gap),
        handler: handler,
        child: Text(
          Dictionary.get(label).toUpperCase(),
          style: _theme.textLargeBold,
        ),
      ),
    );
  }

  onProfileLoaded(e, o) {
    _logger.d("onProfileLoaded");

    setState(() {});
  }

  void onTab(String tab) {
    _logger.e("onTab: $tab");

    setState(() {
      _activeTab = tab.toLowerCase();
      switch (_activeTab) {
        case "combat":
          _tabController.index = 0;
        case "social":
          _tabController.index = 1;
      }
    });
  }

  onRaid() {
    _logger.i("onRaid");
  }

  onPillage() {
    _logger.i("onPillage");
  }

  onAttack() {
    _logger.i("onAttack");
  }

  onFriend() {
    _logger.i("onFriend");

    _profile.category = "friend";
    _modal.addModal(Note());
  }

  onEnemy() {
    _logger.i("onEnemy");
  }

  onBlock() {
    _logger.i("onBlock");
  }

  onMessage() {
    _logger.i("onMessage");
  }

  Widget getCombatButtons() {
    _logger.t("getCombatButtons");

    return LayoutBuilder(builder: (context, constraints) {
      var width = (constraints.maxWidth - _theme.gap) / 2;

      return Wrap(
        spacing: _theme.gap,
        runSpacing: _theme.gap,
        children: [
          buildButton("RAID", width, onRaid),
          buildButton("PILLAGE", width, onPillage),
          buildButton("ATTACK", width, onAttack),
        ],
      );
    });
  }

  Widget getSocialButtons() {
    _logger.t("getSocialButtons");

    return LayoutBuilder(builder: (context, constraints) {
      var width = (constraints.maxWidth - _theme.gap) / 2;

      return Wrap(
        spacing: _theme.gap,
        runSpacing: _theme.gap,
        children: [
          buildButton("ADD_FRIEND", width, onFriend),
          buildButton("ADD_ENEMY", width, onEnemy),
          buildButton("BLOCK_USER", width, onBlock),
          buildButton("SEND_MESSAGE", width, onMessage),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _logger.w("build: $_activeTab");

    var size = MediaQuery.of(context).size;
    var avatarSize = size.height / 5;

    return !_profile.loaded
        ? Container(
            decoration: BoxDecoration(
              boxShadow: _theme.boxShadows,
            ),
            child: BaseDisplay(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: _theme.gap * 2, horizontal: _theme.gap * 5),
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.errorContainer,
                  strokeWidth: MediaQuery.of(context).size.width / 200,
                ),
              ),
            ),
          )
        : Container(
            constraints: BoxConstraints(
              maxWidth: size.width * .75,
              minHeight: size.height * .5,
              maxHeight: size.height * .8,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 40,
                      child: ColorFiltered(
                        colorFilter:
                            ColorFilter.mode(_theme.color, BlendMode.modulate),
                        child: const Image(
                          image: AssetImage("assets/ui/panel-header.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(_theme.gap),
                            child: Text(
                              _profile.username,
                              style: _theme.textLargeBold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 32,
                          child: GestureDetector(
                            onTap: () => _profile.hideProfile(),
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
                        ),
                      ],
                    )
                  ],
                ),
                BaseDisplay(
                  child: Padding(
                    padding: EdgeInsets.all(_theme.gap),
                    child: Column(
                      spacing: _theme.gap,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: _theme.gap,
                          children: [
                            Avatar(
                              avatar: _profile.avatar,
                              size: avatarSize,
                              username: "name",
                              disableTap: true,
                            ),
                            Column(
                              children: [
                                Text(
                                  Dictionary.get("RESOURCES").toUpperCase(),
                                  style: _theme.textLargeBold,
                                ),
                                Divider(
                                  color: Colors.yellow,
                                ),
                                Text(
                                  "???",
                                  style: _theme.textLargeBold,
                                ),
                                SizedBox(
                                  height: _theme.gap,
                                ),
                                Text(
                                  Dictionary.get("UNITS").toUpperCase(),
                                  style: _theme.textLargeBold,
                                ),
                                Divider(
                                  color: Colors.yellow,
                                ),
                                Text(
                                  "???",
                                  style: _theme.textLargeBold,
                                ),
                                SizedBox(
                                  height: _theme.gap,
                                ),
                                Text(
                                  Dictionary.get("BUILDINGS").toUpperCase(),
                                  style: _theme.textLargeBold,
                                ),
                                Divider(
                                  color: Colors.yellow,
                                ),
                                Text(
                                  "???",
                                  style: _theme.textLargeBold,
                                ),
                                SizedBox(
                                  height: _theme.gap,
                                ),
                              ],
                            ),
                          ],
                        ),
                        RealmTabBar(
                          tabs: [
                            Dictionary.get("COMBAT").toUpperCase(),
                            Dictionary.get("SOCIAL").toUpperCase(),
                          ],
                          active: _activeTab,
                          handler: onTab,
                        ),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width,
                            maxHeight:
                                (MediaQuery.of(context).size.height / 20 * 2) +
                                    _theme.gap,
                          ),
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              getCombatButtons(),
                              getSocialButtons(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
