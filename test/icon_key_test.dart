// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:flutekeyboard/src/icon_key.dart';

/// A 1x1 transparent PNG, so IconKey has a decodable icon under test.
final _transparentPng = Uint8List.fromList(const [
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, //
  0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
  0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
  0x89, 0x00, 0x00, 0x00, 0x0B, 0x49, 0x44, 0x41,
  0x54, 0x78, 0x9C, 0x63, 0x60, 0x00, 0x02, 0x00,
  0x00, 0x05, 0x00, 0x01, 0x7A, 0x5E, 0xAB, 0x3F,
  0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44,
  0xAE, 0x42, 0x60, 0x82,
]);

class _StubAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    if (key.endsWith('.png')) {
      return ByteData.sublistView(_transparentPng);
    }

    // Everything else, notably the asset manifest, still comes from the test
    // bundle so image resolution behaves normally.
    return rootBundle.load(key);
  }
}

void main() {
  late int pressCount;

  setUp(() {
    pressCount = 0;
  });

  Widget wrap(Widget key) {
    return DefaultAssetBundle(
      bundle: _StubAssetBundle(),
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(width: 80, height: 80, child: key),
          ),
        ),
      ),
    );
  }

  IconKey buildKey({bool repeatOnLongPress = false}) {
    return IconKey(
      icon: 'assets/backspace.png',
      backgroundColor: Colors.grey,
      repeatOnLongPress: repeatOnLongPress,
      onPressed: () => pressCount++,
    );
  }

  // Holds the key past the long-press deadline and a few repeat ticks.
  Future<TestGesture> holdKey(WidgetTester tester) async {
    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(IconKey)),
    );
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 400));

    return gesture;
  }

  group('IconKey long press repeat', () {
    testWidgets('repeats while held when enabled', (tester) async {
      await tester.pumpWidget(wrap(buildKey(repeatOnLongPress: true)));

      await holdKey(tester);

      expect(pressCount, greaterThan(1));
    });

    testWidgets('stops when the pointer is cancelled', (tester) async {
      await tester.pumpWidget(wrap(buildKey(repeatOnLongPress: true)));

      final gesture = await holdKey(tester);
      await gesture.cancel();
      await tester.pump();

      final countAtCancel = pressCount;
      await tester.pump(const Duration(milliseconds: 600));

      expect(pressCount, countAtCancel);
    });

    testWidgets('stops when the pointer is lifted', (tester) async {
      await tester.pumpWidget(wrap(buildKey(repeatOnLongPress: true)));

      final gesture = await holdKey(tester);
      await gesture.up();
      await tester.pump();

      final countAtRelease = pressCount;
      await tester.pump(const Duration(milliseconds: 600));

      expect(pressCount, countAtRelease);
    });

    testWidgets('stops when the key is unmounted mid press', (tester) async {
      await tester.pumpWidget(wrap(buildKey(repeatOnLongPress: true)));

      await holdKey(tester);
      // Drops the key without ever delivering a long press up or cancel, the
      // way a layout switch does. A leaked timer fails teardown here.
      await tester.pumpWidget(wrap(const SizedBox()));

      final countAtUnmount = pressCount;
      await tester.pump(const Duration(milliseconds: 600));

      expect(pressCount, countAtUnmount);
    });

    testWidgets('does not repeat when disabled', (tester) async {
      await tester.pumpWidget(wrap(buildKey()));

      final gesture = await holdKey(tester);
      await gesture.up();
      await tester.pump();

      expect(pressCount, 0);
    });
  });
}
