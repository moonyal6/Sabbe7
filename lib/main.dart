import 'package:flutter/material.dart';
import 'package:language_builder/language_builder.dart';
import 'package:sabbeh_clone/shared/Languages.dart';
import 'package:sabbeh_clone/shared/constants/text_constants/arabic_text_constants.dart';
import 'package:sabbeh_clone/shared/constants/text_constants/english_text_constants.dart';
import 'package:sabbeh_clone/shared/constants/text_constants/turkish_text_constants.dart';
import 'package:sabbeh_clone/ui/cubit/counters_cubits/default_counters_cubits/counter_cubit4.dart';
import 'package:sabbeh_clone/ui/cubit/counters_cubits/default_counters_cubits/counter_cubit5.dart';
import 'package:sabbeh_clone/ui/cubit/counters_cubits/default_counters_cubits/counter_cubit6.dart';
import 'firebase_options.dart';

import 'package:sabbeh_clone/shared/helpers/cache_helper.dart';
import 'package:sabbeh_clone/ui/cubit/counters_cubits/default_counters_cubits/counter_cubit1.dart';
import 'package:sabbeh_clone/ui/cubit/counters_cubits/default_counters_cubits/counter_cubit2.dart';
import 'package:sabbeh_clone/ui/cubit/counters_cubits/default_counters_cubits/counter_cubit3.dart';
import 'package:sabbeh_clone/ui/cubit/firebase_cubits/auth/auth_cubit.dart';
import 'package:sabbeh_clone/ui/cubit/firebase_cubits/firestore/firestore_cubit.dart';
import 'package:sabbeh_clone/ui/cubit/settings_cubits/sound_cubit.dart';
import 'package:sabbeh_clone/ui/cubit/settings_cubits/vibration_cubit.dart';
import 'package:sabbeh_clone/ui/pages/authentication/sign_in_page.dart';
import 'package:sabbeh_clone/ui/pages/authentication/sign_up_page.dart';
import 'package:sabbeh_clone/ui/pages/authentication/user_management_page.dart';
import 'package:sabbeh_clone/ui/pages/home_page.dart';
import 'package:sabbeh_clone/ui/pages/debug_screen.dart';
import 'package:sabbeh_clone/ui/pages/reports/global_report_screen.dart';
import 'package:sabbeh_clone/ui/pages/reports/personal_report.dart';
import 'package:sabbeh_clone/ui/pages/settings_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


// Map<String, dynamic> appLang = tr;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CacheHelper.init();
  // await CacheHelper.saveData(key: 'lang', value: appLang['@lang_data']['lang_short']);


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  // String initLang = CacheHelper.getString(key: 'lang');
  // final language = MultiLanguageBloc(
  //     initialLanguage: initLang != ''? initLang: 'tr',
  //     defaultLanguage: 'tr_TR',
  //     // commonRoute: 'common',
  //     supportedLanguages: [
  //       'ar_SA', 'tr_TR', 'en_US'
  //     ]
  // );

  runApp(SabbehApp());
}

class SabbehApp extends StatelessWidget {
  SabbehApp({Key? key}) : super(key: key);




  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>  CounterCubit1(),
        ),
        BlocProvider(
          create: (_) =>  CounterCubit2(),
        ),
        BlocProvider(
          create: (_) =>  CounterCubit3(),
        ),
        BlocProvider(
          create: (_) =>  CounterCubit4(),
        ),
        BlocProvider(
          create: (_) =>  CounterCubit5(),
        ),
        BlocProvider(
          create: (_) =>  CounterCubit6(),
        ),
        BlocProvider(
          create: (_) =>  VibrationCubit(),
        ),
        BlocProvider(
          create: (_) =>  SoundCubit(),
        ),
        BlocProvider(
          create: (_) =>  AuthCubit()..getUserData(uId: CacheHelper.getString(key: 'uid')),
        ),
        BlocProvider(
          create: (_) =>  FirestoreCubit(),
        ),
      ],
      child:
      LanguageBuilder(
        // useDeviceLanguage: false,
        defaultLanguage: 'en',
        textsMap: Languages.languages,
        child:
        MaterialApp(
          theme: ThemeData.dark(),
          debugShowCheckedModeBanner: true,
          // supportedLocales: [
          //   Locale('en', 'US'),
          //   Locale('ar', 'SA'),
          //   Locale('tr', 'TR'),
          // ],
          routes: {
            // SplashScreen.route : (context) => SplashScreen(),
            HomePage.route : (context) => HomePage(),
            SettingsPage.route : (context) => SettingsPage(),
            PersonalReportScreen.route : (context) => PersonalReportScreen(),
            SignInScreen.route : (context) => SignInScreen(),
            SignUpScreen.route : (context) => SignUpScreen(),
            DebugScreen.route : (context) => DebugScreen(),
            GlobalReportScreen.route : (context) => GlobalReportScreen(),
            UserManagementScreen.route : (context) => UserManagementScreen(),
          },
          initialRoute: HomePage.route,
          builder: (context, child) {
            return ScrollConfiguration(behavior: AppScrollBehavior(), child: child!);
          },
        ),
      ),
    );
  }
}


class AppScrollBehavior extends ScrollBehavior{
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
