import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sabbeh_clone/main.dart';
import 'package:sabbeh_clone/shared/constants/constants.dart';
import 'package:sabbeh_clone/shared/helpers/cache_helper.dart';
import 'package:sabbeh_clone/shared/helpers/notice_helper.dart';
import 'package:sabbeh_clone/data/controllers/counters_controller.dart';

///  *********************************************
///     NOTIFICATION CONTROLLER
///  *********************************************
///

const int delayInSeconds = 10;

class NotificationController {
  static ReceivedAction? initialAction;

  ///  *********************************************
  ///     INITIALIZATIONS
  ///  *********************************************
  ///
  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
        null, //'resource://drawable/res_app_icon',//
        [
          NotificationChannel(
              channelKey: 'basic_channel',
              channelName: 'Basic Channel',
              channelDescription: 'Notification tests as alerts',
              playSound: true,
              onlyAlertOnce: true,
              groupAlertBehavior: GroupAlertBehavior.Children,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: Colors.deepPurple,
              ledColor: Colors.deepPurple)
        ],
        debug: true);

    // Get initial notification action is optional
    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  static ReceivePort? receivePort;
  static Future<void> initializeIsolateReceivePort() async {
    receivePort = ReceivePort('Notification action port in main isolate')
      // ..listen(
      //         (silentData) => onActionReceivedImplementationMethod(silentData))
            ;

    // This initialization only happens on main isolate
    IsolateNameServer.registerPortWithName(
        receivePort!.sendPort, 'notification_action_port');
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS LISTENER
  ///  *********************************************
  ///  Notifications events are only delivered after call this method
  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications()
        .setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onNotificationDisplayedMethod: onNotificationDisplayedMethod
    );
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS
  ///  *********************************************
  ///
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if(receivedAction.buttonKeyPressed == "ADD"){
      await CacheHelper.init();
      print('adding from notification/////////////');
      int savedCount = await CacheHelper.getInteger(key: 'background_adding');
      int addingCount = await CacheHelper.getInteger(key: 'notice_count');
      CacheHelper.saveData(key: 'background_adding', value: savedCount + addingCount);
    }
    // if (receivedAction.actionType == ActionType.SilentAction ||
    //     receivedAction.actionType == ActionType.SilentBackgroundAction) {
    //   // For background actions, you must hold the execution until the end
    //   print(
    //       'Message sent via notification input: "${receivedAction.buttonKeyInput}"');
    //   await executeLongTaskInBackground();
    // } else {
    //   // this process is only necessary when you need to redirect the user
    //   // to a new page or use a valid context, since parallel isolates do not
    //   // have valid context, so you need redirect the execution to main isolate
    //   if (receivePort == null) {
    //     print(
    //         'onActionReceivedMethod was called inside a parallel dart isolate.');
    //     SendPort? sendPort =
    //     IsolateNameServer.lookupPortByName('notification_action_port');
    //
    //     if (sendPort != null) {
    //       print('Redirecting the execution to main isolate process.');
    //       sendPort.send(receivedAction);
    //       return;
    //     }
    //   }
    //
    //   // return onActionReceivedImplementationMethod(receivedAction);
    // }
  }

  static Future<void> onActionReceivedImplementationMethod(
      ReceivedAction receivedAction) async {
    SabbehApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/notification-page',
            (route) =>
        (route.settings.name != '/notification-page') || route.isFirst,
        arguments: receivedAction);
  }


  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future <void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    /// Reschedule new notification when a notification is displayed
    scheduleNewNotification();
  }

  ///  *********************************************
  ///     REQUESTING NOTIFICATION PERMISSIONS
  ///  *********************************************
  ///
  static Future<bool> displayNotificationRationale() async {
    bool userAuthorized = false;
    BuildContext context = SabbehApp.navigatorKey.currentContext!;
    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          //todo change alert ui
          return AlertDialog(
            title: Text('Get Notified!',
                style: Theme.of(context).textTheme.titleLarge),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/animated-bell.gif',
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                    'Allow Awesome Notifications to send you beautiful notifications!'),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Deny',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () async {
                    userAuthorized = true;
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Allow',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.deepPurple),
                  )),
            ],
          );
        });
    return userAuthorized &&
        await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  ///  *********************************************
  ///     BACKGROUND TASKS TEST
  ///  *********************************************
  static Future<void> executeLongTaskInBackground() async {
    print("starting long task");
    await Future.delayed(const Duration(seconds: 4));
    final url = Uri.parse("http://google.com");
    final re = await http.get(url);
    print(re.body);
    print("long task done");
  }

  ///  *********************************************
  ///     NOTIFICATION CREATION METHODS
  ///  *********************************************
  ///
  static Future<void> createNewNotification() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;

    NoticeHelper.createNotification();
  }

  static Future<void> scheduleNewNotification() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;

    Map countersMap = jsonDecode(CacheHelper.getString(key: 'counters'));

    int cacheDelay = await CacheHelper.getInteger(key: 'notice_delay');
    int cacheCount = await CacheHelper.getInteger(key: "notice_count");

    int delayInSeconds = cacheDelay != 0 ? cacheDelay : 1800;
    int count = cacheCount != 0 ? cacheCount : 5;

    print('notice counters data: $countersMap');
    /// set values to default if no value was assigned2
    delayInSeconds = delayInSeconds == 0 ? 900 : delayInSeconds;
    count = count == 0 ? 10 : count;

    String noticeMsg;
    String btn1;
    String btn2;
    String title;
    String and;
    String per;

    String enTitle = "It's time for tasbeeh!";
    String enMsg = "Your reminder: ";
    String enBtn1 = 'Add';
    String enBtn2 = 'Dismiss';
    String enAnd = 'and';
    String enPer = 'times each.';

    String arTitle = "حان وقت التسبيح!";
    String arMsg = "تذكيرك: ";
    String arBtn1 = 'إضافة';
    String arBtn2 = 'تجاهل';
    String arAnd = 'و';
    String arPer = 'مرات لكل ذكر.';

    String trTitle = "Tesbih vakti geldi!";
    String trMsg = "Hatırlatmanız: ";
    String trBtn1 = 'Ekle';
    String trBtn2 = 'İptal';
    String trAnd = 've';
    String trPer = 'kez her biri.';

    String lang = CacheHelper.getString(key: 'lang');

    switch(lang){
      case 'العربية':
        noticeMsg = arMsg;
        btn1 = arBtn1;
        btn2 = arBtn2;
        title = arTitle;
        and = arAnd;
        per = arPer;
        break;
      case 'Türkçe':
        noticeMsg = trMsg;
        btn1 = trBtn1;
        btn2 = trBtn2;
        title = trTitle;
        and = trAnd;
        per = trPer;
        break;
      default:
        noticeMsg = enMsg;
        btn1 = enBtn1;
        btn2 = enBtn2;
        title = enTitle;
        and = enAnd;
        per = enPer;
    }

    int currentLength = 0;
    for(var counter in countersMap.values){
      currentLength++;
      if(currentLength + 1 == countersMap.length) {
        noticeMsg = noticeMsg + ' ${counter['name']} $and';
      }
      else if(currentLength + 1 > countersMap.length){
        noticeMsg = noticeMsg + ' ${counter['name']} ';
      }else{
        noticeMsg = noticeMsg + ' ${counter['name']},';
      }
    }
    noticeMsg = noticeMsg + '$count $per';

    await NoticeHelper.myNotifyScheduleInHours(
      title: title,
      msg:
      noticeMsg,
      delayInSeconds: delayInSeconds,
      repeat: false,
      btns: [btn1, btn2],
      
    );

    print('created notification every $delayInSeconds seconds with count of $count at: ${
        DateTime.now().hour}:${DateTime.now().minute}');
  }

  static Future<void> resetBadgeCounter() async
  {
    await AwesomeNotifications().resetGlobalBadge();
  }

  static Future<void> cancelNotifications() async
  {
    await AwesomeNotifications().cancelAll();
  }



  static void changeInterval(int interval) async
  {
    // int intervalInt;
    // switch(interval){
    //   case NoticeInterval.every15min:
    //     intervalInt = 900;
    //     break;
    //   case NoticeInterval.every30min:
    //     intervalInt = 1800;
    //     break;
    //   case NoticeInterval.every1hour:
    //     intervalInt = 3600;
    //     break;
    //   case NoticeInterval.every3hours:
    //     intervalInt = 10800;
    //     break;
    // }

    await CacheHelper.saveData(key: 'notice_delay', value: interval);
  }

}