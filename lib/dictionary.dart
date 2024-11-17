class Dictionary {
  static String missing = "/\\/\\1\$\$1Ng";

  static Map<String, String> errors = {
    "NO_RESOURCE_SELECTED": "Select a resource to gather",
    "NOT_ENOUGH_ENERGY": "Not enough energy",
    "CANT_AFFORD": "You can't afford that",
    "MISSING_UNIT": "Unit missing"
  };

  static Map<String, String> strings = {
    "ACTIVE": "active",
    "AGO": "ago",
    "BUILD": "build",
    "BUILDINGS": "buildings",
    "CHAT-WITH": "chat with",
    "CURRENT": "current",
    "DAY": "day",
    "DAYS": "days",
    "ENDED": "ended",
    "ENDS": "ends",
    "EVENTS": "events",
    "EVERY": "every",
    "FINISHED": "finished",
    "HOUR": "hour",
    "HOURS": "hours",
    "ITEMS": "items",
    "LAND": "land",
    "MAX": "max",
    "MESSAGES": "messages",
    "MINUTE": "minute",
    "MINUTES": "minutes",
    "NEAR": "near",
    "NEWS": "news",
    "NOW": "now",
    "OF": "of",
    "POWER": "power",
    "PLAY": "play",
    "PLAYERS": "players",
    "SHOUT": "shout",
    "SHOUTBOX": "shoutbox",
    "RANKINGS": "rankings",
    "RECRUIT": "recruit",
    "REPLIED": "you replied",
    "RESOURCES": "resources",
    "ROUNDS": "rounds",
    "RULES": "rules",
    "SEND": "send",
    "STARTS": "starts",
    "TOP": "top",
    "UNITS": "units",
    "WEEK": "week",
    "WEEKS": "weeks",
    "rule-1": "This is the text for Rule 1",
    "rule-2": "This is the text for Rule 2",
    "rule-3": "This is the text for Rule 3",
    "explore-0": "Error exploring",
    "explore-1": "Invalid energy amount",
    "round-0": "Error getting round",
    "shout-0": "Error sending shout",
  };

  static String get(String key) {
    return strings[key] ?? "$missing($key)";
  }
}
