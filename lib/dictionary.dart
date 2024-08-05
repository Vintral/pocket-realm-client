class Dictionary {
  static String missing = "/\\/\\1\$\$1Ng";

  static Map<String, String> errors = {
    "NO_RESOURCE_SELECTED": "Select a resource to gather",
    "NOT_ENOUGH_ENERGY": "Not enough energy",
    "CANT_AFFORD": "You can't afford that",
    "MISSING_UNIT": "Unit missing"
  };

  static Map<String, String> strings = {
    "BUILD": "build",
    "RECRUIT": "recruit",
    "RESOURCES": "resources",
    "UNITS": "units",
    "BUILDINGS": "buildings",
    "ITEMS": "items",
    "RULES": "rules",
    "NEWS": "news",
    "SHOUTBOX": "shoutbox",
    "SHOUT": "shout",
    "messages": "messages",
    "EVENTS": "events",
    "WEEKS": "weeks",
    "ROUNDS": "rounds",
    "RANKINGS": "rankings",
    "WEEK": "week",
    "DAYS": "days",
    "DAY": "day",
    "HOURS": "hours",
    "HOUR": "hour",
    "NEAR": "near",
    "TOP": "top",
    "MINUTES": "minutes",
    "MINUTE": "minute",
    "NOW": "now",
    "AGO": "ago",
    "REPLIED": "you replied",
    "SEND": "send",
    "chat-with": "chat with",
    "rule-1": "This is the text for Rule 1",
    "rule-2": "This is the text for Rule 2",
    "rule-3": "This is the text for Rule 3",
    "explore-0": "Error exploring",
    "explore-1": "Invalid energy amount",
    "round-0": "Error getting round",
    "shout-0": "Error sending shout",
  };

  static String get(String key) {
    return strings[key] ?? missing;
  }
}
