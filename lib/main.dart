import 'package:flutter/material.dart';
import 'package:language_builder/language_builder.dart';
import 'package:sabbeh_clone/shared/constants/cache_constants.dart';
import 'package:sabbeh_clone/shared/helpers/notice_helper.dart';
import 'package:sabbeh_clone/ui/pages/debug/notifications_page.dart';
import 'data/controllers/notification_controller.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

import 'package:sabbeh_clone/shared/helpers/cache_helper.dart';
import 'package:sabbeh_clone/shared/Languages.dart';
import 'package:sabbeh_clone/ui/pages/authentication/sign_in_page.dart';
import 'package:sabbeh_clone/ui/pages/authentication/sign_up_page.dart';
import 'package:sabbeh_clone/ui/pages/authentication/user_management_page.dart';
import 'package:sabbeh_clone/ui/pages/home_page.dart';
import 'package:sabbeh_clone/data/controllers/counters_controller.dart';
import 'package:sabbeh_clone/data/controllers/settings_controller.dart';
import 'package:sabbeh_clone/ui/cubit/firebase_cubits/auth/auth_cubit.dart';
import 'package:sabbeh_clone/ui/cubit/firebase_cubits/firestore_cubit.dart';
import 'package:sabbeh_clone/ui/cubit/settings_cubits/sound_cubit.dart';
import 'package:sabbeh_clone/ui/cubit/settings_cubits/vibration_cubit.dart';
import 'package:sabbeh_clone/ui/pages/debug/debug_screen.dart';
import 'package:sabbeh_clone/ui/pages/reports/global_report_screen.dart';
import 'package:sabbeh_clone/ui/pages/reports/personal_report.dart';
import 'package:sabbeh_clone/ui/pages/settings_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
// ignore: unnecessary_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


NotificationAppLaunchDetails? notificationAppLaunchDetails;
String NotificationInitialRoute = NotificationsPage.route;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationHelper.init();

  await CacheHelper.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform);

  runApp(SabbehApp());
}



class SabbehApp extends StatefulWidget {
  // SabbehApp({});
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<SabbehApp> createState() => _SabbehAppState();
}

class _SabbehAppState extends State<SabbehApp> {
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
          create: (_) =>  AuthCubit()..getUserData(uId: CacheHelper.getString(
              key: CacheKeys.uId),
          ),
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
            ChangeNotifierProvider(
              create: (_) => NotificationController(),
            )
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
              NotificationsPage.route: (_) => NotificationsPage(),
              SecondPage.route: (_) => SecondPage(selectedNotificationPayload)
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
    await CountersController.get(context, listen: false).dailyReset();
    await CountersController.get(context, listen: false)
        .updateCountersNames();

    SettingsController.get(context, listen: false).notifications
        ? enableNotifications()
        : {
      NotificationHelper.cancelAllNotifications(),
      print('Notifications disabled')
    };

    Navigator.popAndPushNamed(context, HomePage.route);
  }

  void enableNotifications() async{
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    if(pendingNotificationRequests.isEmpty) {
      NotificationController.get(context, listen: false)
          .setNotificationReminder(context);
      print('Enabling Reminder');
    }
    else print('Reminder already enabled');
    print('Pending Notifications: ${pendingNotificationRequests.length}');
  }

  Future<NotificationInterval> getNotificationInterval() async{
    int cacheValue = await CacheHelper.getInteger(key: CacheKeys.noticeInterval);
    switch(cacheValue){
      case 15:
        return NotificationInterval.every15minutes;
      case 30:
        return NotificationInterval.every30minutes;
      case 60:
        return NotificationInterval.every1hour;
      case 180:
        return NotificationInterval.every3hours;
    }
    await CacheHelper.saveData(key: CacheKeys.noticeInterval, value: 30);
    return await getNotificationInterval();
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







