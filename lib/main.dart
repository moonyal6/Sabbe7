import 'package:flutter/material.dart';
import 'package:language_builder/language_builder.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

import 'package:sabbeh_clone/shared/helpers/cache_helper.dart';
import 'package:sabbeh_clone/shared/Languages.dart';
import 'package:sabbeh_clone/ui/pages/authentication/sign_in_page.dart';
import 'package:sabbeh_clone/ui/pages/authentication/sign_up_page.dart';
import 'package:sabbeh_clone/ui/pages/authentication/user_management_page.dart';
import 'package:sabbeh_clone/ui/cubit/counters_cubits/counters_provider.dart';
import 'package:sabbeh_clone/ui/cubit/firebase_cubits/auth/auth_cubit.dart';
import 'package:sabbeh_clone/ui/cubit/firebase_cubits/firestore/firestore_cubit.dart';
import 'package:sabbeh_clone/ui/cubit/settings_cubits/sound_cubit.dart';
import 'package:sabbeh_clone/ui/cubit/settings_cubits/vibration_cubit.dart';
import 'package:sabbeh_clone/ui/pages/home_page.dart';
import 'package:sabbeh_clone/ui/pages/debug_screen.dart';
import 'package:sabbeh_clone/ui/pages/reports/global_report_screen.dart';
import 'package:sabbeh_clone/ui/pages/reports/personal_report.dart';
import 'package:sabbeh_clone/ui/pages/settings_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CacheHelper.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(SabbehApp());
}

class SabbehApp extends StatelessWidget {
  SabbehApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
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
      child: LanguageBuilder(
        defaultLanguage: 'en',
        textsMap: Languages.languages,
        child: ChangeNotifierProvider(
          create: (_) => CountersProvider(),
          child: MaterialApp(
            theme: ThemeData.dark(),
            debugShowCheckedModeBanner: true,
            routes: {
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
