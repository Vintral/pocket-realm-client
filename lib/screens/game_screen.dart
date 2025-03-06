import 'package:flutter/material.dart';

import 'package:eventify/eventify.dart' as eventify;
import 'package:logger/logger.dart';

import 'package:client/capitalize.dart';
import 'package:client/components/header.dart';
import 'package:client/components/panel.dart';
import 'package:client/components/panel_page_route.dart';
import 'package:client/components/realm_menu_button.dart';
import 'package:client/components/slide_menu.dart';
import 'package:client/components/slide_menu_button.dart';
import 'package:client/connection.dart';
import 'package:client/dictionary.dart';
import 'package:client/panels/avatar.dart';
import 'package:client/panels/build.dart';
import 'package:client/panels/build_details.dart';
import 'package:client/panels/contacts.dart';
import 'package:client/panels/conversation.dart';
import 'package:client/panels/events.dart';
import 'package:client/panels/explore.dart';
import 'package:client/panels/gather.dart';
import 'package:client/panels/library.dart';
import 'package:client/panels/market.dart';
import 'package:client/panels/messages.dart';
import 'package:client/panels/news.dart';
import 'package:client/panels/rankings.dart';
import 'package:client/panels/recruit_details.dart';
import 'package:client/panels/recruit.dart';
import 'package:client/panels/rounds.dart';
import 'package:client/panels/rules.dart';
import 'package:client/panels/search.dart';
import 'package:client/panels/shoutbox.dart';
import 'package:client/panels/support.dart';
import 'package:client/providers/library.dart';
import 'package:client/providers/modal.dart';
import 'package:client/providers/notification.dart' as provider;
import 'package:client/providers/player.dart';
import 'package:client/providers/profile.dart';
import 'package:client/providers/social.dart';
import 'package:client/providers/theme.dart';
import 'package:client/settings.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final Logger _logger = Logger();
  final ThemeProvider _theme = ThemeProvider();
  final Connection _connection = Connection();

  final _profile = ProfileProvider();
  final _modals = ModalProvider();

  final List<String> _buttonTypes = <String>[
    "user",
    "action",
    "town",
    "social",
    "info",
  ];

  late List<Widget> _buttons = [];
  late BuildContext _navigationContext;
  String active = "";
  String panel = "";
  bool _showProfile = false;

  late eventify.Listener _onDisconnectedListener;
  late eventify.Listener _onNotificationListener;
  late eventify.Listener _onLibraryLoadedListener;
  late eventify.Listener _onShowProfileListener;
  late eventify.Listener _onHideProfileListener;
  late eventify.Listener _onModalsUpdatedListener;
  late eventify.Listener _onLibraryLoadingListener;
  late eventify.Listener _onShowConversationListener;
  final provider.NotificationProvider _notification =
      provider.NotificationProvider();
  final PlayerProvider _player = PlayerProvider();
  final _social = SocialProvider();
  final LibraryProvider _library = LibraryProvider();

  @override
  void initState() {
    super.initState();

    _onDisconnectedListener =
        _connection.on("DISCONNECTED", null, onDisconnected);

    _logger.t("initState");
    _buttons = buildButtons();
    _onNotificationListener =
        _notification.on("NOTIFICATIONS_UPDATED", null, onNotificationsUpdated);
    _player.on("UPDATED", null, (e, o) {
      _logger.t("Player Updated");
    });

    _onLibraryLoadedListener = _library.on("LOADED", null, onLibraryLoaded);
    _onLibraryLoadingListener = _library.on("LOADING", null, onLibraryLoading);
    _library.load(_player.round);

    _onShowProfileListener = _profile.on("SHOW_PROFILE", null, onShowProfile);
    _onHideProfileListener = _profile.on("HIDE_PROFILE", null, onHideProfile);

    _onShowConversationListener =
        _social.on("GO_CONVERSATION", null, onGoConversation);

    _onModalsUpdatedListener =
        _modals.on("UPDATED", null, (e, o) => setState(() {}));

    _logger.d("HEADER BACKGROUND HEIGHT: ${_theme.headerDrawerBackground}");
  }

  @override
  void dispose() {
    _logger.e("dispose");

    _onNotificationListener.cancel();
    _player.clear();

    _onLibraryLoadedListener.cancel();
    _onLibraryLoadingListener.cancel();
    _onDisconnectedListener.cancel();

    _onShowProfileListener.cancel();
    _onHideProfileListener.cancel();

    _onModalsUpdatedListener.cancel();

    _onShowConversationListener.cancel();

    super.dispose();
  }

  List<Widget> buildButtons() {
    return _buttonTypes
        .map<Widget>((type) => RealmMenuButton(
              handler: onTap,
              type: type,
              active: type == active,
              image: AssetImage('assets/icons/$type.png'),
            ))
        .toList();
  }

  void onLoaded(BuildContext context) {
    _logger.d("onLoaded");
    _navigationContext = context;
  }

  void onTap(String i) {
    _logger.i("onTap: $i");

    active = active == i ? "" : i;
    setState(() {
      _buttons = buildButtons();
    });
  }

  void onShowPanel(String newPanel) {
    _logger.d("onShowPanel: $newPanel || $panel");

    if (panel != newPanel) {
      panel = newPanel;
      Navigator.of(_navigationContext).pushReplacementNamed(panel);
    }

    setState(() {
      active = "";
    });
  }

  onGoConversation(e, o) {
    _logger.t("onGoConversation");
    onShowPanel("conversation");
  }

  void onShowProfile(e, o) {
    _logger.d("onShowProfile");

    setState(() {
      _showProfile = true;
    });
  }

  void onHideProfile(e, o) {
    _logger.d("onHideProfile");

    setState(() {
      _showProfile = false;
    });
  }

  Widget getUserMenu(int offset) {
    return SlideMenu(
      active: active == "user",
      offset: offset,
      alignment: Alignment.centerLeft,
      children: [
        SlideMenuButton(text: "Messages", handler: onShowPanel),
        SlideMenuButton(text: "Events", handler: onShowPanel),
        SlideMenuButton(text: "Kingdom", handler: onShowPanel),
        SlideMenuButton(text: "Rounds", handler: onShowPanel),
        SlideMenuButton(text: "Avatar", handler: onShowPanel),
      ],
    );
  }

  Widget getActionsMenu(int offset) {
    return SlideMenu(
      active: active == "action",
      offset: offset,
      alignment: Alignment.centerLeft,
      children: [
        SlideMenuButton(text: "Explore", handler: onShowPanel),
        SlideMenuButton(text: "Gather", handler: onShowPanel),
        SlideMenuButton(text: "Build", handler: onShowPanel),
        SlideMenuButton(text: "Recruit", handler: onShowPanel),
        SlideMenuButton(text: "Warfare", handler: onShowPanel),
      ],
    );
  }

  Widget getTownMenu(int offset) {
    return SlideMenu(
      active: active == "town",
      offset: offset,
      alignment: Alignment.centerLeft,
      children: [
        SlideMenuButton(
          text: Dictionary.get("LIBRARY").capitalize(),
          handler: onShowPanel,
        ),
        SlideMenuButton(text: "Market", handler: onShowPanel),
        SlideMenuButton(text: "Temple", handler: onShowPanel),
        SlideMenuButton(text: "Job", handler: onShowPanel),
      ],
    );
  }

  Widget getSocialMenu(int offset) {
    return SlideMenu(
      active: active == "social",
      offset: offset,
      alignment: Alignment.centerLeft,
      children: [
        SlideMenuButton(text: "Shoutbox", handler: onShowPanel),
        SlideMenuButton(text: "Contacts", handler: onShowPanel),
        SlideMenuButton(text: "Rankings", handler: onShowPanel),
        SlideMenuButton(text: "Search", handler: onShowPanel),
      ],
    );
  }

  Widget getInfoMenu(int offset) {
    return SlideMenu(
      active: active == "info",
      offset: offset,
      alignment: Alignment.centerRight,
      children: [
        SlideMenuButton(text: "News", handler: onShowPanel),
        SlideMenuButton(text: "Rules", handler: onShowPanel),
        SlideMenuButton(text: "Settings", handler: onShowPanel),
        SlideMenuButton(text: "Support", handler: onShowPanel),
      ],
    );
  }

  void onLibraryLoaded(ev, obj) {
    _logger.i("onLibraryLoaded");

    _logger.d("Library Loaded: ${_library.loaded ? 'YES' : 'NO'}");
    _logger.d("Resources Length: ${_library.resources.length}");
    _logger.d(_library.resources);

    Connection().sendGetSelf();

    setState(() {});
  }

  void onLibraryLoading(ev, obj) {
    _logger.i("onLibraryLoading");
    setState(() {});
  }

  String capitalize(String input) {
    return input.length > 1
        ? input[0].toUpperCase() + input.substring(1).toLowerCase()
        : "";
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    if (!_library.loaded) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: Settings.gap),
            Text("Loading data", style: Settings.resultStyle),
          ],
        ),
      );
    }

    return SafeArea(
      bottom: false,
      child: Theme(
        data: _theme.activeTheme,
        child: Stack(
          children: [
            Positioned.fill(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  _theme.colorBackground,
                  _theme.blendMode,
                ),
                child: Image.asset("assets/ui/app-background.png",
                    fit: BoxFit.cover),
              ),
            ),
            Column(
              children: <Widget>[
                const Header(),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: size.width / 5),
                    child: Navigator(
                      initialRoute: "rankings",
                      onGenerateRoute: (RouteSettings settings) {
                        _logger.t("onGenerateRoute: ${settings.name}");

                        var content = capitalize(settings.name ?? "");
                        var style = const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            decoration: TextDecoration.none);

                        WidgetBuilder builder;
                        switch (settings.name) {
                          case "recruit":
                            builder =
                                (context) => RecruitPanel(callback: onLoaded);
                          case "recruit-details":
                            builder = (context) => const RecruitDetailsPanel();
                          case "build":
                            builder =
                                (context) => BuildPanel(callback: onLoaded);
                          case "build-details":
                            builder = (context) => const BuildDetailsPanel();
                          case "explore":
                            builder =
                                (context) => ExplorePanel(callback: onLoaded);
                          case "gather":
                            builder =
                                (context) => GatherPanel(callback: onLoaded);
                          case "rules":
                            builder =
                                (context) => RulesPanel(callback: onLoaded);
                          case "news":
                            builder =
                                (context) => NewsPanel(callback: onLoaded);
                          case "shoutbox":
                            builder =
                                (context) => ShoutboxPanel(callback: onLoaded);
                          case "messages":
                            builder =
                                (context) => MessagesPanel(callback: onLoaded);
                          case "conversation":
                            builder = (context) =>
                                ConversationPanel(callback: onLoaded);
                          case "events":
                            builder =
                                (context) => EventsPanel(callback: onLoaded);
                          case "rounds":
                            builder =
                                (context) => RoundsPanel(callback: onLoaded);
                          case "market":
                            builder =
                                (context) => MarketPanel(callback: onLoaded);
                          case "rankings":
                            builder =
                                (context) => RankingsPanel(callback: onLoaded);
                          case "avatar":
                            builder =
                                (context) => AvatarPanel(callback: onLoaded);
                          case "library":
                            builder =
                                (context) => LibraryPanel(callback: onLoaded);
                          case "search":
                            builder =
                                (context) => SearchPanel(callback: onLoaded);
                          case "contacts":
                            builder =
                                (context) => ContactsPanel(callback: onLoaded);
                          case "support":
                            builder =
                                (context) => SupportPanel(callback: onLoaded);
                          default:
                            builder = (context) => Panel(
                                label: content,
                                callback: onLoaded,
                                child: Center(
                                  child: Text(
                                    "$content Content",
                                    style: style,
                                  ),
                                ));
                        }

                        //return MaterialPageRoute( builder: builder, settings: settings );
                        return PanelPageRoute(
                            builder: builder, settings: settings);
                      },
                    ),
                  ),
                ),
              ],
            ),
            getUserMenu(0),
            getActionsMenu(1),
            getTownMenu(2),
            getSocialMenu(3),
            getInfoMenu(4),
            ..._notification.notifications,
            Positioned(
              bottom: 0,
              width: size.width,
              child: Row(
                children: _buttons,
              ),
            ),
            // _showProfile ? Profile() : SizedBox.shrink(),
            ..._modals.build(),
          ],
        ),
      ),
    );
  }

  void onDisconnected(ev, obj) {
    Navigator.popAndPushNamed(context, "splash");
  }

  void onNotificationsUpdated(e, o) {
    _logger.i("onNotificationsUpdated");
    setState(() {});
  }
}
