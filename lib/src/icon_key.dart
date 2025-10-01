// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:flutekeyboard/src/colors_utils.dart';

enum IconKeys {
  shift,
  backspace,
}

class IconKey extends StatefulWidget {
  final String icon;

  final Color backgroundColor;

  final Function onPressed;

  const IconKey({
    super.key,
    required this.icon,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  State<IconKey> createState() => _IconKeyState();
}

class _IconKeyState extends State<IconKey> {
  bool _longPress = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          _longPress = true;
        });
        Timer.periodic(
          const Duration(milliseconds: 200),
          (timer) {
            if (_longPress) {
              widget.onPressed();
            } else {
              timer.cancel();
            }
          },
        );
      },
      onLongPressUp: () {
        setState(() {
          _longPress = false;
        });
      },
      child: ElevatedButton(
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
          backgroundColor: _longPress
              ? ColorsUtils.darken(widget.backgroundColor, 0.2)
              : widget.backgroundColor,
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
        ),
        child: Center(
          child: Image.asset(
            widget.icon,
          ),
        ),
      ),
    );
  }
}
