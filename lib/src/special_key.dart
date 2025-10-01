// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:flutekeyboard/flutekeyboard_theme.dart';
import 'package:flutekeyboard/src/colors_utils.dart';

enum SpecialKeys {
  space,
  symbol1,
  symbol2,
  alpha,
  returnK,
}

class SpecialKey extends StatefulWidget {
  final String text;

  final Color backgroundColor;

  final Function onPressed;

  const SpecialKey({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  State<SpecialKey> createState() => _SpecialKeyState();
}

class _SpecialKeyState extends State<SpecialKey> {
  @override
  Widget build(BuildContext context) {
    final theme = FluteKeyboardTheme();

    return ElevatedButton(
      onPressed: () => widget.onPressed(),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        splashFactory: NoSplash.splashFactory,
        foregroundColor: Theme.of(context).brightness == Brightness.dark
            ? ColorsUtils.lighten(widget.backgroundColor, 1)
            : ColorsUtils.darken(widget.backgroundColor, 1),
        backgroundColor: widget.backgroundColor,
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
      ),
      child: Center(
        child: Text(
          widget.text,
          style: theme.btnTextStyle,
        ),
      ),
    );
  }
}
