import 'package:flutter/material.dart';

// import 'package:eventify/eventify.dart' as eventify;
import 'package:logger/logger.dart';

import 'package:client/components/panel.dart';
import 'package:client/components/tab_bar.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/theme.dart';
import 'package:client/states/list_panel.dart';

class ContactsPanel extends StatefulWidget {
  const ContactsPanel({super.key, required this.callback});

  final void Function(BuildContext) callback;

  @override
  State<ContactsPanel> createState() => _ContactsPanelState();
}

class _ContactsPanelState extends ListPanelState<ContactsPanel>
    with TickerProviderStateMixin {
  final Logger _logger = Logger(level: Level.debug);

  final _theme = ThemeProvider();

  // late eventify.Listener _onPlayerUpdatedListener;

  late TabController _tabController;

  String _activeTab = Dictionary.get("FRIENDS");

  @override
  void initState() {
    super.initState();

    _logger.t("initState");

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(onTabChange);
  }

  @override
  void dispose() {
    _logger.t("dispose");

    _tabController.removeListener(onTabChange);

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
          _activeTab = Dictionary.get("FRIENDS");
        default:
          _activeTab = Dictionary.get("ENEMIES");
      }
    });
  }

  void onTab(String tab) {
    _logger.e("onTab: $tab");
    setState(() {
      _activeTab = tab.toLowerCase();

      _logger.e("Active: $_activeTab");
      switch (_activeTab) {
        case "friends":
          _tabController.index = 0;
        case "enemies":
          _tabController.index = 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _logger.t("build");

    widget.callback(context);

    return Panel(
      label: Dictionary.get("AVATAR"),
      header: RealmTabBar(
        tabs: [
          Dictionary.get("FRIENDS").toUpperCase(),
          Dictionary.get("ENEMIES").toUpperCase(),
        ],
        active: _activeTab,
        handler: onTab,
      ),
      child: TabBarView(
        controller: _tabController,
        children: [
          // buildFemaleGrid(),
          // buildMaleGrid(),
        ],
      ),
    );
  }
}
