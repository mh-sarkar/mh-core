import 'package:flutter/material.dart';
import 'package:mh_core/utils/global.dart';

String getTitle(String englishName, String banglaName) {
  return locale == const Locale('en', 'US') ? englishName : banglaName;
}

dynamic getModelInfo(String id, List listData) {
  return listData.where((e) => e.id == id).toList()[0];
}

String timeAgo({required String date}) {
  return DateTime.now().difference(DateTime.parse(date)).inDays == 0
      ? 'Today'
      : (DateTime.now().difference(DateTime.parse(date)).inDays / 7).floor() == 0
          ? '${DateTime.now().difference(DateTime.parse(date)).inDays} days ago'
          : '${(DateTime.now().difference(DateTime.parse(date)).inDays / 7).floor()} weeks ago';
}

String chatTimeAgo({required String date}) {
  return DateTime.now().difference(DateTime.parse(date)).inDays > 7
      ? "${(DateTime.now().difference(DateTime.parse(date)).inDays / 7).floor()} Weeks ago"
      : DateTime.now().difference(DateTime.parse(date)).inHours > 24
          ? "${DateTime.now().difference(DateTime.parse(date)).inDays} Days ago"
          : DateTime.now().difference(DateTime.parse(date)).inMinutes > 60
              ? "${DateTime.now().difference(DateTime.parse(date)).inHours} Hours ago"
              : DateTime.now().difference(DateTime.parse(date)).inSeconds > 60
                  ? "${DateTime.now().difference(DateTime.parse(date)).inMinutes} Mins ago"
                  : "Just now";
}

String getTime(String data) {
  if (data.length == 3) {
    return "${data.replaceAll(':', '')} m 00 s";
  } else if (data.length == 5) {
    return "${data.substring(0, data.indexOf(':'))} m ${data.substring(data.indexOf(':') + 1, data.length)} s";
  } else {
    if (data.length == 8) {
      return "${data.substring(0, data.indexOf(':'))} h ${data.substring(data.indexOf(':') + 1, data.nThIndexOf(":", 2))} m ${data.substring(data.nThIndexOf(":", 2) + 1, data.length)} s";
    } else if (data.toLowerCase().contains('hour')) {
      return data[data.length - 1] == ':'
          ? "${data.substring(0, data.indexOf(' hour,'))} h ${data.substring(data.indexOf('hour,') + 6, data.indexOf(':'))} m 0 s"
          : "${data.substring(0, data.indexOf(' hour,'))} h ${data.substring(data.indexOf('hour,') + 6, data.indexOf(':'))} m ${data.substring(data.indexOf(':') + 1, data.length)} s";
    } else if (data.toLowerCase().contains('minute')) {
      return "${data.substring(0, data.indexOf(' minute,'))} m ${data.substring(data.indexOf('minute,') + 8, data.length)} s";
    } else {
      return "";
    }
  }
}

extension NthOccurrenceOfSubstring on String {
  int nThIndexOf(String stringToFind, int n) {
    if (indexOf(stringToFind) == -1) return -1;
    if (n == 1) return indexOf(stringToFind);

    int subIndex = -1;
    while (n > 0) {
      subIndex = indexOf(stringToFind, subIndex + 1);
      n--;
    }
    return subIndex;
  }
}

String findAndRemove(String rawStringData, String key, String nextPattern) {
  if (rawStringData.isEmpty || !rawStringData.contains(key)) {
    return rawStringData;
  }
  String newString = '';
  // while (rawStringData.isNotEmpty && rawStringData.contains(key)) {
  final getIndex = rawStringData.indexOf(key);
  final subS = rawStringData.substring(getIndex);
  final patternFind = subS.substring(0, subS.indexOf(nextPattern) + 1);
  newString = rawStringData.replaceAll(patternFind, '');
  // }
  return newString;
}

String getTotalTime(List<String> list) {
  int hour = 0;
  int min = 0;
  int sec = 0;

  for (var element in list) {
    final time = getTime(element);
    if (time.contains('h')) {
      hour += int.parse(time.substring(0, time.indexOf('h')));
    }
    if (time.contains('m')) {
      min += int.parse(time.substring(time.indexOf('h') + 1, time.indexOf('m')));
    }
    if (time.contains('s')) {
      sec += int.parse(time.substring(time.indexOf('m') + 1, time.indexOf('s')));
    }
  }

  if (sec > 59) {
    min += (sec / 60).floor();
    sec = sec % 60;
  }
  if (min > 59) {
    hour += (min / 60).floor();
    min = min % 60;
  }

  return "$hour h $min m $sec s";
}

dynamic errorMessageJson(dynamic errorMessage) {
  if (errorMessage.runtimeType == String) {
    return errorMessage;
  }
  final list = [];
  errorMessage.forEach((k, v) {
    final data = v;
    list.addAll(data);
  });
  return list.toString().replaceAll(',', "\n").replaceAll("[", "").replaceAll("]", "");
}
