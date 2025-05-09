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
    "ANGERED_GODS": "you've angered the gods",
    "ADD_FRIEND": "add friend",
    "ATTACK": "attack",
    "AGO": "ago",
    "AVATAR": "avatar",
    "BAZAAR": "bazaar",
    "BLOCKED": "blocked",
    "BLOCK_USER": "block user",
    "BUILD": "build",
    "BUILD_POWER": "build power",
    "BUILDINGS": "buildings",
    "BUY": "buy",
    "CHAT-WITH": "chat with",
    "COMBAT": "combat",
    "COME_BACK": "come back in",
    "CONTACT_SUPPORT": "contact support",
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
    "EXPLORING_GAIN": "exploring gain",
    "EVENTS": "events",
    "EVERY": "every",
    "FEMALE": "female",
    "FINISHED": "finished",
    "FOR": "for",
    "FRIENDS": "friends",
    "GATHERING_GAIN": "gathering gain",
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
    "NO_AUCTIONS": "no auctions",
    "NO_EVENTS": "no events",
    "NO_USERS": "no users",
    "NO_BLOCKED": "no blocked users",
    "NO_ENEMIES": "no enemies",
    "NO_FRIENDS": "no friends",
    "NO_MESSAGES": "no messages",
    "NOTE": "note",
    "NOW": "now",
    "OF": "of",
    "OKAY": "okay",
    "OPTIONAL": "optional",
    "PILLAGE": "pillage",
    "POWER": "power",
    "PLAY": "play",
    "PLAYERS": "players",
    "POPULATION_GROWTH": "population growth",
    "QUANTITY": "quantity",
    "RAID": "raid",
    "RAISE_DEVOTION": "raise devotion",
    "RANKINGS": "rankings",
    "RECENTLY": "recently",
    "RECRUIT": "recruit",
    "REFRESHES_IN": "refreshes in",
    "REMOVE_ENEMY": "remove enemy",
    "REMOVE_FRIEND": "remove friend",
    "RENOUNCE_DEVOTION": "renounce devotion",
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
    "TEMPLE": "temple",
    "TOP": "top",
    "UNBLOCK_USER": "unblock user",
    "UNITS": "units",
    "UPKEEP": "upkeep",
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
    "GET_MESSAGES": "getting messages",
    "REMOVE_ENEMY": "removing enemy",
    "REMOVE_FRIEND": "removing friend",
    "SENDING_MESSAGE": "sending message",
    "UNBLOCK_USER": "unblocking user",
  };

  static String getLoading(String key) {
    return stringsLoading[key] ?? "$missing($key)";
  }
}
