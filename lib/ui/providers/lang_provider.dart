// import 'package:provider/provider.dart';
// import 'package:flutter/material.dart';
// import 'package:sabbeh_clone/shared/helpers/cache_helper.dart';
//
// import '../../shared/constants/text_constants/arabic_text_constants.dart';
// import '../../shared/constants/text_constants/english_text_constants.dart';
// import '../../shared/constants/text_constants/turkish_text_constants.dart';
//
//
// class LangHelper extends ChangeNotifier{
//   static late Map<String, dynamic> appLang;
//
//   Map<String, dynamic> initLang(){
//     String lang = CacheHelper.getString(key: 'lang');
//     setLang(lang != ''? lang: 'tr');
//     return appLang;
//   }
//
//   void setLang(String? lang) {
//     switch(lang){
//       case 'en':
//         CacheHelper.saveData(key: 'lang', value: 'en');
//         appLang = en;
//         break;
//       case 'ar':
//         CacheHelper.saveData(key: 'lang', value: 'ar');
//         appLang = ar;
//         break;
//       case 'tr':
//         CacheHelper.saveData(key: 'lang', value: 'tr');
//         appLang = tr;
//         break;
//     }
//     notifyListeners();
//   }
// }
