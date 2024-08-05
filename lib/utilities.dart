import 'package:client/capitalize.dart';
import 'package:client/dictionary.dart';
import 'package:logger/logger.dart';

Logger _logger = Logger(level: Level.off);

int getIntVal(dynamic val) {
  if (val is int) return val;
  if (val is double) return val.truncate();

  return int.tryParse(val) ?? -1;
}

String capitalizeFirst(String str) {
  return str.substring(0, 1).toUpperCase() + str.substring(1);
}

String timeSince(DateTime val, {bool prefixFlag = true}) {
  var diff = DateTime.now().difference(val);
  _logger.t("timeSince: $diff");

  var prefix = prefixFlag ? Dictionary.get("AGO") : "";

  if (diff.inDays > 0) {
    if (diff.inDays > 7) {
      int weeks = (diff.inDays / 7).floor();
      return "$weeks ${Dictionary.get(weeks > 1 ? "WEEKS" : "WEEK")} $prefix";
    }
    return "${diff.inDays} ${Dictionary.get(diff.inDays > 1 ? "DAYS" : "DAY")} $prefix";
  }

  if (diff.inHours > 0) {
    return "${diff.inHours} ${Dictionary.get(diff.inHours > 1 ? "HOURS" : "HOUR")} $prefix";
  }

  if (diff.inMinutes > 0) {
    return "${diff.inMinutes} ${Dictionary.get(diff.inMinutes > 1 ? "MINUTES" : "MINUTE")} $prefix";
  }

  return Dictionary.get("NOW");
}
