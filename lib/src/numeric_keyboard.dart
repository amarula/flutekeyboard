// Flutter imports:
import 'package:flutekeyboard/flutekeyboard_theme.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:flutekeyboard/layouts/numeric_layout.dart';
import 'package:flutekeyboard/src/base_keyboard.dart';
import 'package:flutekeyboard/src/buttons.dart';
import 'package:flutekeyboard/src/icon_key.dart';
import 'package:flutekeyboard/src/special_key.dart';
import 'package:flutekeyboard/src/text_key.dart';

class NumericKeyboard extends BaseKeyboard {
  late final FluteKeyboardTheme theme;
  NumericKeyboard({
    super.key,
    required super.textController,
    required super.backspaceIcon,
    required super.returnIcon,
    required super.onReturn,
    FluteKeyboardTheme? theme,
  }) {
    this.theme = theme ?? FluteKeyboardTheme();
  }

  @override
  State<NumericKeyboard> createState() => _NumericKeyboardState();
}

class _NumericKeyboardState extends State<NumericKeyboard> {
  final double _columnSpacing = 8;
  final double _rowSpacing = 12;

  final List<List> _currentLayout = NumericLayout.layout;

  final List<List<Widget>> _rows = [];

  void _reloadLayout() {
    _rows.clear();

    for (var j = 0; j < _currentLayout.length; j++) {
      List<Widget> r = [];
      for (var i = 0; i < _currentLayout[j].length; i++) {
        r.add(_button(_currentLayout[j][i]));
        if (i < _currentLayout[j].length - 1) {
          r.add(Padding(padding: EdgeInsets.only(left: _columnSpacing)));
        }
      }
      _rows.add(r);
    }
  }

  Widget _button(dynamic data) {
    if (data is IconKeys) {
      switch (data) {
        case IconKeys.backspace:
          return Buttons.backspaceButton(
              widget.backspaceIcon, widget.textController);
        default:
          return const Placeholder();
      }
    }

    if (data is SpecialKeys) {
      switch (data) {
        case SpecialKeys.returnK:
          return Buttons.returnButton(widget.onReturn, icon: widget.returnIcon);
        default:
          return const Placeholder();
      }
    }

    return _textButton(data);
  }

  Widget _textButton(String text) {
    return Expanded(
      child: TextKey(
        text: text,
        isShifted: false,
        textController: widget.textController,
        theme: widget.theme,
      ),
    );
  }

  @override
  void initState() {
    _reloadLayout();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: _rows[0],
          ),
        ),
        Padding(padding: EdgeInsets.only(top: _rowSpacing)),
        Expanded(
          child: Row(
            children: _rows[1],
          ),
        ),
        Padding(padding: EdgeInsets.only(top: _rowSpacing)),
        Expanded(
          child: Row(
            children: _rows[2],
          ),
        ),
        Padding(padding: EdgeInsets.only(top: _rowSpacing)),
        Expanded(
          child: Row(
            children: _rows[3],
          ),
        ),
      ],
    );
  }
}
