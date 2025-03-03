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
    "ADD_ENEMY": "add enemy",
    "REMOVE_ENEMY": "remove enemy",
    "ADD_FRIEND": "add friend",
    "REMOVE_FRIEND": "remove friend",
    "ATTACK": "attack",
    "AGO": "ago",
    "AVATAR": "avatar",
    "BAZAAR": "bazaar",
    "BLOCKED": "blocked",
    "BLOCK_USER": "block user",
    "BUILD": "build",
    "BUILDINGS": "buildings",
    "BUY": "buy",
    "CHAT-WITH": "chat with",
    "COMBAT": "combat",
    "CONTACTS": "contacts",
    "CURRENT": "current",
    "DAY": "day",
    "DAYS": "days",
    "DEFENSE": "defense",
    "ENDED": "ended",
    "ENDS": "ends",
    "ENEMIES": "enemies",
    "EXPIRES": "expires",
    "EXPIRED": "expired",
    "EVENTS": "events",
    "EVERY": "every",
    "FEMALE": "female",
    "FINISHED": "finished",
    "FOR": "for",
    "FRIENDS": "friends",
    "HEALTH": "health",
    "HIDE_RANKS": "hide ranks",
    "HOUR": "hour",
    "HOURS": "hours",
    "ITEMS": "items",
    "IN": "in",
    "LAND": "land",
    "LIBRARY": "library",
    "MALE": "male",
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
    "NO_USERS": "no users",
    "NO_BLOCKED": "no blocked users",
    "NO_ENEMIES": "no enemies",
    "NO_FRIENDS": "no friends",
    "NOTE": "note",
    "NOW": "now",
    "OF": "of",
    "OKAY": "okay",
    "OPTIONAL": "optional",
    "PILLAGE": "pillage",
    "POWER": "power",
    "PLAY": "play",
    "PLAYERS": "players",
    "QUANTITY": "quantity",
    "RAID": "raid",
    "RANKINGS": "rankings",
    "RECENTLY": "recently",
    "RECRUIT": "recruit",
    "REFRESHES_IN": "refreshes in",
    "REPLIED": "you replied",
    "RESOURCE": "resource",
    "RESOURCES": "resources",
    "ROUNDS": "rounds",
    "RULES": "rules",
    "SEARCH": "search",
    "SEARCH_USERS": "search users",
    "SELL": "sell",
    "SEND_MESSAGE": "send message",
    "SHOUT": "shout",
    "SHOUTBOX": "shoutbox",
    "SHOW_RANKS": "show ranks",
    "SKIP": "skip",
    "SMUGGLERS": "smugglers",
    "SEND": "send",
    "SOCIAL": "social",
    "SOON": "soon",
    "STARTS": "starts",
    "TOP": "top",
    "UNBLOCK_USER": "unblock user",
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

  static Map<String, String> stringsLoading = {
    "ADD_ENEMY": "adding enemy",
    "ADD_FRIEND": "adding friend",
    "BLOCK_USER": "block user",
    "REMOVE_ENEMY": "removing enemy",
    "REMOVE_FRIEND": "removing friend",
    "UNBLOCK_USER": "unblocking user",
  };

  static String getLoading(String key) {
    return strings[key] ?? "$missing($key)";
  }
}
