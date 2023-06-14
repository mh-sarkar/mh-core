import 'package:flutter/material.dart';
import 'package:mh_core/utils/global.dart';

String getTitle(String englishName, String banglaName) {
  return locale == const Locale('en', 'US') ? englishName : banglaName;
}

dynamic getModelInfo(String id, List listData) {
  return listData.where((e) => e.id == id).toList()[0];
}

String getTime(String data) {
  if (data.length == 3) {
    return "${data.replaceAll(':', '')} m 00 s";
  } else if (data.length == 5) {
    return "${data.substring(0, data.indexOf(':'))} m ${data.substring(data.indexOf(':') + 1, data.length)} s";
  } else {
    if(data.length == 8){
      return "${data.substring(0, data.indexOf(':'))} h ${data.substring(data.indexOf(':') + 1, data.nThIndexOf(":", 2))} m ${data.substring(data.nThIndexOf(":", 2) + 1, data.length)} s";
    }else if(data.toLowerCase().contains('hour')) {
      return "${data.substring(0, data.indexOf(' hour,'))} h ${data.substring(data.indexOf('hour,') + 6, data.indexOf(':'))} m ${data.substring(data.indexOf(':') + 1, data.length)} s";
    }else if(data.toLowerCase().contains('minute')) {
      return "${data.substring(0, data.indexOf(' minute,'))} m ${data.substring(data.indexOf('minute,') + 8, data.length)} s";
    }else{
      return "";
    }
  }
}

extension NthOccurrenceOfSubstring on String {
  int nThIndexOf(String stringToFind, int n){
    if(indexOf(stringToFind)== -1)return -1;
    if(n==1) return indexOf(stringToFind);

    int subIndex = -1;
    while(n>0){
      subIndex = indexOf(stringToFind, subIndex+1);
      n--;
    }
    return subIndex;
  }
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
