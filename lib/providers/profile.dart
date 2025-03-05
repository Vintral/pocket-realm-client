import 'package:eventify/eventify.dart';
import 'package:logger/logger.dart';

import 'package:client/connection.dart';
import 'package:client/components/modals/loading.dart';
import 'package:client/components/modals/profile.dart';
import 'package:client/providers/modal.dart';

class ProfileProvider extends EventEmitter {
  static final ProfileProvider _instance = ProfileProvider._internal();

  factory ProfileProvider() {
    return _instance;
  }

  final _modals = ModalProvider();
  final Logger _logger = Logger();
  final Connection _connection = Connection();

  bool busy = false;
  bool loaded = false;
  String username = "";
  String avatar = "";
  String guid = "";

  bool friend = false;
  bool enemy = false;
  bool blocked = false;

  String contactCategory = "";
  String contactNote = "";

  ProfileProvider._internal() {
    _logger.d("Created");

    _connection.on("PROFILE", null, onProfile);
    _connection.on("ADD_CONTACT", null, onContactAdded);
    _connection.on("REMOVE_CONTACT", null, onContactRemoved);
  }

  void hideProfile() {
    _logger.d("hideProfile");
    emit("HIDE_PROFILE");
  }

  void toggleContact() {
    switch (contactCategory) {
      case "friend":
        friend = !friend;
      case "enemy":
        enemy = !enemy;
      case "blocked":
        blocked = !blocked;
    }
  }

  void onContactAdded(e, o) {
    _logger.d("onContactAdded");

    _modals.removeModal(Loading);
    toggleContact();
    emit("PROFILE_LOADED");
  }

  void onContactRemoved(e, o) {
    _logger.d("onContactRemoved");

    _modals.removeModal(Loading);
    toggleContact();
    emit("PROFILE_LOADED");
  }

  void onProfile(e, o) {
    _logger.d("onProfile");

    if (e.eventData != null) {
      var data = e.eventData as dynamic;

      if (data["success"] == true) {
        username = data["username"] ?? "";
        avatar = data["avatar"] ?? "";
        guid = data["guid"] ?? "";

        friend = data["friend"] ?? false;
        enemy = data["enemy"] ?? false;
        blocked = data["blocked"] ?? false;

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

  void addContact() {
    _logger.i("addContact");
    _connection.addContact(contactCategory, guid, contactNote);
  }

  void removeContact() {
    _logger.i("removeContact");
    _connection.removeContact(contactCategory, guid);
  }

  void blockUser() {
    _logger.i("blockUser");

    _modals.addModal(Loading(text: "BLOCK_USER"));

    contactCategory = "blocked";
    addContact();
  }

  void unblockUser() {
    _logger.i("unblockUser");

    _modals.addModal(Loading(text: "UNBLOCK_USER"));

    contactCategory = "blocked";
    removeContact();
  }

  void addFriend() {
    _logger.i("addFriend");

    _modals.addModal(Loading(text: "ADD_FRIEND"));

    contactCategory = "friend";
    addContact();
  }

  void removeFriend() {
    _logger.i("removeFriend");

    _modals.addModal(Loading(text: "REMOVE_FRIEND"));

    contactCategory = "friend";
    removeContact();
  }

  void addEnemy() {
    _logger.i("addEnemy");

    _modals.addModal(Loading(text: "ADD_ENEMY"));

    contactCategory = "enemy";
    addContact();
  }

  void removeEnemy() {
    _logger.i("removeEnemy");

    _modals.addModal(Loading(text: "REMOVE_ENEMY"));

    contactCategory = "enemy";
    removeContact();
  }
}
