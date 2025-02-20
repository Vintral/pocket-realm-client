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
    "ATTACK": "attack",
    "AGO": "ago",
    "BAZAAR": "bazaar",
    "BUILD": "build",
    "BUILDINGS": "buildings",
    "BUY": "buy",
    "CHAT-WITH": "chat with",
    "CURRENT": "current",
    "DAY": "day",
    "DAYS": "days",
    "DEFENSE": "defense",
    "ENDED": "ended",
    "ENDS": "ends",
    "EXPIRES": "expires",
    "EXPIRED": "expired",
    "EVENTS": "events",
    "EVERY": "every",
    "FINISHED": "finished",
    "FOR": "for",
    "HEALTH": "health",
    "HIDE_RANKS": "hide ranks",
    "HOUR": "hour",
    "HOURS": "hours",
    "ITEMS": "items",
    "IN": "in",
    "LAND": "land",
    "MARKET": "market",
    "MAX": "max",
    "MERCENARY": "mercenary",
    "MESSAGES": "messages",
    "MINUTE": "minute",
    "MINUTES": "minutes",
    "NEAR": "near",
    "NEWS": "news",
    "NEW": "new",
    "NO_EVENTS": "no events",
    "NOW": "now",
    "OF": "of",
    "POWER": "power",
    "PLAY": "play",
    "PLAYERS": "players",
    "QUANTITY": "quantity",
    "RESOURCE": "resource",
    "REFRESHES_IN": "refreshes in",
    "SELL": "sell",
    "SHOUT": "shout",
    "SHOUTBOX": "shoutbox",
    "SHOW_RANKS": "show ranks",
    "SMUGGLERS": "smugglers",
    "RANKINGS": "rankings",
    "RECENTLY": "recently",
    "RECRUIT": "recruit",
    "REPLIED": "you replied",
    "RESOURCES": "resources",
    "ROUNDS": "rounds",
    "RULES": "rules",
    "SEND": "send",
    "SOON": "soon",
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
