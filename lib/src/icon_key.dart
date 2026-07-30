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

  /// Whether holding the key keeps invoking [onPressed] until it is released.
  ///
  /// Only meaningful for keys whose action is repeatable, such as backspace.
  final bool repeatOnLongPress;

  const IconKey({
    super.key,
    required this.icon,
    required this.backgroundColor,
    required this.onPressed,
    this.repeatOnLongPress = false,
  });

  @override
  State<IconKey> createState() => _IconKeyState();
}

class _IconKeyState extends State<IconKey> {
  bool _longPress = false;

  Timer? _repeatTimer;

  void _startRepeat() {
    setState(() {
      _longPress = true;
    });

    if (!widget.repeatOnLongPress) {
      return;
    }

    _repeatTimer?.cancel();
    _repeatTimer = Timer.periodic(
      const Duration(milliseconds: 200),
      (_) => widget.onPressed(),
    );
  }

  void _stopRepeat() {
    _repeatTimer?.cancel();
    _repeatTimer = null;

    if (mounted) {
      setState(() {
        _longPress = false;
      });
    }
  }

  @override
  void dispose() {
    _repeatTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: _startRepeat,
      onLongPressCancel: _stopRepeat,
      onLongPressUp: _stopRepeat,
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
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Image.asset(
                widget.icon,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
