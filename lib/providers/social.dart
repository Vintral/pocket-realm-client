import 'dart:collection';

import 'package:client/data/contact.dart';
import 'package:client/data/search_result.dart';
import 'package:eventify/eventify.dart';
import 'package:logger/logger.dart';

import 'package:client/connection.dart';
import 'package:client/data/conversation.dart';
import 'package:client/data/message.dart';
import 'package:client/data/shout.dart';
import 'package:client/settings.dart';

class SocialProvider extends EventEmitter {
  static final SocialProvider _instance = SocialProvider._internal();

  factory SocialProvider() {
    return _instance;
  }

  final Logger _logger = Logger();
  final Connection _connection = Connection();

  bool _busy = false;
  bool get busy => _busy;
  set busy(value) => _busy = value;

  final List<ShoutData> _shouts = <ShoutData>[];
  List<ShoutData> get shouts => _shouts;

  List<ContactData> friends = <ContactData>[];
  List<ContactData> enemies = <ContactData>[];
  bool contactsLoaded = false;

  String searchNeedle = "";
  final List<SearchResultData> _searchResults = <SearchResultData>[];
  List<SearchResultData> get searchResults => _searchResults;

  final Map<String, ConversationData> _conversationMap = HashMap();
  Map<String, ConversationData> get conversationMap => _conversationMap;

  final List<ConversationData> _conversations = <ConversationData>[];
  List<ConversationData> get conversations => _conversations;

  String conversationAvatar = "";

  ConversationData? currentConversation;

  ConversationData? _conversation;
  ConversationData? get conversation => _conversation;
  set conversation(value) {
    _conversation =
        _conversations.where((curr) => curr.username == value).first;
    _conversation?.dump();
  }

  SocialProvider._internal() {
    _logger.d("Created");

    _connection.on("SHOUTS", null, onShouts);
    _connection.on("SHOUT", null, onShout);
    _connection.on("SEND_SHOUT", null, onShoutSent);

    _connection.on("CONVERSATIONS", null, onConversations);
    _connection.on("MESSAGES", null, onMessages);
    _connection.on("MESSAGE", null, onMessage);
    _connection.on("MESSAGE_SENT", null, onMessageSent);
    _connection.on("MESSAGE_ERROR", null, onMessageError);

    _connection.on("SEARCH_RESULTS", null, onSearchResults);

    _connection.on("GET_CONTACTS", null, onContacts);
  }

  void onContacts(e, o) {
    _logger.t("onContacts");

    var data = e.eventData as dynamic;
    _logger.w(data);

    if (data["friends"] != null) {
      _logger.w("Parse Friends");
      friends.clear();
      friends.addAll((data["friends"] as List<dynamic>)
          .map((friend) => ContactData(friend)));
    }

    if (data["enemies"] != null) {
      _logger.w("Parse Enemies");
      enemies.clear();
      enemies.addAll((data["enemies"] as List<dynamic>)
          .map((enemy) => ContactData(enemy)));
    }

    contactsLoaded = true;
    emit("CONTACTS_LOADED");
  }

  void searchUsers(String needle) {
    _logger.i("searchUsers: $needle");

    _busy = true;
    searchNeedle = needle;
    _connection.searchUsers(needle);
  }

  void onSearchResults(e, o) {
    _logger.d("onSearchResults");

    _searchResults.clear();

    if ((e.eventData as dynamic)["results"] != null) {
      _searchResults.addAll(
          ((e.eventData as dynamic)["results"] as List<dynamic>)
              .map((data) => SearchResultData(data)));

      _logger.w("Num Results: ${_searchResults.length}");
    }

    _busy = false;
    emit("SEARCH_RESULTS");
  }

  void onConversations(e, o) {
    _logger.d("onConversations");

    _conversations.addAll(
        ((e.eventData as dynamic)["conversations"] as List<dynamic>)
            .map<ConversationData>((data) {
      var conversation = ConversationData(data);
      _conversationMap[conversation.guid] = conversation;
      return conversation;
    }));
    emit("CONVERSATIONS");
  }

  void onMessage(e, o) {
    _logger.d("onMessage");

    _conversations.clear();
    emit("CONVERSATIONS");
  }

  void onMessages(e, o) {
    _logger.d("onMessages");

    var data = e.eventData;
    if (data["conversation"] != _conversation?.guid) {
      return;
    }

    _conversation?.messages = (data["messages"] as List<dynamic>)
        .map<MessageData>((data) => MessageData(data))
        .toList();
    emit("MESSAGES");
  }

  void onShoutSent(e, o) {
    _logger.d("onShoutSent");

    if ((e.eventData as dynamic)["success"]) {
      emit("SHOUT_SUCCESS");
    } else {
      emit("SHOUT_ERROR");
    }
  }

  void onShout(e, o) {
    _logger.d("onShout");

    _shouts.insert(0, ShoutData((e.eventData as dynamic)["shout"]));
    while (_shouts.length > Settings.maxResults) {
      _shouts.removeLast();
    }

    emit("SHOUTS");
  }

  void onMessageSent(e, o) {
    _logger.d("onMessageSent");
    emit("MESSAGE_SENT");
  }

  void onMessageError(e, o) {
    _logger.d("onMessageError");
    emit("MESSAGE_ERROR");
  }

  void subscribe() {
    _logger.d("subscribe");
    _connection.sendSubscribeShouts();
  }

  void unsubscribe() {
    _logger.d("unsubscribe");
    _connection.sendUnubscribeShouts();
  }

  void onShouts(e, o) {
    _logger.d("onShouts");

    _shouts.addAll(((e.eventData as dynamic)["shouts"] as List<dynamic>)
        .map((data) => ShoutData(data)));

    emit("SHOUTS");
  }

  void sendShout(String shout) {
    _logger.i("sendShout: $shout");
    _connection.sendShout(shout);
  }

  void sendMessage(String message) {
    _logger.i("sendMessage: $message to ${_conversation?.username}");
    _connection.sendMessage(message, _conversation?.username ?? "");
  }

  void getConversations() {
    _logger.d("getConversations");
    _connection.getConversations();
  }

  void getMessages() {
    _logger.d("getMessages");

    if (_conversation != null) {
      _connection.getMessages(conversation: _conversation!.guid);
    }
  }

  void getShouts() {
    _shouts.clear();
    _connection.getShouts();
  }

  void getContacts() {
    _logger.d("getContacts");
    _connection.getContacts();
  }
}
