import 'dart:async';

import 'package:client/components/modals/profile.dart';
import 'package:client/connection.dart';
import 'package:client/providers/modal.dart';
import 'package:eventify/eventify.dart';
import 'package:client/components/notification.dart' as realm;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ProfileProvider extends EventEmitter {
  static final ProfileProvider _instance = ProfileProvider._internal();

  factory ProfileProvider() {
    return _instance;
  }

  final _modals = ModalProvider();
  final Logger _logger = Logger(level: Level.debug);
  final Connection _connection = Connection();

  bool busy = false;
  bool loaded = false;
  String username = "";
  String avatar = "";
  String guid = "";

  ProfileProvider._internal() {
    _logger.d("Created");

    _connection.on("PROFILE", null, onProfile);
  }

  void hideProfile() {
    _logger.d("hideProfile");
    emit("HIDE_PROFILE");
  }

  void onProfile(e, o) {
    _logger.d("onProfile");

    if (e.eventData != null) {
      var data = e.eventData as dynamic;
      _logger.w(data);

      if (data["success"] == true) {
        username = data["username"] ?? "";
        avatar = data["avatar"] ?? "";
        guid = data["guid"] ?? "";

        loaded = true;
        emit("PROFILE_LOADED");
      } else {
        _logger.w("Error getting profile");

        loaded = false;
        username = "";
        hideProfile();
      }
    }
  }

  void getProfile(String user) {
    _logger.d("getProfile: $user");

    if (user != username) {
      busy = true;
      loaded = false;
      username = user;
      _connection.getProfile(user);
    }

    _modals.addModal(Profile());
  }
}
