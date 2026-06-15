library;

// Project imports:
import 'package:flutekeyboard/layouts/cs_layout.dart';
import 'package:flutekeyboard/layouts/de_layout.dart';
import 'package:flutekeyboard/layouts/en_layout.dart';
import 'package:flutekeyboard/layouts/es_layout.dart';
import 'package:flutekeyboard/layouts/fr_layout.dart';
import 'package:flutekeyboard/layouts/it_layout.dart';
import 'package:flutekeyboard/layouts/nl_layout.dart';
import 'package:flutekeyboard/layouts/pl_layout.dart';
import 'package:flutekeyboard/layouts/pt_layout.dart';
import 'package:flutekeyboard/src/base_keyboard.dart';

/// A selectable keyboard layout shown in the layout picker.
///
/// Each entry pairs a [displayName] (shown in the picker menu) and a short
/// [code] (shown on the picker button) with the alphanumeric key grid [layout]
/// to use. Built-in layouts are available as static constants (e.g.
/// [FluteLayout.en]); define your own by constructing a [FluteLayout] with a
/// custom [layout].
class FluteLayout {
  /// Short code shown on the picker button, e.g. "EN".
  final String code;

  /// Native name shown in the picker menu, e.g. "English".
  final String displayName;

  /// The alphanumeric key grid activated when this layout is selected.
  final Layout layout;

  const FluteLayout({
    required this.code,
    required this.displayName,
    required this.layout,
  });

  static const cs =
      FluteLayout(code: 'CS', displayName: 'Čeština', layout: CsLayout.layout);
  static const de =
      FluteLayout(code: 'DE', displayName: 'Deutsch', layout: DeLayout.layout);
  static const en =
      FluteLayout(code: 'EN', displayName: 'English', layout: EnLayout.layout);
  static const es =
      FluteLayout(code: 'ES', displayName: 'Español', layout: EsLayout.layout);
  static const fr =
      FluteLayout(code: 'FR', displayName: 'Français', layout: FrLayout.layout);
  static const it =
      FluteLayout(code: 'IT', displayName: 'Italiano', layout: ItLayout.layout);
  static const nl = FluteLayout(
      code: 'NL', displayName: 'Nederlands', layout: NlLayout.layout);
  static const pl =
      FluteLayout(code: 'PL', displayName: 'Polski', layout: PlLayout.layout);
  static const pt = FluteLayout(
      code: 'PT', displayName: 'Português', layout: PtLayout.layout);

  @override
  bool operator ==(Object other) =>
      other is FluteLayout &&
      other.code == code &&
      other.displayName == displayName &&
      other.layout == layout;

  @override
  int get hashCode => Object.hash(code, displayName, layout);
}
