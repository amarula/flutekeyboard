// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:flutekeyboard/layouts/symbol_layout.dart';
import 'package:flutekeyboard/src/buttons.dart';
import 'package:flutekeyboard/src/icon_key.dart';
import 'package:flutekeyboard/src/special_key.dart';
import 'package:flutekeyboard/src/text_key.dart';

typedef Layout = List<List>;

class AlphanumericKeyboard extends StatefulWidget {
  final TextEditingController textController;

  final Color btnColor;
  final Color btnSpecialBackgroundColor;

  final String shiftIcon;
  final String shiftActiveIcon;

  final TextStyle btnTextStyle;

  final String backspaceIcon;

  final Layout layout;

  final Function onReturn;

  const AlphanumericKeyboard({
    super.key,
    required this.textController,
    required this.btnColor,
    required this.btnSpecialBackgroundColor,
    required this.btnTextStyle,
    required this.shiftIcon,
    required this.shiftActiveIcon,
    required this.backspaceIcon,
    required this.layout,
    required this.onReturn,
  });

  @override
  State<AlphanumericKeyboard> createState() => _AlphanumericKeyboardState();
}

class _AlphanumericKeyboardState extends State<AlphanumericKeyboard> {
  final double _columnSpacing = 8;
  final double _rowSpacing = 12;

  bool _shiftActive = false;

  Layout _currentLayout = [];

  final List<Widget> _row1 = [];
  final List<Widget> _row2 = [];
  final List<Widget> _row3 = [];
  final List<Widget> _row4 = [];

  void _reloadLayout() {
    _row1.clear();
    _row2.clear();
    _row3.clear();
    _row4.clear();

    for (var i = 0; i < _currentLayout[0].length; i++) {
      _row1.add(_button(_currentLayout[0][i]));
      if (i < _currentLayout[0].length - 1) {
        _row1.add(Padding(padding: EdgeInsets.only(left: _columnSpacing)));
      }
    }

    _row2.add(Padding(padding: EdgeInsets.only(left: _columnSpacing * 4)));
    for (var i = 0; i < _currentLayout[1].length; i++) {
      _row2.add(_button(_currentLayout[1][i]));
      if (i < _currentLayout[1].length - 1) {
        _row2.add(Padding(padding: EdgeInsets.only(left: _columnSpacing)));
      }
    }
    _row2.add(Padding(padding: EdgeInsets.only(left: _columnSpacing * 4)));

    _row3.add(_button(_currentLayout[2][0]));
    _row3.add(Padding(padding: EdgeInsets.only(left: _columnSpacing * 2)));

    for (var i = 1; i < _currentLayout[2].length - 1; i++) {
      _row3.add(_button(_currentLayout[2][i]));
      if (i < _currentLayout[2].length - 2) {
        _row3.add(Padding(padding: EdgeInsets.only(left: _columnSpacing)));
      }
    }
    _row3.add(Padding(padding: EdgeInsets.only(left: _columnSpacing * 2)));
    _row3.add(_button(_currentLayout[2][_currentLayout[2].length - 1]));

    for (var i = 0; i < _currentLayout[3].length; i++) {
      _row4.add(_button(_currentLayout[3][i]));
      if (i < _currentLayout[3].length - 1) {
        _row4.add(Padding(padding: EdgeInsets.only(left: _columnSpacing)));
      }
    }
  }

  Widget _button(dynamic type) {
    if (type is IconKeys) {
      switch (type) {
        case IconKeys.shift:
          return _shiftButton();
        case IconKeys.backspace:
          return Buttons.backspaceButton(widget.backspaceIcon,
              widget.btnSpecialBackgroundColor, widget.textController);
      }
    }

    if (type is SpecialKeys) {
      switch (type) {
        case SpecialKeys.space:
          return _spaceButton();
        case SpecialKeys.symbol1:
          return _symbol1Button();
        case SpecialKeys.symbol2:
          return _symbol2Button();
        case SpecialKeys.alpha:
          return _alphaButton();
        case SpecialKeys.returnK:
          return Buttons.returnButton(widget.btnTextStyle,
              widget.btnSpecialBackgroundColor, widget.onReturn);
      }
    }

    return _textButton(type);
  }

  Widget _textButton(String text) {
    return Expanded(
      child: TextKey(
        textController: widget.textController,
        text: _shiftActive ? text.toUpperCase() : text.toLowerCase(),
        textStyle: widget.btnTextStyle,
        backgroundColor: widget.btnColor,
      ),
    );
  }

  Widget _shiftButton() {
    return Expanded(
      child: IconKey(
        icon: _shiftActive ? widget.shiftActiveIcon : widget.shiftIcon,
        backgroundColor: widget.btnSpecialBackgroundColor,
        onPressed: () {
          setState(() {
            _shiftActive = !_shiftActive;
          });
          _reloadLayout();
        },
      ),
    );
  }

  Widget _spaceButton() {
    return Expanded(
      flex: 3,
      child: SpecialKey(
        text: 'space',
        textStyle: widget.btnTextStyle,
        backgroundColor: widget.btnColor,
        onPressed: () {
          // Cursor is at the end of the text.
          if (widget.textController.selection.start ==
              widget.textController.text.length) {
            widget.textController.text += ' ';
            widget.textController.selection = TextSelection.collapsed(
                offset: widget.textController.text.length);
          } else {
            final oldCursorPos = widget.textController.selection.start;

            widget.textController.text =
                widget.textController.text.replaceRange(
              widget.textController.selection.start,
              widget.textController.selection.end,
              ' ',
            );

            widget.textController.selection = TextSelection.fromPosition(
              TextPosition(offset: oldCursorPos + 1),
            );
          }
        },
      ),
    );
  }

  Widget _symbol1Button() {
    return Expanded(
      child: SpecialKey(
        text: '123',
        textStyle: widget.btnTextStyle,
        backgroundColor: widget.btnSpecialBackgroundColor,
        onPressed: () {
          setState(() {
            _currentLayout = SymbolLayout.layout1;
          });
          _reloadLayout();
        },
      ),
    );
  }

  Widget _symbol2Button() {
    return Expanded(
      child: SpecialKey(
        text: '#+=',
        textStyle: widget.btnTextStyle,
        backgroundColor: widget.btnSpecialBackgroundColor,
        onPressed: () {
          setState(() {
            _currentLayout = SymbolLayout.layout2;
          });
          _reloadLayout();
        },
      ),
    );
  }

  Widget _alphaButton() {
    return Expanded(
      child: SpecialKey(
        text: 'ABC',
        textStyle: widget.btnTextStyle,
        backgroundColor: widget.btnSpecialBackgroundColor,
        onPressed: () {
          setState(() {
            _currentLayout = widget.layout;
          });
          _reloadLayout();
        },
      ),
    );
  }

  @override
  void initState() {
    _currentLayout = widget.layout;
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
            children: _row1,
          ),
        ),
        Padding(padding: EdgeInsets.only(top: _rowSpacing)),
        Expanded(
          child: Row(
            children: _row2,
          ),
        ),
        Padding(padding: EdgeInsets.only(top: _rowSpacing)),
        Expanded(
          child: Row(
            children: _row3,
          ),
        ),
        Padding(padding: EdgeInsets.only(top: _rowSpacing)),
        Expanded(
          child: Row(
            children: _row4,
          ),
        ),
      ],
    );
  }
}
