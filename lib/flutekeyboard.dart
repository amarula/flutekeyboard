library;

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:flutekeyboard/flutekeyboard_layout.dart';
import 'package:flutekeyboard/flutekeyboard_theme.dart';
import 'package:flutekeyboard/layouts/numeric_layout.dart';
import 'package:flutekeyboard/src/alphanumeric_keyboard.dart';
import 'package:flutekeyboard/src/base_keyboard.dart';
import 'package:flutekeyboard/src/numeric_keyboard.dart';

enum FluteKeyboardType { numeric, alphanumeric }

class FluteKeyboard extends StatefulWidget {
  final FluteKeyboardType type;
  final TextEditingController textController;
  final double width;
  final double height;

  final String shiftIcon;
  final String shiftActiveIcon;
  final String backspaceIcon;
  final String languageIcon;
  final bool hideSpaceText;
  final List<FluteLayout> alphanumericLayouts;
  final FluteLayout? initialAlphanumericLayout;
  final ValueChanged<FluteLayout>? onAlphanumericLayoutChanged;
  final Layout numericLayout;

  final String returnIcon;
  final VoidCallback onReturn;

  late final FluteKeyboardTheme theme;

  FluteKeyboard({
    super.key,
    required this.type,
    required this.textController,
    required this.shiftIcon,
    required this.shiftActiveIcon,
    required this.backspaceIcon,
    required this.onReturn,
    this.width = 480,
    this.height = 240,
    FluteKeyboardTheme? theme,
    this.alphanumericLayouts = const [FluteLayout.en],
    this.initialAlphanumericLayout,
    this.onAlphanumericLayoutChanged,
    this.numericLayout = NumericLayout.layout,
    this.returnIcon = '',
    this.languageIcon = '',
    this.hideSpaceText = false,
  })  : assert(
          alphanumericLayouts.isNotEmpty,
          'alphanumericLayouts must contain at least one layout',
        ),
        assert(
          initialAlphanumericLayout == null ||
              alphanumericLayouts.contains(initialAlphanumericLayout),
          'initialAlphanumericLayout must be one of the provided '
          'alphanumericLayout entries',
        ) {
    this.theme = theme ?? FluteKeyboardTheme();
  }

  @override
  State<FluteKeyboard> createState() => _FluteKeyboardState();
}

class _FluteKeyboardState extends State<FluteKeyboard> {
  FluteLayout? _pickedLayout;

  @override
  void didUpdateWidget(FluteKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Make sure _pickedLayout cannot become stale when changing properties
    if (!listEquals(
            widget.alphanumericLayouts, oldWidget.alphanumericLayouts) ||
        (_pickedLayout != null &&
            !widget.alphanumericLayouts.contains(_pickedLayout))) {
      _pickedLayout = null;
    }
  }

  Widget keyboard() {
    if (widget.type == FluteKeyboardType.numeric) {
      return NumericKeyboard(
        textController: widget.textController,
        backspaceIcon: widget.backspaceIcon,
        layout: widget.numericLayout,
        returnIcon: widget.returnIcon,
        onReturn: widget.onReturn,
      );
    }

    final selectedLayout = _pickedLayout ??
        widget.initialAlphanumericLayout ??
        widget.alphanumericLayouts.first;

    return AlphanumericKeyboard(
      textController: widget.textController,
      shiftIcon: widget.shiftIcon,
      shiftActiveIcon: widget.shiftActiveIcon,
      backspaceIcon: widget.backspaceIcon,
      hideSpaceText: widget.hideSpaceText,
      layout: selectedLayout.layout,
      returnIcon: widget.returnIcon,
      languageIcon: widget.languageIcon,
      onReturn: widget.onReturn,
      layouts: widget.alphanumericLayouts,
      selectedLayout: selectedLayout,
      onLayoutChanged: (layout) {
        setState(() {
          _pickedLayout = layout;
        });
        widget.onAlphanumericLayoutChanged?.call(layout);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FluteKeyboardTheme();

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(color: theme.backgroundColor),
      padding: const EdgeInsets.all(8),
      child: keyboard(),
    );
  }
}
