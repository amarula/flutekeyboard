// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:flutekeyboard/src/text_key.dart';

void main() {
  late TextEditingController controller;

  setUp(() {
    controller = TextEditingController();
  });

  tearDown(() {
    controller.dispose();
  });

  Widget wrap(Widget key) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(width: 80, height: 80, child: key),
        ),
      ),
    );
  }

  TextKey buildKey({
    bool isShifted = false,
    bool showSecondaryValues = false,
    List<String> alternatives = const [],
  }) {
    return TextKey(
      text: 'e',
      alternatives: alternatives,
      isShifted: isShifted,
      showSecondaryValues: showSecondaryValues,
      textController: controller,
    );
  }

  group('TextKey secondary hint', () {
    testWidgets('shows the first alternative when enabled', (tester) async {
      await tester.pumpWidget(
        wrap(buildKey(
            showSecondaryValues: true, alternatives: const ['è', 'é'])),
      );

      expect(find.text('e'), findsOneWidget);
      expect(find.text('è'), findsOneWidget);
      expect(find.text('é'), findsNothing);
    });

    testWidgets('is hidden when showSecondaryValues is false', (tester) async {
      await tester.pumpWidget(
        wrap(buildKey(alternatives: const ['è'])),
      );

      expect(find.text('e'), findsOneWidget);
      expect(find.text('è'), findsNothing);
    });

    testWidgets('is hidden when the key has no alternatives', (tester) async {
      await tester.pumpWidget(
        wrap(buildKey(showSecondaryValues: true)),
      );

      expect(find.text('e'), findsOneWidget);
      expect(
        find.descendant(of: find.byType(TextKey), matching: find.byType(Text)),
        findsOneWidget,
      );
    });

    testWidgets('follows the shift state', (tester) async {
      await tester.pumpWidget(
        wrap(buildKey(
          isShifted: true,
          showSecondaryValues: true,
          alternatives: const ['è'],
        )),
      );

      expect(find.text('E'), findsOneWidget);
      expect(find.text('È'), findsOneWidget);
      expect(find.text('e'), findsNothing);
      expect(find.text('è'), findsNothing);
    });

    testWidgets('is excluded from semantics', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        wrap(buildKey(showSecondaryValues: true, alternatives: const ['è'])),
      );

      final button = tester.getSemantics(find.byType(ElevatedButton));
      expect(button.label, 'e');

      handle.dispose();
    });
  });
}
