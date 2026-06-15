library;

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:flutekeyboard/flutekeyboard_layout.dart';
import 'package:flutekeyboard/flutekeyboard_theme.dart';
import 'package:flutekeyboard/layouts/en_layout.dart';
import 'package:flutekeyboard/layouts/numeric_layout.dart';
import 'package:flutekeyboard/src/alphanumeric_keyboard.dart';
import 'package:flutekeyboard/src/base_keyboard.dart';
import 'package:flutekeyboard/src/numeric_keyboard.dart';

enum FluteKeyboardType { numeric, alphanumeric, multiLayout }

class FluteKeyboard extends StatefulWidget {
  final FluteKeyboardType type;
  final TextEditingController textController;
  final double width;
  final double height;

  final String shiftIcon;
  final String shiftActiveIcon;
  final String backspaceIcon;
  final bool hideSpaceText;
  final Layout alphanumericLayout;
  final Layout numericLayout;
  final List<FluteLayout> multiLayouts;
  final FluteLayout? initialMultiLayout;
  final ValueChanged<FluteLayout>? onMultiLayoutChanged;

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
    this.alphanumericLayout = EnLayout.layout,
    this.numericLayout = NumericLayout.layout,
    this.multiLayouts = const [],
    this.initialMultiLayout,
    this.onMultiLayoutChanged,
    this.returnIcon = '',
    this.hideSpaceText = false,
  }) : assert(
          initialMultiLayout == null ||
              multiLayouts.contains(initialMultiLayout),
          'initialMultiLayout must be one of the provided multiLayouts',
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
    if (widget.type != FluteKeyboardType.multiLayout ||
        widget.multiLayouts != oldWidget.multiLayouts ||
        (_pickedLayout != null &&
            !widget.multiLayouts.contains(_pickedLayout))) {
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

    final isMultiLayout = widget.type == FluteKeyboardType.multiLayout;
    final selectedLayout = isMultiLayout
        ? (_pickedLayout ??
            widget.initialMultiLayout ??
            (widget.multiLayouts.isNotEmpty ? widget.multiLayouts.first : null))
        : null;

    return AlphanumericKeyboard(
      textController: widget.textController,
      shiftIcon: widget.shiftIcon,
      shiftActiveIcon: widget.shiftActiveIcon,
      backspaceIcon: widget.backspaceIcon,
      hideSpaceText: widget.hideSpaceText,
      layout: selectedLayout?.layout ?? widget.alphanumericLayout,
      returnIcon: widget.returnIcon,
      onReturn: widget.onReturn,
      layouts: isMultiLayout ? widget.multiLayouts : const [],
      selectedLayout: selectedLayout,
      onLayoutChanged: (layout) {
        setState(() {
          _pickedLayout = layout;
        });
        widget.onMultiLayoutChanged?.call(layout);
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
