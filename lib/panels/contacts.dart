import 'package:client/capitalize.dart';
import 'package:client/components/base_display.dart';
import 'package:client/components/contact.dart';
import 'package:client/data/contact.dart';
import 'package:client/providers/social.dart';
import 'package:flutter/material.dart';

import 'package:eventify/eventify.dart' as eventify;
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
  final _logger = Logger(level: Level.debug);
  final _provider = SocialProvider();

  final _theme = ThemeProvider();

  late eventify.Listener _onContactsRetrieved;

  late TabController _tabController;

  String _activeTab = Dictionary.get("FRIENDS");

  @override
  void initState() {
    super.initState();

    _logger.t("initState");

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(onTabChange);

    _onContactsRetrieved =
        _provider.on("CONTACTS_LOADED", null, onContactsLoaded);
    if (!_provider.contactsLoaded) {
      _provider.getContacts();
    }
  }

  @override
  void dispose() {
    _logger.t("dispose");

    _tabController.removeListener(onTabChange);
    _tabController.dispose();

    _onContactsRetrieved.cancel();

    super.dispose();
  }

  void onContactsLoaded(e, o) {
    _logger.t("onContactsLoaded");
    setState(() {});
  }

  void onTabChange() {
    _logger.d("onTabChange: ${_tabController.index}");

    setState(() {
      switch (_tabController.index) {
        case 1:
          _activeTab = Dictionary.get("ENEMIES");
        case 2:
          _activeTab = Dictionary.get("BLOCKED");
        default:
          _activeTab = Dictionary.get("FRIENDS");
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
        case "blocked":
          _tabController.index = 2;
      }
    });
  }

  Widget buildContactList(List<ContactData> data, String none) {
    _logger.f("buildContactList: ${data.length}");

    if (data.isEmpty) {
      return Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: MediaQuery.of(context).size.width / 5,
          child: BaseDisplay(
            child: Center(
              child: Text(
                none.capitalize(),
                style: _theme.textLargeBold,
              ),
            ),
          ),
        ),
      );
    }

    return ListView.separated(
        itemBuilder: (context, index) => Contact(data[index]),
        separatorBuilder: (context, index) => SizedBox(
              height: _theme.gap,
            ),
        itemCount: data.length);
  }

  @override
  Widget build(BuildContext context) {
    _logger.w("build");

    widget.callback(context);

    return Panel(
      label: Dictionary.get("CONTACTS"),
      loaded: _provider.contactsLoaded,
      header: RealmTabBar(
        tabs: [
          Dictionary.get("FRIENDS").toUpperCase(),
          Dictionary.get("ENEMIES").toUpperCase(),
          Dictionary.get("BLOCKED").toUpperCase(),
        ],
        active: _activeTab,
        handler: onTab,
      ),
      child: TabBarView(
        controller: _tabController,
        children: [
          buildContactList(_provider.friends, Dictionary.get("NO_FRIENDS")),
          buildContactList(_provider.enemies, Dictionary.get("NO_ENEMIES")),
          buildContactList(_provider.blocked, Dictionary.get("NO_BLOCKED"))
        ],
      ),
    );
  }
}
