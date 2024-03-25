/// Extension for integer parsing [IntPerse] [String] to [int] value.
///
/// [toInt] method is used to parse [String] to [int] value.
///
/// Usage:
///
/// ```dart
/// String value = '123';
/// int result = value.toInt();
/// ```
///
/// Output:
///
/// ```dart
/// 123
/// ```
///
/// More about extension methods: https://dart.dev/guides/language/extension-methods
extension IntPerse on String {
  int toInt() {
    return int.parse(this);
  }
}

/// Extension for double parsing [DoublePerse] [String] to [double] value.
///
/// [toDouble] method is used to parse [String] to [double] value.
///
/// Usage:
///
/// ```dart
/// String value = '123.45';
/// double result = value.toDouble();
/// ```
///
/// Output:
///
/// ```dart
/// 123.45
/// ```
///
/// More about extension methods: https://dart.dev/guides/language/extension-methods
extension DoublePerse on String {
  double toDouble() {
    return double.parse(this);
  }
}
