import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static String version = "0.0.1";
  static String server =
      "63e0-2600-8800-7319-3a00-5161-54ab-609-c698.ngrok-free.app";

  //static String Round = "747352df-2da5-4b42-ada7-8f74f2090ae6";

  static Color inactiveBorderColor = const Color.fromARGB(255, 127, 127, 127);
  static Color activeBorderColor = const Color.fromARGB(255, 255, 255, 0);

  static double fontSize = 12;
  static double gap = 10;
  static double horizontalGap = 15;
  static double verticalSpacer = 10;
  static double maxResults = 20;

  static TextStyle resultStyle = const TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    decoration: TextDecoration.none,
    color: Colors.red,
  );
  static TextStyle headerStatStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.none,
    color: Colors.white,
  );

  static bool automaticLogin = false;
  static String username = "";
  static String password = "";

  final Logger _logger = Logger(level: Logger.level);

  bool _loaded = false;
  late SharedPreferences? settings;

  Future<bool> load() async {
    _logger.d("load");

    if (!_loaded) {
      settings = await SharedPreferences.getInstance();
      _loaded = true;
    } else {
      settings?.reload();
    }

    // Settings.AutomaticLogin = settings.getBool( "automatic_login" ) ?? false;
    // Settings.Username = settings.getString( "username" ) ?? "";
    // Settings.Password = settings.getString( "password" ) ?? "";

    dump();

    return true;
  }

  Future<void> saveLoginInfo(String username, String password) async {
    _logger.d("saveLoginInfo: $username - $password");

    if (settings == null) await load();

    await settings?.setBool("automatic_login", true);
    await settings?.setString("username", username);
    await settings?.setString("password", password);

    await load();
  }

  Future<void> clearLoginInfo() async {
    _logger.d("clearLoginInfo");

    if (settings == null) await load();

    await settings?.remove("automatic_login");
    await settings?.remove("username");
    await settings?.remove("password");

    await load();
  }

  void dump() {
    _logger.t("================================");
    _logger.t("Login: ${Settings.automaticLogin.toString()}");
    _logger.t("Username: ${Settings.username}");
    _logger.t("Password: ${Settings.password}");
    _logger.t("================================");
  }
}
