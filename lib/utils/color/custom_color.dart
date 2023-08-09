import 'package:flutter/material.dart';

class CustomColor {
  static setPrimaryColor(Color? color) => _kPrimaryColor = color;
  static set setTextColor(Color? color) => _kTextColor = color;
  static set setBgColor(Color? color) => _bgColor = color;
  static Color get kPrimaryColor => _kPrimaryColor ?? const Color(0xffF37048);
  static get kTextColor => _kTextColor ?? const Color(0xff000000);
  static get bgColor => _bgColor ?? const Color(0xffffffff);

  static Color? _kPrimaryColor;
  static Color? _kTextColor;
  static Color? _bgColor;
}
