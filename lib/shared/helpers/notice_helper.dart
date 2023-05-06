import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:sabbeh_clone/shared/helpers/cache_helper.dart';


enum NoticeInterval {
  every15min,
  every30min,
  every1hour,
  every3hours,
}


class NoticeHelper {

  static Future<void> createNotification()async
  {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: -1, // -1 is replaced by a random number
            channelKey: 'alerts',
            title: 'Test',
            body:
            "Some Body",
            //'asset://assets/images/balloons-in-sky.jpg',
            notificationLayout: NotificationLayout.Default,
            // payload: {'notificationId': '1234567890'}
        ),
        actionButtons: [
          NotificationActionButton(
              key: 'ADD',
              label: 'Add',
              actionType: ActionType.SilentAction),
          NotificationActionButton(
              key: 'DISMISS',
              label: 'Dismiss',
              actionType: ActionType.DismissAction,
              isDangerousOption: true)
        ]);
  }


  static Future<void> myNotifyScheduleInHours({
    required int delayInSeconds,
    required String title,
    required String msg,
    bool repeat = false,
    required List<String> btns,
  }) async
  {
    var nowDate = DateTime.now().add(Duration(seconds: delayInSeconds));
    String localTimeZone =
    await AwesomeNotifications().getLocalTimeZoneIdentifier();

    await AwesomeNotifications().createNotification(
      schedule: NotificationCalendar(
        //weekday: nowDate.day,
        hour: nowDate.hour,
        minute: nowDate.minute,
        second: nowDate.second,
        repeats: repeat,
        preciseAlarm: true,
        timeZone: localTimeZone,
        //allowWhileIdle: true,
      ),
      // schedule: NotificationCalendar.fromDate(
      //    date: DateTime.now().add(const Duration(seconds: 10))),
      content: NotificationContent(
        id: 17,
        channelKey: 'basic_channel',
        title: '$title',
        body: msg,
        notificationLayout: NotificationLayout.Default,
        //actionType : ActionType.DismissAction,
        color: Colors.black,
        backgroundColor: Colors.black,
        // customSound: 'resource://raw/notif',
        // payload: {'actPag': 'myAct', 'actType': 'food', 'username': username},
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'ADD',
          label: btns[0],
          actionType: ActionType.SilentBackgroundAction,
        ),
        NotificationActionButton(
          key: 'DISMISS',
          label: btns[1],
          actionType: ActionType.DismissAction,
        ),
      ],
    );
  }

}







// final cron = Cron();
//
// static Future<void> initNotification() async {
// AwesomeNotifications().initialize(
// // set the icon to null if you want to use the default app icon
// //   'resource://assets/images/sabbeh_icon.png',
// null,
// [
// NotificationChannel(
// channelGroupKey: 'basic_channel_group',
// channelKey: 'basic_channel',
// channelName: 'Basic notifications',
// channelDescription: 'Notification channel for basic tests',
// // defaultColor: Colors.blue,//Color(0xFF9D50DD),
// ledColor: Colors.white)
// ],
// // Channel groups are only visual and are not required
// channelGroups: [
// NotificationChannelGroup(
// channelGroupKey: 'basic_channel_group',
// channelGroupName: 'Basic group')
// ],
// debug: true
// );
// }
//
//
// static Future<void> createTestNotification() async{
// await AwesomeNotifications().createNotification(
// content: NotificationContent(
// id: 10,
// channelKey: 'basic_channel',
// title: 'Repeating Notification',
// body: "It's time for tasbeeh 'I'",
// ),
// actionButtons: [
// NotificationActionButton(
// key: 'ADD',
// label: 'Add',
// ),
// NotificationActionButton(
// key: 'LATER',
// label: 'Not now',
// ),
// ],
// );
// }
//
//
// static Future<void> createTimeOutNotification() async{
// await AwesomeNotifications().createNotification(
// content: NotificationContent(
// id: 11,
// channelKey: 'basic_channel',
// title: 'Notification Stopped!',
// body: "Background notification timed out.'",
// ),
// actionButtons: [
// NotificationActionButton(
// key: 'ADD',
// label: 'Add',
// ),
// NotificationActionButton(
// key: 'DISMISS ',
// label: 'Not now',
// ),
// ],
// );
// }
//
//
// static void changeInterval(NoticeInterval interval) async
// {
// int intervalInt;
// switch(interval){
// case NoticeInterval.every15min:
// intervalInt = 15;
// break;
// case NoticeInterval.every30min:
// intervalInt = 30;
// break;
// case NoticeInterval.every1hour:
// intervalInt = 100;
// break;
// case NoticeInterval.every3hours:
// intervalInt = 300;
// break;
// }
//
// await CacheHelper.saveData(key: 'interval', value: intervalInt);
// }
//
//
// Future<void> createRepeatingNotification() async{
//   String cronCode;
//   int intervalInt = await CacheHelper.getInteger(key: 'interval');
//
//   NoticeInterval interval =
//   intervalInt == 15 ? NoticeInterval.every15min :
//   intervalInt == 30 ? NoticeInterval.every30min :
//   intervalInt == 100 ? NoticeInterval.every1hour :
//   intervalInt == 300 ? NoticeInterval.every3hours :
//   NoticeInterval.every15min;
//
//   DateTime timeNow() => DateTime.now();
//   print('type: ${interval.toString().split('.').last}');
//   print('started repeating at: ${timeNow().hour}:${timeNow().minute}:${timeNow().second}');
//
//   switch(interval){
//     case NoticeInterval.every15min:
//       cronCode = '*/15 07-23 * * *';
//       break;
//     case NoticeInterval.every30min:
//       cronCode = '*/30 07-23 * * *';
//       break;
//     case NoticeInterval.every1hour:
//       cronCode = '0 07-23/1 * * *';
//       break;
//     case NoticeInterval.every3hours:
//       cronCode = '0 07-23/3 * * *';
//       break;
//   }
//
//   print('crone parse: $cronCode');
//   await cron.schedule(Schedule.parse(cronCode), () {
//     print('called at: ${timeNow().hour}:${timeNow().minute}:${timeNow().second}');
//
//     AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: 10,
//         channelKey: 'basic_channel',
//         title: 'Repeating Notification',
//         body: "It's time for tasbeeh 'R'",
//       ),
//       actionButtons: [
//         NotificationActionButton(
//           key: 'ADD',
//           label: 'Add',
//         ),
//         NotificationActionButton(
//           key: 'DISMISS',
//           label: 'Not now',
//         ),
//       ],
//     );
//   });
// }
//
//
// Future<void> stopRepeatingNotification() async{
//   await cron.close();
//   await AwesomeNotifications().cancel(10);
// }
//
//
//
//
// /// Use this method to detect when a new notification or a schedule is created
// @pragma("vm:entry-point")
// static Future <void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
// // Your code goes here
// }
//
// /// Use this method to detect every time that a new notification is displayed
// @pragma("vm:entry-point")
// static Future <void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
// // Your code goes here
// }
//
// /// Use this method to detect if the user dismissed a notification
// @pragma("vm:entry-point")
// static Future <void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
// // Your code goes here
// }
//
// /// Use this method to detect when the user taps on a notification or action button
// @pragma("vm:entry-point")
// static Future <void> onActionReceivedMethod(ReceivedAction receivedAction) async {
// // Your code goes here
//
// // Navigate into pages, avoiding to open the notification details page over another details page already opened
// // MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil('/notification-page',
// //         (route) => (route.settings.name != '/notification-page') || route.isFirst,
// //     arguments: receivedAction);
// }
