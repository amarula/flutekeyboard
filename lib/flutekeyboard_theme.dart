// Flutter imports:
import 'package:flutter/material.dart';

class FluteKeyboardTheme {
  static final FluteKeyboardTheme _instance = FluteKeyboardTheme._internal();

  factory FluteKeyboardTheme() => _instance;

  FluteKeyboardTheme._internal();

  Color backgroundColor = Colors.transparent;
  Color btnBackgroundColor = Colors.transparent;
  Color btnSpecialBackgroundColor = Colors.transparent;
  TextStyle btnTextStyle = const TextStyle(color: Colors.white);
  Color btnReturnColor = Colors.transparent;
  TextStyle btnSecondaryTextStyle = const TextStyle(color: Colors.grey);
}
