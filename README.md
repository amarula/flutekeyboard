# Flutekeyboard – Customizable, Multi-Language On-Screen Keyboard

## ✨ Features

- **Alphanumeric and numeric keyboards**
- **Fully customizable UI**
  - Colors
  - Text styles
  - Icons
- **Multi-language layout support**
  - English
  - Italian
  - German
  - French
  - Spanish
  - Portuguese
  - Polish
  - Dutch
  - Czech
  - More to come
- **Symbol pages** (e.g., punctuation, special characters)
- **Custom layout support** – define your own key arrangements
- **Alternative key support** – long-press secondary keys

## 📦 Installation

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  ...
  flutekeyboard: ^latest_version
```

or

```yaml
dependencies:
  ...
  flutekeyboard:
    git:
      url: https://github.com/amarula/flutekeyboard.git
      ref: main
```

To use the keyboard widget import it:

```dart
import 'package:flutekeyboard/flutekeyboard.dart';
```

To create custom layout import:

```dart
import 'package:flutekeyboard/flutekeyboard_keys.dart';
```

## 🚀 Usage

### Basic Alphanumeric Keyboard

```dart
    Expanded(
      child: FluteKeyboard(
        width: 800,
        type: FluteKeyboardType.alphanumeric,
        textController: _textController,
        backgroundColor: const Color.fromARGB(255, 209, 211, 215),
        btnBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
        btnSpecialBackgroundColor:
            const Color.fromARGB(255, 171, 175, 183),
        backspaceIcon: 'assets/backspace.png',
        btnTextStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                ),
        shiftIcon: 'assets/shift.png',
        shiftActiveIcon: 'assets/shift_active.png',
      ),
    ),
```

![Basic Alphanumeric Keyboard](screenshots/basic_alphanum_keyboard.png)

### Language / Layout Picker

Set `type: FluteKeyboardType.multiLayout` and pass `multiLayouts` to add a picker
button (shown automatically once two or more layouts are provided) to the bottom
row. Tapping it opens a menu to switch layout at runtime. Use `initialMultiLayout`
to set the starting layout (defaults to the first entry).

Each `FluteLayout` carries its own key grid, so a custom layout is just another
entry — give it a `code` (button label), a `displayName` (menu label) and a key
grid (see [Custom Alphanumeric Layout](#custom-alphanumeric-layout)). The same
approach overrides a built-in layout.

```dart
import 'package:flutekeyboard/flutekeyboard_layout.dart';

const swedish = FluteLayout(
  code: 'SV',
  displayName: 'Svenska',
  layout: SwedishLayout.layout,
);

FluteKeyboard(
  // ...other parameters
  type: FluteKeyboardType.multiLayout,
  multiLayouts: const [FluteLayout.en, FluteLayout.it, swedish],
  initialMultiLayout: FluteLayout.en,
  onMultiLayoutChanged: (layout) => print(layout.displayName),
)
```

### Custom Alphanumeric Layout

```dart
import 'package:flutekeyboard/flutekeyboard_keys.dart';

class CustomLayout {
  static const List<List> layout = [
    [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '0',
    ],
    [
      'a',
      's',
      'd',
      'f',
      'g',
      'h',
      'j',
      'k',
      'l',
    ],
    [
      IconKeys.shift,
      'z',
      'x',
      'c',
      'v',
      'b',
      'n',
      'm',
      IconKeys.backspace,
    ],
    [
      SpecialKeys.symbol1,
      SpecialKeys.space,
      SpecialKeys.returnK,
    ],
  ];
}
```

![Custom Alphanumeric Keyboard](screenshots/custom_alphanum_keyboard.png)

## Screenshots

<p align="center">
  <img src="screenshots/flutekeyboard.gif" />
</p>