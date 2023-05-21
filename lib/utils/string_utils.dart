import 'dart:io';

import 'package:flutter/material.dart';

String getTitle(String englishName, String banglaName) {
  return Platform.localeName == const Locale('en', 'US') ? englishName : banglaName;
}

dynamic getModelInfo(String id, List listData) {
  return listData.where((e) => e.id == id).toList()[0];
}
