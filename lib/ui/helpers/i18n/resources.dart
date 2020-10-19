import 'package:flutter/widgets.dart';

import 'strings/strings.dart';
import 'strings/translations.dart';

class R {
  static Translations translations = PtBr();

  static void load(Locale locale) {
    switch (locale.toString()) {
      default:
        translations = PtBr();
        break;
    }
  }
}
