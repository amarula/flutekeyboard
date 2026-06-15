// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:flutekeyboard/flutekeyboard_layout.dart';
import 'package:flutekeyboard/flutekeyboard_theme.dart';
import 'package:flutekeyboard/layouts/symbol_layout.dart';
import 'package:flutekeyboard/src/base_keyboard.dart';
import 'package:flutekeyboard/src/buttons.dart';
import 'package:flutekeyboard/src/colors_utils.dart';
import 'package:flutekeyboard/src/icon_key.dart';
import 'package:flutekeyboard/src/special_key.dart';
import 'package:flutekeyboard/src/text_key.dart';

class AlphanumericKeyboard extends BaseKeyboard {
  final String shiftIcon;
  final String shiftActiveIcon;
  final bool hideSpaceText;
  final Layout layout;
  final List<FluteLayout> layouts;
  final FluteLayout? selectedLayout;
  final ValueChanged<FluteLayout>? onLayoutChanged;
  late final FluteKeyboardTheme theme;

  AlphanumericKeyboard({
    super.key,
    required super.textController,
    required super.backspaceIcon,
    required super.returnIcon,
    required super.onReturn,
    required this.shiftIcon,
    required this.shiftActiveIcon,
    required this.layout,
    FluteKeyboardTheme? theme,
    this.hideSpaceText = false,
    this.layouts = const [],
    this.selectedLayout,
    this.onLayoutChanged,
  }) {
    this.theme = theme ?? FluteKeyboardTheme();
  }

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

    // add the switcher at the beginning of the 4th row if the layout doesn't
    // define it.
    final multiLayout = widget.layouts.length > 1;
    final hasLayoutKey =
        _currentLayout.any((row) => row.contains(SpecialKeys.layout));
    if (multiLayout && !hasLayoutKey) {
      _row4.add(_button(SpecialKeys.layout));
      _row4.add(Padding(padding: EdgeInsets.only(left: _columnSpacing)));
    }

    for (var i = 0; i < _currentLayout[3].length; i++) {
      _row4.add(_button(_currentLayout[3][i]));
      if (i < _currentLayout[3].length - 1) {
        _row4.add(Padding(padding: EdgeInsets.only(left: _columnSpacing)));
      }
    }
  }

  Widget _button(dynamic data) {
    if (data is IconKeys) {
      switch (data) {
        case IconKeys.shift:
          return _shiftButton();
        case IconKeys.backspace:
          return Buttons.backspaceButton(
              widget.backspaceIcon, widget.textController);
      }
    }

    if (data is SpecialKeys) {
      switch (data) {
        case SpecialKeys.space:
          return _spaceButton();
        case SpecialKeys.symbol1:
          return _symbol1Button();
        case SpecialKeys.symbol2:
          return _symbol2Button();
        case SpecialKeys.alpha:
          return _alphaButton();
        case SpecialKeys.blank:
          return Buttons.blankButton();
        case SpecialKeys.layout:
          return _layoutButton();
        case SpecialKeys.returnK:
          return Buttons.returnButton(widget.onReturn, icon: widget.returnIcon);
      }
    }

    return _textButton(data);
  }

  Widget _textButton(String text) {
    final mainChar = text.isNotEmpty ? text[0] : '';
    final List<String> alternatives =
        text.length > 1 ? text.substring(1).split('') : [];

    return Expanded(
      child: TextKey(
        text: mainChar,
        alternatives: alternatives,
        isShifted: _shiftActive,
        textController: widget.textController,
        theme: widget.theme,
      ),
    );
  }

  Widget _shiftButton() {
    final theme = FluteKeyboardTheme();

    return Expanded(
      child: IconKey(
        icon: _shiftActive ? widget.shiftActiveIcon : widget.shiftIcon,
        backgroundColor: theme.btnSpecialBackgroundColor,
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
    final theme = FluteKeyboardTheme();

    return Expanded(
      flex: 3,
      child: SpecialKey(
        text: widget.hideSpaceText ? '' : 'space',
        backgroundColor: theme.btnBackgroundColor,
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
    final theme = FluteKeyboardTheme();

    return Expanded(
      child: SpecialKey(
        text: '123',
        backgroundColor: theme.btnSpecialBackgroundColor,
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
    final theme = FluteKeyboardTheme();

    return Expanded(
      child: SpecialKey(
        text: '#+=',
        backgroundColor: theme.btnSpecialBackgroundColor,
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
    final theme = FluteKeyboardTheme();

    return Expanded(
      child: SpecialKey(
        text: 'ABC',
        backgroundColor: theme.btnSpecialBackgroundColor,
        onPressed: () {
          setState(() {
            _currentLayout = widget.layout;
          });
          _reloadLayout();
        },
      ),
    );
  }

  Widget _layoutButton() {
    final theme = FluteKeyboardTheme();

    return Expanded(
      child: Builder(
        builder: (context) => SpecialKey(
          text: widget.selectedLayout?.code ?? '',
          backgroundColor: theme.btnSpecialBackgroundColor,
          onPressed: () => _showLayoutPicker(context),
        ),
      ),
    );
  }

  Color _foregroundColor(BuildContext context, Color backgroundColor) {
    return Theme.of(context).brightness == Brightness.dark
        ? ColorsUtils.lighten(backgroundColor, 1)
        : ColorsUtils.darken(backgroundColor, 1);
  }

  Future<void> _showLayoutPicker(BuildContext buttonContext) async {
    final theme = FluteKeyboardTheme();
    final renderBox = buttonContext.findRenderObject() as RenderBox;
    final overlay =
        Overlay.of(buttonContext).context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        renderBox.localToGlobal(Offset.zero, ancestor: overlay),
        renderBox.localToGlobal(
          renderBox.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final selected = await showMenu<FluteLayout>(
      context: buttonContext,
      position: position,
      color: theme.backgroundColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      items: [
        for (final layout in widget.layouts)
          PopupMenuItem<FluteLayout>(
            value: layout,
            padding: const EdgeInsets.all(6),
            child: Container(
              height: 44,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: layout == widget.selectedLayout
                    ? theme.btnSpecialBackgroundColor
                    : theme.btnBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                layout.displayName,
                style: theme.btnTextStyle.copyWith(
                  color: _foregroundColor(
                    buttonContext,
                    layout == widget.selectedLayout
                        ? theme.btnSpecialBackgroundColor
                        : theme.btnBackgroundColor,
                  ),
                ),
              ),
            ),
          ),
      ],
    );

    if (!mounted || selected == null || selected == widget.selectedLayout) {
      return;
    }

    widget.onLayoutChanged?.call(selected);
  }

  @override
  void initState() {
    _currentLayout = widget.layout;
    _reloadLayout();
    super.initState();
  }

  @override
  void didUpdateWidget(AlphanumericKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.layout != oldWidget.layout) {
      _currentLayout = widget.layout;
      _reloadLayout();
    }
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
