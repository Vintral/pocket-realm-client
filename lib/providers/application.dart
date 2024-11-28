import 'package:client/connection.dart';
import 'package:client/data/news_item.dart';
import 'package:client/data/rule.dart';
import 'package:client/data/round.dart';
import 'package:eventify/eventify.dart';
import 'package:logger/logger.dart';

class ApplicationProvider extends EventEmitter {
  static final ApplicationProvider _instance = ApplicationProvider._internal();

  factory ApplicationProvider() {
    return _instance;
  }

  final Connection _connection = Connection();
  final Logger _logger = Logger(level: Level.debug);

  final List<Rule> _rules = <Rule>[];
  List<Rule> get rules => _rules;

  final List<NewsItemData> _news = <NewsItemData>[];
  List<NewsItemData> get news => _news;

  final List<RoundData> _activeRounds = <RoundData>[];
  List<RoundData> get activeRounds => _activeRounds;

  final List<RoundData> _finishedRounds = <RoundData>[];
  List<RoundData> get finishedRounds => _finishedRounds;

  ApplicationProvider._internal() {
    _logger.d('Created');

    _connection.on("RULES", null, onRules);
    _connection.on("NEWS", null, onNews);
    _connection.on("ROUNDS", null, onRounds);
    _connection.on("ROUNDS_CHANGED", null, onRoundsChanged);
  }

  void onRules(e, o) {
    _logger.d("onRules");

    _logger.d(e.eventData);

    _rules.addAll(((e.eventData as dynamic)["rules"] as List<dynamic>)
        .map((data) => Rule(data)));
    emit("RULES");
  }

  void onNews(e, o) {
    _logger.d("onNews");

    _logger.d(e.eventData);

    _news.addAll(((e.eventData as dynamic)["news"] as List<dynamic>)
        .map((data) => NewsItemData(data)));
    emit("NEWS");
  }

  void onRounds(e, o) {
    _logger.d("onRounds");

    _logger.d(e.eventData["current"]);
    _logger.d(e.eventData["past"]);

    _activeRounds.addAll(((e.eventData as dynamic)["active"] as List<dynamic>)
        .map((data) => RoundData(data)));
    _finishedRounds.addAll(((e.eventData as dynamic)["past"] as List<dynamic>)
        .map((data) => RoundData(data)));

    emit("ROUNDS");
  }

  void onRoundsChanged(e, o) {
    _logger.d("onRoundsChanged");
    //_rounds.clear();
  }

  void getRules() {
    _logger.d("getRules");
    _connection.getRules();
  }

  void getNews() {
    _logger.d("getNews");
    _connection.getNews();
  }

  void getRounds() {
    _logger.d("getRounds");
    _connection.getRounds();
  }
}
