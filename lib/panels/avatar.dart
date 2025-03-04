import 'package:flutter/material.dart';

import 'package:eventify/eventify.dart' as eventify;
import 'package:logger/logger.dart';

import 'package:client/components/item_with_border.dart';
import 'package:client/components/panel.dart';
import 'package:client/components/tab_bar.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/player.dart';
import 'package:client/providers/theme.dart';
import 'package:client/states/list_panel.dart';

class AvatarPanel extends StatefulWidget {
  const AvatarPanel({super.key, required this.callback});

  final void Function(BuildContext) callback;

  @override
  State<AvatarPanel> createState() => _AvatarPanelState();
}

class _AvatarPanelState extends ListPanelState<AvatarPanel>
    with TickerProviderStateMixin {
  final Logger _logger = Logger(level: Level.debug);

  final _theme = ThemeProvider();
  final _player = PlayerProvider();

  late eventify.Listener _onPlayerUpdatedListener;

  late TabController _tabController;

  String _activeTab = Dictionary.get("FEMALE");

  @override
  void initState() {
    super.initState();

    _logger.t("initState");

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(onTabChange);

    _activeTab = _player.avatar.substring(0, 1) == "f"
        ? Dictionary.get("FEMALE")
        : Dictionary.get("MALE");
    switch (_activeTab) {
      case "female":
        _tabController.index = 0;
      case "male":
        _tabController.index = 1;
    }

    _onPlayerUpdatedListener = _player.on("UPDATED", null, onPlayerUpdated);
  }

  @override
  void dispose() {
    _logger.t("dispose");

    _tabController.removeListener(onTabChange);
    _onPlayerUpdatedListener.cancel();

    super.dispose();
  }

  void onPlayerUpdated(e, o) {
    _logger.t("onPlayerUpdated");
    setState(() {});
  }

  void onTabChange() {
    _logger.d("onTabChange");

    setState(() {
      switch (_tabController.index) {
        case 1:
          _activeTab = Dictionary.get("MALE");
        default:
          _activeTab = Dictionary.get("FEMALE");
      }
    });
  }

  void onTab(String tab) {
    _logger.e("onTab: $tab");
    setState(() {
      _activeTab = tab.toLowerCase();

      _logger.e("Active: $_activeTab");
      switch (_activeTab) {
        case "female":
          _tabController.index = 0;
        case "male":
          _tabController.index = 1;
      }
    });
  }

  selectAvatar(String avatar) {
    _logger.e("selectAvatar: $avatar");
    _player.changeAvatar(avatar);
  }

  Widget buildAvatar(String type, int index) {
    return GestureDetector(
      onTap: () => selectAvatar(type + index.toString()),
      child: ItemWithBorder(
        image: "assets/avatars/$type$index.png",
        active: "$type$index" == _player.avatar,
      ),
    );
  }

  buildFemaleGrid() {
    _logger.t("buildFemaleGrid");

    List<Widget> avatars = [];
    for (int i = 1; i <= 26; i++) {
      avatars.add(buildAvatar("f", i));
    }

    return GridView.extent(
      mainAxisSpacing: _theme.gap,
      crossAxisSpacing: _theme.gap,
      maxCrossAxisExtent: 150,
      children: avatars,
    );
  }

  buildMaleGrid() {
    _logger.t("buildMaleGrid");

    List<Widget> avatars = [];
    for (int i = 1; i <= 26; i++) {
      avatars.add(buildAvatar("m", i));
    }

    return GridView.extent(
      mainAxisSpacing: _theme.gap,
      crossAxisSpacing: _theme.gap,
      maxCrossAxisExtent: 150,
      children: avatars,
    );
  }

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    widget.callback(context);

    return Panel(
      label: Dictionary.get("AVATAR"),
      header: RealmTabBar(
        tabs: [
          Dictionary.get("FEMALE").toUpperCase(),
          Dictionary.get("MALE").toUpperCase(),
        ],
        active: _activeTab,
        handler: onTab,
      ),
      child: TabBarView(
        controller: _tabController,
        children: [
          buildFemaleGrid(),
          buildMaleGrid(),
        ],
      ),
    );
  }
}
