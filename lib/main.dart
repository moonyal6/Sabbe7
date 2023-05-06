import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:language_builder/language_builder.dart';
import 'package:sabbeh_clone/shared/helpers/background_helper.dart';
import 'package:sabbeh_clone/shared/helpers/notice_helper.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

import 'package:sabbeh_clone/shared/helpers/cache_helper.dart';
import 'package:sabbeh_clone/shared/Languages.dart';
import 'package:sabbeh_clone/ui/pages/authentication/sign_in_page.dart';
import 'package:sabbeh_clone/ui/pages/authentication/sign_up_page.dart';
import 'package:sabbeh_clone/ui/pages/authentication/user_management_page.dart';
import 'package:sabbeh_clone/data/controllers/counters_controller.dart';
import 'package:sabbeh_clone/data/controllers/notification_controller.dart';
import 'package:sabbeh_clone/data/controllers/settings_controller.dart';
import 'package:sabbeh_clone/ui/cubit/firebase_cubits/auth/auth_cubit.dart';
import 'package:sabbeh_clone/ui/cubit/firebase_cubits/firestore_cubit.dart';
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

  // await NoticeHelper.initNotification();
  await NotificationController.initializeLocalNotifications();
  await NotificationController.initializeIsolateReceivePort();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(SabbehApp());
  // BackgroundFetch.registerHeadlessTask(BackgroundHelper.backgroundFetchHeadlessTask);
}

class SabbehApp extends StatelessWidget {
  SabbehApp({Key? key}) : super(key: key);

  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

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
        defaultLanguage: 'English',
        textsMap: Languages.languages,
        child:
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => CountersController(),
            ),
            ChangeNotifierProvider(
              create: (_) => SettingsController(),
            ),
          ],
    child:
          MaterialApp(
            theme: ThemeData.dark(),
            debugShowCheckedModeBanner: true,
            routes: {
              InitClass.route : (context) => InitClass(),
              HomePage.route : (context) => HomePage(),
              SettingsPage.route : (context) => SettingsPage(),
              PersonalReportScreen.route : (context) => PersonalReportScreen(),
              SignInScreen.route : (context) => SignInScreen(),
              SignUpScreen.route : (context) => SignUpScreen(),
              DebugScreen.route : (context) => DebugScreen(),
              GlobalReportScreen.route : (context) => GlobalReportScreen(),
              UserManagementScreen.route : (context) => UserManagementScreen(),
            },
            initialRoute: InitClass.route,
            builder: (context, child) {
              return ScrollConfiguration(behavior: AppScrollBehavior(), child: child!);
            },
          ),
        ),
      ),
    );
  }
}

  
class InitClass extends StatefulWidget {
  const InitClass({Key? key}) : super(key: key);
  static String route = 'init';
  @override
  State<InitClass> createState() => _InitClassState();
}

class _InitClassState extends State<InitClass> {
  
  @override
  void initState() {
    super.initState();
    asyncInit();
  }

  asyncInit() async{
    await CountersController.get(context, listen: false).backgroundIncrement(context);


    await NotificationController.cancelNotifications();
    await CountersController.get(context, listen: false)
        .updateCountersNames();
    SettingsController.get(context, listen: false).notifications
        ? NotificationController.scheduleNewNotification() : null;
    Navigator.popAndPushNamed(context, HomePage.route);
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.black);
  }
}




class AppScrollBehavior extends ScrollBehavior{
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}






