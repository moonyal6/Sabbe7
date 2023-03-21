import 'dart:convert';
import 'package:flutter/services.dart';

import 'constants/text_constants/arabic_text_constants.dart';
import 'constants/text_constants/english_text_constants.dart';
import 'constants/text_constants/turkish_text_constants.dart';

class Languages {

  static Map<String, String> languages = {
    "tr": jsonEncode(tr),
    "en": jsonEncode(en),
    "ar": jsonEncode(ar),
    // "Türkçe": jsonEncode(tr),
  };
}