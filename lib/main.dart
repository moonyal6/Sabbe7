import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:language_builder/language_builder.dart';
import 'data/controllers/notification_controller.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

import 'package:sabbeh_clone/shared/helpers/cache_helper.dart';
import 'package:sabbeh_clone/shared/Languages.dart';
import 'package:sabbeh_clone/ui/pages/authentication/sign_in_page.dart';
import 'package:sabbeh_clone/ui/pages/authentication/sign_up_page.dart';
import 'package:sabbeh_clone/ui/pages/authentication/user_management_page.dart';
import 'package:sabbeh_clone/data/controllers/counters_controller.dart';
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

  await NotificationController.initNotification();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  runApp(SabbehApp());
}

class SabbehApp extends StatefulWidget {
  SabbehApp({Key? key}) : super(key: key);
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<SabbehApp> createState() => _SabbehAppState();
}

class _SabbehAppState extends State<SabbehApp> {

  @override
  void initState() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod:         NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:    NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:  NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:  NotificationController.onDismissActionReceivedMethod
    );

    super.initState();
  }

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
          create: (_) => CountersController(),
          child: MaterialApp(
            navigatorKey: SabbehApp.navigatorKey,
            theme: ThemeData.dark(),
            debugShowCheckedModeBanner: true,
            initialRoute: HomePage.route,
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
            // onGenerateRoute: (settings) {
            //   switch (settings.name) {
            //     case '/notification-page':
            //       return MaterialPageRoute(builder: (context) {
            //         final ReceivedAction receivedAction = settings
            //             .arguments as ReceivedAction;
            //         return MyNotificationPage(receivedAction: receivedAction);
            //       });
            //
            //     default:
            //       assert(false, 'Page ${settings.name} not found');
            //       return null;
            //   }
            // },
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
