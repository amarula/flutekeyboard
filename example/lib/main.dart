// Flutter imports:
import 'package:flutekeyboard/flutekeyboard_theme.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutekeyboard/flutekeyboard.dart';

// Project imports:
import 'package:example/custom_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutekeyboard Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutekeyboard Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  FluteKeyboardType type = FluteKeyboardType.alphanumeric;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FluteKeyboardTheme();

    theme.backgroundColor = const Color.fromARGB(255, 209, 211, 215);
    theme.btnBackgroundColor = const Color.fromARGB(255, 255, 255, 255);
    theme.btnSpecialBackgroundColor = const Color.fromARGB(255, 171, 175, 183);
    theme.btnReturnColor = Colors.blue.shade100;
    theme.btnTextStyle = const TextStyle(
      color: Colors.black,
      fontSize: 28,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              height: 160,
              padding: const EdgeInsets.all(16),
              child: TextField(
                contextMenuBuilder: null,
                autofocus: true,
                focusNode: _focusNode,
                controller: _textController,
                onTapOutside: (event) {
                  _focusNode.requestFocus();
                },
                decoration: const InputDecoration(
                  hintText: 'Type something',
                  labelStyle: TextStyle(
                    fontSize: 36,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 54,
                  color: Colors.black,
                ),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => setState(
                () {
                  if (type == FluteKeyboardType.alphanumeric) {
                    type = FluteKeyboardType.numeric;
                  } else {
                    type = FluteKeyboardType.alphanumeric;
                  }
                },
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.black12,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.6)),
                minimumSize: const Size(352, 96),
                maximumSize: const Size(352, 96),
              ),
              child: const Text('Switch keyboard'),
            ),
            const Spacer(),
            Expanded(
              flex: 3,
              child: FluteKeyboard(
                width: 800,
                type: type,
                alphanumericLayout: CustomLayout.layout,
                textController: _textController,
                theme: theme,
                backspaceIcon: 'assets/backspace.png',
                shiftIcon: 'assets/shift.png',
                shiftActiveIcon: 'assets/shift_active.png',
                hideSpaceText: true,
                onReturn: () {
                  // ignore: avoid_print
                  print(_textController.text);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
