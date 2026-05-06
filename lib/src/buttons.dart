// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:flutekeyboard/flutekeyboard_keys.dart';
import 'package:flutekeyboard/flutekeyboard_theme.dart';

class Buttons {
  static Widget backspaceButton(
    String icon,
    TextEditingController textController,
  ) {
    final theme = FluteKeyboardTheme();

    return Expanded(
      child: IconKey(
        icon: icon,
        backgroundColor: theme.btnSpecialBackgroundColor,
        onPressed: () {
          final text = textController.text;
          final textSelection = textController.selection;
          final selectionLength = textSelection.end - textSelection.start;

          // There is a selection.
          if (selectionLength > 0) {
            final newText = text.replaceRange(
              textSelection.start,
              textSelection.end,
              '',
            );
            textController.text = newText;
            textController.selection = textSelection.copyWith(
              baseOffset: textSelection.start,
              extentOffset: textSelection.start,
            );
            return;
          }

          // The cursor is at the beginning.
          if (textSelection.start == 0) {
            return;
          }

          // Delete the previous character
          final newStart = textSelection.start - 1;
          final newEnd = textSelection.start;
          final newText = text.replaceRange(
            newStart,
            newEnd,
            '',
          );
          textController.text = newText;
          textController.selection = textSelection.copyWith(
            baseOffset: newStart,
            extentOffset: newStart,
          );
        },
      ),
    );
  }

  static Widget returnButton(
    Function onReturn, {
    String icon = '',
  }) {
    final theme = FluteKeyboardTheme();

    if (icon.isNotEmpty) {
      return Expanded(
        child: IconKey(
          icon: icon,
          backgroundColor: theme.btnReturnColor,
          onPressed: () {
            onReturn();
          },
        ),
      );
    }

    return Expanded(
      child: SpecialKey(
        text: 'return',
        backgroundColor: theme.btnReturnColor,
        onPressed: () {
          onReturn();
        },
      ),
    );
  }

  static Widget blankButton() {
    return Expanded(
      child: Container(
        color: Colors.transparent,
      ),
    );
  }
}
