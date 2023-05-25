import 'package:flutter/material.dart';
import 'package:mh_core/utils/global.dart';

String getTitle(String englishName, String banglaName) {
  return locale == const Locale('en', 'US') ? englishName : banglaName;
}

dynamic getModelInfo(String id, List listData) {
  return listData.where((e) => e.id == id).toList()[0];
}
