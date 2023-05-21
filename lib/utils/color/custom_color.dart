import 'package:flutter/material.dart';

class CustomColor {
  static set setPrimaryColor(Color? color) => _kPrimaryColor = color ?? Colors.blue;
  static set setTextColor(Color? color) => _kTextColor = color ?? Colors.black;
  static set setBgColor(Color? color) => _bgColor = color ?? Colors.white;
  static get kPrimaryColor => _kPrimaryColor;
  static get kTextColor => _kTextColor;
  static get bgColor => _bgColor;

  static Color _kPrimaryColor = Color(0xffF37048);
  static Color _kTextColor = Color(0xff000000);
  static Color _bgColor = Color(0xffffffff);
}
