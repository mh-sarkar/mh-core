import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mh_ui/mh_ui.dart';

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

dynamic localizationDateTime(DateTime dateTime, [String dateFormat = 'dd MMM yyyy']) {
  return DateFormat(dateFormat, locale != null && locale.toString() == const Locale('bn_BD').toString() ? 'bn' : 'en').format(dateTime);
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

dynamic engNumber(String text) {
  for (int i = 0; i < text.length; i++) {
    final newT = numberEng(text[i]);
    text = text.replaceAll(text[i], newT);
  }
  return text;
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

String getStarNumber(dynamic number) {
  if (number == null) {
    return '';
  } else {
    int numLength = number.length;
    String part1 = number.toString().substring(0, numLength - 3 * (numLength / 4).floor());
    String part2 = number.toString().substring(numLength - (numLength / 4).floor(), numLength);

    return '$part1****$part2';
  }
}
