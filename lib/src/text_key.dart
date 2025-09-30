// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:flutekeyboard/flutekeyboard_theme.dart';

class TextKey extends StatefulWidget {
  final String text;
  final List<String> alternatives;
  final bool isShifted;
  final TextEditingController textController;
  late final FluteKeyboardTheme theme;

  TextKey({
    required this.text,
    required this.isShifted,
    required this.textController,
    this.alternatives = const [],
    FluteKeyboardTheme? theme,
    super.key,
  }) {
    this.theme = theme ?? FluteKeyboardTheme();
  }

  @override
  State<TextKey> createState() => _LongPressKeyState();
}

class _LongPressKeyState extends State<TextKey> {
  OverlayEntry? _overlayEntry;
  int _highlightedIndex = -1;

  final GlobalKey _keyGlobal = GlobalKey();
  Size? _keySize;

  Offset _popupPosition = Offset.zero;

  void _showOverlay(BuildContext context) {
    final RenderBox box =
        _keyGlobal.currentContext!.findRenderObject() as RenderBox;
    final Offset buttonPosition = box.localToGlobal(Offset.zero);
    _keySize = box.size;

    final double popupWidth = widget.alternatives.length * _keySize!.width;
    final double screenWidth = MediaQuery.of(context).size.width;

    double left = buttonPosition.dx + _keySize!.width / 2 - popupWidth / 2;

    left = left.clamp(8.0, screenWidth - popupWidth - 24.0);

    _popupPosition = Offset(
      left,
      buttonPosition.dy - _keySize!.height - 2,
    );

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: _popupPosition.dy,
          left: _popupPosition.dx,
          child: Material(
            color: Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(widget.alternatives.length, (index) {
                final char = widget.alternatives[index];
                final isHighlighted = index == _highlightedIndex;

                return Container(
                  width: _keySize!.width,
                  height: _keySize!.height,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: isHighlighted
                        ? widget.theme.btnReturnColor
                        : widget.theme.btnBackgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(blurRadius: 4, color: Colors.black26)
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.isShifted ? char.toUpperCase() : char.toLowerCase(),
                    style: widget.theme.btnTextStyle,
                  ),
                );
              }),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _insertText(String char) {
    char = widget.isShifted ? char.toUpperCase() : char.toLowerCase();

    // Cursor is at the end of the text.
    if (widget.textController.selection.start ==
        widget.textController.text.length) {
      widget.textController.text += char;
      widget.textController.selection =
          TextSelection.collapsed(offset: widget.textController.text.length);
    } else {
      final oldCursorPos = widget.textController.selection.start;

      widget.textController.text = widget.textController.text.replaceRange(
        widget.textController.selection.start,
        widget.textController.selection.end,
        char,
      );

      widget.textController.selection = TextSelection.fromPosition(
        TextPosition(offset: oldCursorPos + 1),
      );
    }
  }

  void _updateHighlight(Offset globalPosition) {
    double localX = globalPosition.dx - _popupPosition.dx;

    int newIndex = -1;

    for (int i = 0; i < widget.alternatives.length; i++) {
      double start = i * _keySize!.width;
      double end = start + _keySize!.width;

      if (localX >= start && localX < end) {
        newIndex = i;
        break;
      }
    }

    if (newIndex != _highlightedIndex) {
      setState(() => _highlightedIndex = newIndex);
      _overlayEntry?.markNeedsBuild();
    }
  }

  void _removeOverlay({bool select = true}) {
    if (_highlightedIndex != -1 && select) {
      _insertText(widget.alternatives[_highlightedIndex]);
    }

    _overlayEntry?.remove();
    _overlayEntry = null;
    _highlightedIndex = -1;
  }

  @override
  Widget build(BuildContext context) {
    final theme = FluteKeyboardTheme();

    return GestureDetector(
      onTap: () => _insertText(widget.text),
      onLongPressStart: (details) {
        if (widget.alternatives.isEmpty) {
          _insertText(widget.text);
          return;
        }

        _showOverlay(context);
      },
      onLongPressMoveUpdate: (details) {
        _updateHighlight(details.globalPosition);
      },
      onLongPressEnd: (_) {
        _removeOverlay();
      },
      onLongPressUp: () {
        _removeOverlay();
      },
      child: Container(
        key: _keyGlobal,
        decoration: BoxDecoration(
            color: theme.btnBackgroundColor,
            borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(
            widget.isShifted
                ? widget.text.toUpperCase()
                : widget.text.toLowerCase(),
            style: theme.btnTextStyle,
          ),
        ),
      ),
    );
  }
}
