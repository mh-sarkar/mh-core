import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mh_core/utils/global.dart';

String percentCalculation(String mainPrice, String percent, [String discountPrice = '0.0']) {
  mainPrice = mainPrice.replaceAll(',', '').replaceAll('-', '').replaceAll(' ', '').replaceAll('\n', '');
  if (mainPrice.isEmpty) {
    mainPrice = '0.0';
  }
  if (discountPrice != '0.0') {
    discountPrice = discountPrice.replaceAll(',', '').replaceAll('-', '').replaceAll(' ', '').replaceAll('\n', '');
    if (discountPrice.isEmpty) {
      discountPrice = '0.0';
    }
  }
  percent = percent.replaceAll(',', '').replaceAll('-', '').replaceAll(' ', '').replaceAll('\n', '');
  if (percent.isEmpty) {
    return '0';
  }
  final double priceD = double.parse(mainPrice) - double.parse(discountPrice);
  final discountPercent = double.parse(percent) / 100;
  return (priceD * discountPercent).toStringAsFixed(2);
}

dynamic localizationCheckForNumber(dynamic data) {
  if (data == null) return null;
  if (locale.toString() == const Locale('bn_BD').toString()) {
    if (data.toString().contains('.00')) {
      return banNumber(data);
    } else if (data.toString().contains('.0')) {
      data = data.toString().replaceAll('.0', '.00');
      return banNumber(data);
    } else {
      return banNumber(data);
    }
  } else {
    return data;
  }
}

dynamic localizationDateTime(DateTime dateTime, [String dateFormat = 'dd MMM yyyy']) {
  return DateFormat(dateFormat, locale.toString() == const Locale('bn_BD').toString() ? 'bn' : 'en').format(dateTime);
}

dynamic localizationEngForceFully(dynamic data) {
  if (data == null) return null;
  if (locale.toString() == const Locale('bn_BD').toString()) {
    if (data.toString().contains('.00')) {
      return engNumber(data);
    } else if (data.toString().contains('.0')) {
      data = data.toString().replaceAll('.0', '.00');
      return engNumber(data);
    } else {
      return engNumber(data);
    }
  } else {
    return data;
  }
}

dynamic banNumber(String text) {
  for (int i = 0; i < text.length; i++) {
    final newT = numberMultiLan(text[i]);
    text = text.replaceAll(text[i], newT);
  }
  return text;
}

dynamic engNumber(String text) {
  for (int i = 0; i < text.length; i++) {
    final newT = numberEng(text[i]);
    text = text.replaceAll(text[i], newT);
  }
  return text;
}

dynamic numberMultiLan(String number) {
  String newNumber;
  switch (number) {
    case '1':
      newNumber = '১';
      break;

    case '2':
      newNumber = '২';
      break;

    case '3':
      newNumber = '৩';
      break;

    case '4':
      newNumber = '৪';
      break;

    case '5':
      newNumber = '৫';
      break;

    case '6':
      newNumber = '৬';
      break;

    case '7':
      newNumber = '৭';
      break;

    case '8':
      newNumber = '৮';
      break;

    case '9':
      newNumber = '৯';
      break;

    case '0':
      newNumber = '০';
      break;

    default:
      newNumber = number;
      break;
  }
  return newNumber;
}

dynamic numberEng(String number) {
  String newNumber;
  switch (number) {
    case '১':
      newNumber = '1';
      break;

    case '২':
      newNumber = '2';
      break;

    case '৩':
      newNumber = '3';
      break;

    case '৪':
      newNumber = '4';
      break;

    case '৫':
      newNumber = '5';
      break;

    case '৬':
      newNumber = '6';
      break;

    case '৭':
      newNumber = '7';
      break;

    case '৮':
      newNumber = '8';
      break;

    case '৯':
      newNumber = '9';
      break;

    case '০':
      newNumber = '0';
      break;

    default:
      newNumber = number;
      break;
  }
  return newNumber;
}
