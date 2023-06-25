import 'dart:async';
import 'dart:convert';
import 'dart:io';
// ignore: unnecessary_import
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as image;
import 'package:path_provider/path_provider.dart';
import 'package:sabbeh_clone/shared/helpers/cache_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../constants/cache_constants.dart';


int id = 1;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final StreamController<ReceivedNotificationCustom> didReceiveLocalNotificationStream =
StreamController<ReceivedNotificationCustom>.broadcast();

final StreamController<String?> selectNotificationStream =
StreamController<String?>.broadcast();

const MethodChannel platform =
MethodChannel('dexterx.dev/flutter_local_notifications_example');

// const String portName = 'notification_send_port';

class ReceivedNotificationCustom {
  ReceivedNotificationCustom({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}


NotificationAppLaunchDetails? notificationAppLaunchDetails;

String? selectedNotificationPayload;

/// A notification action which triggers a url launch event
const String urlLaunchActionId = 'id_1';

/// A notification action which triggers a App navigation event
const String navigationActionId = 'id_3';



@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) async{

  if (notificationResponse.actionId == 'add'){
    await CacheHelper.init();
    int oldValue = await CacheHelper.getInteger(key: CacheKeys.backgroundAdding);
    CacheHelper.saveData(key: CacheKeys.backgroundAdding, value: oldValue + 1);
  }

  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
}



@pragma('vm:entry-point')
void notificationTap(NotificationResponse notificationResponse) {
  switch (notificationResponse.notificationResponseType) {
    case NotificationResponseType.selectedNotification:
      selectNotificationStream.add(notificationResponse.payload);
      break;
    case NotificationResponseType.selectedNotificationAction:
      if (notificationResponse.actionId == navigationActionId) {
        selectNotificationStream.add(notificationResponse.payload);
      }
      break;
  }
}






Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}

class NotificationHelper {

  static Future<void> init() async{
    await _configureLocalTimeZone();

    notificationAppLaunchDetails =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      selectedNotificationPayload =
          notificationAppLaunchDetails!.notificationResponse?.payload;
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('sabbeh_icon');

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: notificationTap,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }



  static Future<void> showNotification() async {
    const NotificationDetails notificationDetails =
    NotificationDetails(android: AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker'
    ));
    await flutterLocalNotificationsPlugin.show(
        id++, 'plain title', 'plain body', notificationDetails,
        payload: 'item x'
    );
  }

  static Future<void> showReminderNotification({
    required String title,
    required String body,
    required String actionBtn1,
    required String actionBtn2,
    required RepeatInterval interval
  }) async {
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'reminder',
      'Reminder Channel',
      sound: RawResourceAndroidNotificationSound('slow_spring_board'),
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'add',
          actionBtn1,
          contextual: false,
        ),
        AndroidNotificationAction(
          'dismiss',
          actionBtn2,
          titleColor: Color.fromARGB(255, 255, 0, 0),
        ),
      ],
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.periodicallyShow(
      0, title,
      'Your Reminder, X times each: cnt1, cnt2 and cnt3',
      interval,
      notificationDetails,
      payload: 'item z',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> showNotificationWithActions() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          urlLaunchActionId,
          'Action 1',
          icon: DrawableResourceAndroidBitmap('food'),
          contextual: true,
        ),
        AndroidNotificationAction(
          'id_2',
          'Action 2',
          titleColor: Color.fromARGB(255, 255, 0, 0),
          icon: DrawableResourceAndroidBitmap('secondary_icon'),
        ),
        AndroidNotificationAction(
          navigationActionId,
          'Action 3',
          icon: DrawableResourceAndroidBitmap('secondary_icon'),
          showsUserInterface: true,
          // By default, Android plugin will dismiss the notification when the
          // user tapped on a action (this mimics the behavior on iOS).
          cancelNotification: false,
        ),
      ],
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
        id++, 'plain title', 'plain body', notificationDetails,
        payload: 'item z');
  }

  static Future<void> showNotificationWithTextAction() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'text_id_1',
          'Enter Text',
          icon: DrawableResourceAndroidBitmap('food'),
          inputs: <AndroidNotificationActionInput>[
            AndroidNotificationActionInput(
              label: 'Enter a message',
            ),
          ],
        ),
      ],
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(id++, 'Text Input Notification',
        'Expand to see input action', notificationDetails,
        payload: 'item x');
  }

  static Future<void> showNotificationWithIconAction() async {
    const NotificationDetails notificationDetails = NotificationDetails();
    await flutterLocalNotificationsPlugin.show(
        id++, 'plain title', 'plain body', notificationDetails,
        payload: 'item z');
  }

  static Future<void> showNotificationWithTextChoice() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'text_id_2',
          'Action 2',
          icon: DrawableResourceAndroidBitmap('food'),
          inputs: <AndroidNotificationActionInput>[
            AndroidNotificationActionInput(
              choices: <String>['ABC', 'DEF'],
              allowFreeFormInput: false,
            ),
          ],
          contextual: true,
        ),
      ],
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
        id++, 'plain title', 'plain body', notificationDetails,
        payload: 'item x');
  }



  static Future<void> showNotificationWithNoBody() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
        id++, 'plain title', null, notificationDetails,
        payload: 'item x');
  }

  static Future<void> showNotificationWithNoTitle() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await flutterLocalNotificationsPlugin
        .show(id++, null, 'plain body', notificationDetails, payload: 'item x');
  }

  static Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(--id);
  }

  static Future<void> cancelNotificationWithTag() async {
    await flutterLocalNotificationsPlugin.cancel(--id, tag: 'tag');
  }

  static Future<void> showNotificationCustomSound() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'your other channel id',
      'your other channel name',
      channelDescription: 'your other channel description',
      sound: RawResourceAndroidNotificationSound('slow_spring_board'),
    );
    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
      id++,
      'custom sound notification title',
      'custom sound notification body',
      notificationDetails,
    );
  }

  static Future<void> showNotificationCustomVibrationIconLed() async {
    final Int64List vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    final AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'other custom channel id', 'other custom channel name',
        channelDescription: 'other custom channel description',
        icon: 'secondary_icon',
        largeIcon: const DrawableResourceAndroidBitmap('sample_large_icon'),
        vibrationPattern: vibrationPattern,
        enableLights: true,
        color: const Color.fromARGB(255, 255, 0, 0),
        ledColor: const Color.fromARGB(255, 255, 0, 0),
        ledOnMs: 1000,
        ledOffMs: 500);

    final NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++,
        'title of notification with custom vibration pattern, LED and icon',
        'body of notification with custom vibration pattern, LED and icon',
        notificationDetails);
  }

  static Future<void> zonedScheduleNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }

  static Future<void> zonedScheduleAlarmClockNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        123,
        'scheduled alarm clock title',
        'scheduled alarm clock body',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'alarm_clock_channel', 'Alarm Clock Channel',
                channelDescription: 'Alarm Clock Notification')),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }

  static Future<void> showNotificationWithNoSound() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('silent channel id', 'silent channel name',
        channelDescription: 'silent channel description',
        playSound: false,
        styleInformation: DefaultStyleInformation(true, true));
    const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++, '<b>silent</b> title', '<b>silent</b> body', notificationDetails);
  }

  static Future<void> showSoundUriNotification() async {
    /// this calls a method over a platform channel implemented within the
    /// example app to return the Uri for the default alarm sound and uses
    /// as the notification sound
    final String? alarmUri = await platform.invokeMethod<String>('getAlarmUri');
    final UriAndroidNotificationSound uriSound =
    UriAndroidNotificationSound(alarmUri!);
    final AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('uri channel id', 'uri channel name',
        channelDescription: 'uri channel description',
        sound: uriSound,
        styleInformation: const DefaultStyleInformation(true, true));
    final NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++, 'uri sound title', 'uri sound body', notificationDetails);
  }

  static Future<void> showTimeoutNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('silent channel id', 'silent channel name',
        channelDescription: 'silent channel description',
        timeoutAfter: 3000,
        styleInformation: DefaultStyleInformation(true, true));
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(id++, 'timeout notification',
        'Times out after 3 seconds', notificationDetails);
  }

  static Future<void> showInsistentNotification() async {
    // This value is from: https://developer.android.com/reference/android/app/Notification.html#FLAG_INSISTENT
    const int insistentFlag = 4;
    final AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        additionalFlags: Int32List.fromList(<int>[insistentFlag]));
    final NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++, 'insistent title', 'insistent body', notificationDetails,
        payload: 'item x');
  }

  static Future<void> showBigTextNotification() async {
    const BigTextStyleInformation bigTextStyleInformation =
    BigTextStyleInformation(
      'Lorem <i>ipsum dolor sit</i> amet, consectetur <b>adipiscing elit</b>, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      htmlFormatBigText: true,
      contentTitle: 'overridden <b>big</b> content title',
      htmlFormatContentTitle: true,
      summaryText: 'summary <i>text</i>',
      htmlFormatSummaryText: true,
    );
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'big text channel id', 'big text channel name',
        channelDescription: 'big text channel description',
        styleInformation: bigTextStyleInformation);
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++, 'big text title', 'silent body', notificationDetails);
  }

  static Future<void> showInboxNotification() async {
    final List<String> lines = <String>['line <b>1</b>', 'line <i>2</i>'];
    final InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
        lines,
        htmlFormatLines: true,
        contentTitle: 'overridden <b>inbox</b> context title',
        htmlFormatContentTitle: true,
        summaryText: 'summary <i>text</i>',
        htmlFormatSummaryText: true);
    final AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('inbox channel id', 'inboxchannel name',
        channelDescription: 'inbox channel description',
        styleInformation: inboxStyleInformation);
    final NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++, 'inbox title', 'inbox body', notificationDetails);
  }

  static Future<void> showGroupedNotifications() async {
    const String groupKey = 'com.android.example.WORK_EMAIL';
    const String groupChannelId = 'grouped channel id';
    const String groupChannelName = 'grouped channel name';
    const String groupChannelDescription = 'grouped channel description';
    // example based on https://developer.android.com/training/notify-user/group.html
    const AndroidNotificationDetails firstNotificationAndroidSpecifics =
    AndroidNotificationDetails(groupChannelId, groupChannelName,
        channelDescription: groupChannelDescription,
        importance: Importance.max,
        priority: Priority.high,
        groupKey: groupKey);
    const NotificationDetails firstNotificationPlatformSpecifics =
    NotificationDetails(android: firstNotificationAndroidSpecifics);
    await flutterLocalNotificationsPlugin.show(id++, 'Alex Faarborg',
        'You will not believe...', firstNotificationPlatformSpecifics);
    const AndroidNotificationDetails secondNotificationAndroidSpecifics =
    AndroidNotificationDetails(groupChannelId, groupChannelName,
        channelDescription: groupChannelDescription,
        importance: Importance.max,
        priority: Priority.high,
        groupKey: groupKey);
    const NotificationDetails secondNotificationPlatformSpecifics =
    NotificationDetails(android: secondNotificationAndroidSpecifics);
    await flutterLocalNotificationsPlugin.show(
        id++,
        'Jeff Chang',
        'Please join us to celebrate the...',
        secondNotificationPlatformSpecifics);

    // Create the summary notification to support older devices that pre-date
    /// Android 7.0 (API level 24).
    ///
    /// Recommended to create this regardless as the behaviour may vary as
    /// mentioned in https://developer.android.com/training/notify-user/group
    const List<String> lines = <String>[
      'Alex Faarborg  Check this out',
      'Jeff Chang    Launch Party'
    ];
    const InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
        lines,
        contentTitle: '2 messages',
        summaryText: 'janedoe@example.com');
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(groupChannelId, groupChannelName,
        channelDescription: groupChannelDescription,
        styleInformation: inboxStyleInformation,
        groupKey: groupKey,
        setAsGroupSummary: true);
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++, 'Attention', 'Two messages', notificationDetails);
  }

  static Future<void> showNotificationWithTag() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        tag: 'tag');
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
        id++, 'first notification', null, notificationDetails);
  }



  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<void> showOngoingNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ongoing: true,
        autoCancel: false);
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++,
        'ongoing notification title',
        'ongoing notification body',
        notificationDetails);
  }

  static Future<void> repeatNotificationEvery15Min() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'repeating channel id', 'repeating channel name',
        channelDescription: 'repeating description');
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.periodicallyShow(
      id++,
      'repeating title',
      'repeating body',
      RepeatInterval.everyMinute,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> repeatNotificationEvery30Min() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'repeating channel id', 'repeating channel name',
        channelDescription: 'repeating description');
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.periodicallyShow(
      id++,
      'repeating title',
      'repeating body',
      RepeatInterval.hourly,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> repeatNotificationEvery1H() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'repeating channel id', 'repeating channel name',
        channelDescription: 'repeating description');
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.periodicallyShow(
      id++,
      'repeating title',
      'repeating body',
      RepeatInterval.daily,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> repeatNotificationEvery3H() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'repeating channel id', 'repeating channel name',
        channelDescription: 'repeating description');
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.periodicallyShow(
      id++,
      'repeating title',
      'repeating body',
      RepeatInterval.weekly,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> scheduleDailyTenAMNotification() async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'daily scheduled notification title',
        'daily scheduled notification body',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails('daily notification channel id',
              'daily notification channel name',
              channelDescription: 'daily notification description'),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  /// To test we don't validate past dates when using `matchDateTimeComponents`
  static Future<void> scheduleDailyTenAMLastYearNotification() async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'daily scheduled notification title',
        'daily scheduled notification body',
        tz.TZDateTime(tz.local, now.year - 1, now.month, now.day, 10),
        const NotificationDetails(
          android: AndroidNotificationDetails('daily notification channel id',
              'daily notification channel name',
              channelDescription: 'daily notification description'),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  static Future<void> scheduleWeeklyTenAMNotification() async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'weekly scheduled notification title',
        'weekly scheduled notification body',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails('weekly notification channel id',
              'weekly notification channel name',
              channelDescription: 'weekly notificationdescription'),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  static Future<void> scheduleWeeklyMondayTenAMNotification() async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDateOfTenAM =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
    if (scheduledDateOfTenAM.isBefore(now)) {
      scheduledDateOfTenAM = scheduledDateOfTenAM.add(const Duration(days: 1));
    }
    tz.TZDateTime scheduledDate = scheduledDateOfTenAM;
    while (scheduledDate.weekday != DateTime.monday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'weekly scheduled notification title',
        'weekly scheduled notification body',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails('weekly notification channel id',
              'weekly notification channel name',
              channelDescription: 'weekly notificationdescription'),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  static Future<void> scheduleMonthlyMondayTenAMNotification() async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDateOfTenAM =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
    if (scheduledDateOfTenAM.isBefore(now)) {
      scheduledDateOfTenAM = scheduledDateOfTenAM.add(const Duration(days: 1));
    }
    tz.TZDateTime scheduledDate = scheduledDateOfTenAM;
    while (scheduledDate.weekday != DateTime.monday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'monthly scheduled notification title',
        'monthly scheduled notification body',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails('monthly notification channel id',
              'monthly notification channel name',
              channelDescription: 'monthly notificationdescription'),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime);
  }

  static Future<void> scheduleYearlyMondayTenAMNotification() async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDateOfTenAM =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
    if (scheduledDateOfTenAM.isBefore(now)) {
      scheduledDateOfTenAM = scheduledDateOfTenAM.add(const Duration(days: 1));
    }
    tz.TZDateTime scheduledDate = scheduledDateOfTenAM;
    while (scheduledDate.weekday != DateTime.monday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'yearly scheduled notification title',
        'yearly scheduled notification body',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails('yearly notification channel id',
              'yearly notification channel name',
              channelDescription: 'yearly notification description'),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime);
  }

  tz.TZDateTime _nextInstanceOfTenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  static Future<void> showNotificationWithNoBadge() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('no badge channel', 'no badge name',
        channelDescription: 'no badge description',
        channelShowBadge: false,
        importance: Importance.max,
        priority: Priority.high,
        onlyAlertOnce: true);
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++, 'no badge title', 'no badge body', notificationDetails,
        payload: 'item x');
  }

  static Future<void> showProgressNotification() async {
    id++;
    final int progressId = id;
    const int maxProgress = 5;
    for (int i = 0; i <= maxProgress; i++) {
      await Future<void>.delayed(const Duration(seconds: 1), () async {
        final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('progress channel', 'progress channel',
            channelDescription: 'progress channel description',
            channelShowBadge: false,
            importance: Importance.max,
            priority: Priority.high,
            onlyAlertOnce: true,
            showProgress: true,
            maxProgress: maxProgress,
            progress: i);
        final NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
        await flutterLocalNotificationsPlugin.show(
            progressId,
            'progress notification title',
            'progress notification body',
            notificationDetails,
            payload: 'item x');
      });
    }
  }

  static Future<void> showIndeterminateProgressNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'indeterminate progress channel', 'indeterminate progress channel',
        channelDescription: 'indeterminate progress channel description',
        channelShowBadge: false,
        importance: Importance.max,
        priority: Priority.high,
        onlyAlertOnce: true,
        showProgress: true,
        indeterminate: true);
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++,
        'indeterminate progress notification title',
        'indeterminate progress notification body',
        notificationDetails,
        payload: 'item x');
  }

  static Future<void> showNotificationUpdateChannelDescription() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your updated channel description',
        importance: Importance.max,
        priority: Priority.high,
        channelAction: AndroidNotificationChannelAction.update);
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++,
        'updated notification channel',
        'check settings to see updated channel description',
        notificationDetails,
        payload: 'item x');
  }

  static Future<void> showPublicNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        visibility: NotificationVisibility.public);
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++,
        'public notification title',
        'public notification body',
        notificationDetails,
        payload: 'item x');
  }

  static Future<void> showNotificationWithSubtitle() async {

    const NotificationDetails notificationDetails = NotificationDetails();
    await flutterLocalNotificationsPlugin.show(
        id++,
        'title of notification with a subtitle',
        'body of notification with a subtitle',
        notificationDetails,
        payload: 'item x');
  }

  static Future<void> showNotificationWithIconBadge() async {
    const NotificationDetails notificationDetails = NotificationDetails();
    await flutterLocalNotificationsPlugin.show(
        id++, 'icon badge title', 'icon badge body', notificationDetails,
        payload: 'item x');
  }

  static Future<void> showNotificationsWithThreadIdentifier() async {
    NotificationDetails buildNotificationDetailsForThread(
        String threadIdentifier,
        ) {
      return NotificationDetails();
    }

    final NotificationDetails thread1PlatformChannelSpecifics =
    buildNotificationDetailsForThread('thread1');
    final NotificationDetails thread2PlatformChannelSpecifics =
    buildNotificationDetailsForThread('thread2');

    await flutterLocalNotificationsPlugin.show(id++, 'thread 1',
        'first notification', thread1PlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(id++, 'thread 1',
        'second notification', thread1PlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(id++, 'thread 1',
        'third notification', thread1PlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(id++, 'thread 2',
        'first notification', thread2PlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(id++, 'thread 2',
        'second notification', thread2PlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(id++, 'thread 2',
        'third notification', thread2PlatformChannelSpecifics);
  }

  static Future<void> showNotificationWithTimeSensitiveInterruptionLevel() async {
    const NotificationDetails notificationDetails = NotificationDetails();
    await flutterLocalNotificationsPlugin.show(
        id++,
        'title of time sensitive notification',
        'body of time sensitive notification',
        notificationDetails,
        payload: 'item x');
  }

  static Future<void> showNotificationWithBannerNotInNotificationCentre() async {
    const NotificationDetails notificationDetails = NotificationDetails();
    await flutterLocalNotificationsPlugin.show(
        id++,
        'title of banner notification',
        'body of banner notification',
        notificationDetails,
        payload: 'item x');
  }

  static Future<void> showNotificationInNotificationCentreOnly() async {
    const NotificationDetails notificationDetails = NotificationDetails();
    await flutterLocalNotificationsPlugin.show(
        id++,
        'title of notification shown only in notification centre',
        'body of notification shown only in notification centre',
        notificationDetails,
        payload: 'item x');
  }

  static Future<void> showNotificationWithoutTimestamp() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++, 'plain title', 'plain body', notificationDetails,
        payload: 'item x');
  }

  static Future<void> showNotificationWithCustomTimestamp() async {
    final AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      when: DateTime.now().millisecondsSinceEpoch - 120 * 1000,
    );
    final NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++, 'plain title', 'plain body', notificationDetails,
        payload: 'item x');
  }

  static Future<void> showNotificationWithCustomSubText() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      subText: 'custom subtext',
    );
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++, 'plain title', 'plain body', notificationDetails,
        payload: 'item x');
  }

  static Future<void> showNotificationWithChronometer() async {
    final AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      when: DateTime.now().millisecondsSinceEpoch - 120 * 1000,
      usesChronometer: true,
      chronometerCountDown: true,
    );
    final NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++, 'plain title', 'plain body', notificationDetails,
        payload: 'item x');
  }

  static Future<void> startForegroundService() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.startForegroundService(1, 'plain title', 'plain body',
        notificationDetails: androidNotificationDetails, payload: 'item x');
  }

  static Future<void> startForegroundServiceWithBlueBackgroundNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'color background channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      color: Colors.blue,
      colorized: true,
    );

    /// only using foreground service can color the background
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.startForegroundService(
        1, 'colored background text title', 'colored background text body',
        notificationDetails: androidPlatformChannelSpecifics,
        payload: 'item x');
  }





  static Future<void> showNotificationWithNumber() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        number: 1);
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'icon badge title', 'icon badge body', platformChannelSpecifics,
        payload: 'item x');
  }

  static Future<void> showNotificationWithAudioAttributeAlarm() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your alarm channel id',
      'your alarm channel name',
      channelDescription: 'your alarm channel description',
      importance: Importance.max,
      priority: Priority.high,
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'notification sound controlled by alarm volume',
      'alarm notification sound body',
      platformChannelSpecifics,
    );
  }
}

