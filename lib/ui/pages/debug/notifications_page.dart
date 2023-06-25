import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../data/controllers/notification_controller.dart';
import 'package:timezone/timezone.dart' as tz;
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
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../../shared/helpers/notice_helper.dart';


class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key,}) : super(key: key);

  static const String route = 'notifications';

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {

  bool _notificationsEnabled = false;


  @override
  void initState() {
    super.initState();
    _isAndroidPermissionGranted();
    _requestPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  Future<void> _isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      final bool granted = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled() ??
          false;

      setState(() {
        _notificationsEnabled = granted;
      });
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      final bool? granted = await androidImplementation?.requestPermission();
      setState(() {
        _notificationsEnabled = granted ?? false;
      });
    }
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationStream.stream
        .listen((ReceivedNotificationCustom receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title!)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body!)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        SecondPage(receivedNotification.payload),
                  ),
                );
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) async {
      await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) => SecondPage(payload),
      ));
    });
  }

  @override
  void dispose() {
    didReceiveLocalNotificationStream.close();
    selectNotificationStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                  // child:
                  // Text('Tap on a notification when it appears to trigger'
                  //     ' navigation'),
                ),
                // InfoValueString(
                //   title: 'Did notification launch app?',
                //   value: widget.didNotificationLaunchApp,
                // ),
                // if (widget.didNotificationLaunchApp) ...<Widget>[
                //   const Text('Launch notification details'),
                //   InfoValueString(
                //       title: 'Notification id',
                //       value: widget.notificationAppLaunchDetails!
                //           .notificationResponse?.id),
                //   InfoValueString(
                //       title: 'Action id',
                //       value: widget.notificationAppLaunchDetails!
                //           .notificationResponse?.actionId),
                //   InfoValueString(
                //       title: 'Input',
                //       value: widget.notificationAppLaunchDetails!
                //           .notificationResponse?.input),
                //   InfoValueString(
                //     title: 'Payload:',
                //     value: widget.notificationAppLaunchDetails!
                //         .notificationResponse?.payload,
                //   ),
                // ],
                PaddedTitle('Plain Notifications'),
                PaddedElevatedButton(
                  buttonText: 'Show plain notification with payload',
                  onPressed: () async {
                    await NotificationHelper.showNotification();
                  },
                ),
                PaddedElevatedButton(
                  buttonText:
                  'Show plain notification that has no title with '
                      'payload',
                  onPressed: () async {
                    await NotificationHelper.showNotificationWithNoTitle();
                  },
                ),
                PaddedElevatedButton(
                  buttonText: 'Show plain notification that has no body with '
                      'payload',
                  onPressed: () async {
                    await NotificationHelper.showNotificationWithNoBody();
                  },
                ),
                PaddedTitle('Custom Sound'),
                PaddedElevatedButton(
                  buttonText: 'Show notification with custom sound',
                  onPressed: () async {
                    await NotificationHelper.showNotificationCustomSound();
                  },
                ),
                PaddedElevatedButton(
                  buttonText: 'Show notification with no sound',
                  onPressed: () async {
                    await NotificationHelper.showNotificationWithNoSound();
                  },
                ),
                PaddedTitle('Alarm Clock Scheduled'),
                if (kIsWeb || !Platform.isLinux) ...<Widget>[
                  PaddedElevatedButton(
                    buttonText:
                    'Schedule notification to appear in 5 seconds '
                        'based on local time zone',
                    onPressed: () async {
                      await NotificationHelper.zonedScheduleNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText:
                    'Schedule notification to appear in 5 seconds '
                        'based on local time zone using alarm clock',
                    onPressed: () async {
                      await NotificationHelper.zonedScheduleAlarmClockNotification();
                    },
                  ),
                  PaddedTitle('Notification with Interval'),
                  PaddedElevatedButton(
                    buttonText: 'Repeat notification every 15 minute',
                    onPressed: () async {
                      await NotificationHelper.repeatNotificationEvery15Min();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Repeat notification every 30 minute',
                    onPressed: () async {
                      await NotificationHelper.repeatNotificationEvery30Min();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Repeat notification every hour',
                    onPressed: () async {
                      await NotificationHelper.repeatNotificationEvery1H();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Repeat notification every 3 hours',
                    onPressed: () async {
                      await NotificationHelper.repeatNotificationEvery3H();
                    },
                  ),
                  PaddedTitle('Scheduled Locally'),
                  PaddedElevatedButton(
                    buttonText:
                    'Schedule daily 10:00:00 am notification in your '
                        'local time zone',
                    onPressed: () async {
                      await NotificationHelper.scheduleDailyTenAMNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText:
                    'Schedule daily 10:00:00 am notification in your '
                        "local time zone using last year's date",
                    onPressed: () async {
                      await NotificationHelper.scheduleDailyTenAMLastYearNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText:
                    'Schedule weekly 10:00:00 am notification in your '
                        'local time zone',
                    onPressed: () async {
                      await NotificationHelper.scheduleWeeklyTenAMNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText:
                    'Schedule weekly Monday 10:00:00 am notification '
                        'in your local time zone',
                    onPressed: () async {
                      await NotificationHelper.scheduleWeeklyMondayTenAMNotification();
                    },
                  ),

                ],
                PaddedElevatedButton(
                  buttonText:
                  'Schedule monthly Monday 10:00:00 am notification in '
                      'your local time zone',
                  onPressed: () async {
                    await NotificationHelper.scheduleMonthlyMondayTenAMNotification();
                  },
                ),
                PaddedElevatedButton(
                  buttonText:
                  'Schedule yearly Monday 10:00:00 am notification in '
                      'your local time zone',
                  onPressed: () async {
                    await NotificationHelper.scheduleYearlyMondayTenAMNotification();
                  },
                ),
                PaddedTitle('Notifications Control'),
                PaddedElevatedButton(
                  buttonText: 'Check pending notifications',
                  onPressed: () async {
                    await checkPendingNotificationRequests();
                  },
                ),
                PaddedElevatedButton(
                  buttonText: 'Get active notifications',
                  onPressed: () async {
                    await getActiveNotifications();
                  },
                ),

                PaddedElevatedButton(
                  buttonText: 'Cancel latest notification',
                  onPressed: () async {
                    await NotificationHelper.cancelNotification();
                  },
                ),
                PaddedElevatedButton(
                  buttonText: 'Cancel all notifications',
                  onPressed: () async {
                    await NotificationHelper.cancelAllNotifications();
                  },
                ),
                SizedBox(height: 75),
                const Divider(thickness: 4),
                const Text(
                  'Notifications with actions',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                PaddedElevatedButton(
                  buttonText: 'Show notification with plain actions',
                  onPressed: () async {
                    await NotificationHelper.showNotificationWithActions();
                  },
                ),
                SizedBox(height: 12),
                const Divider(thickness: 6),
                if (Platform.isAndroid) ...<Widget>[
                  const Text(
                    'Android-specific examples',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('notifications enabled: $_notificationsEnabled'),
                  PaddedElevatedButton(
                    buttonText:
                    'Check if notifications are enabled for this app',
                    onPressed: areNotifcationsEnabledOnAndroid,
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Request permission (API 33+)',
                    onPressed: () => _requestPermissions(),
                  ),
                  PaddedElevatedButton(
                    buttonText:
                    'Show plain notification with payload and update '
                        'channel description',
                    onPressed: () async {
                      await NotificationHelper.showNotificationUpdateChannelDescription();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show plain notification as public on every '
                        'lockscreen',
                    onPressed: () async {
                      await NotificationHelper.showPublicNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText:
                    'Show notification with custom vibration pattern, '
                        'red LED and red icon',
                    onPressed: () async {
                      await NotificationHelper.showNotificationCustomVibrationIconLed();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show notification using Android Uri sound',
                    onPressed: () async {
                      await NotificationHelper.showSoundUriNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText:
                    'Show notification that times out after 3 seconds',
                    onPressed: () async {
                      await NotificationHelper.showTimeoutNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show insistent notification',
                    onPressed: () async {
                      await NotificationHelper.showInsistentNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show big text notification',
                    onPressed: () async {
                      await NotificationHelper.showBigTextNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show inbox notification',
                    onPressed: () async {
                      await NotificationHelper.showInboxNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show grouped notifications',
                    onPressed: () async {
                      await NotificationHelper.showGroupedNotifications();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show notification with tag',
                    onPressed: () async {
                      await NotificationHelper.showNotificationWithTag();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Cancel notification with tag',
                    onPressed: () async {
                      await NotificationHelper.cancelNotificationWithTag();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show ongoing notification',
                    onPressed: () async {
                      await NotificationHelper.showOngoingNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText:
                    'Show notification with no badge, alert only once',
                    onPressed: () async {
                      await NotificationHelper.showNotificationWithNoBadge();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText:
                    'Show progress notification - updates every second',
                    onPressed: () async {
                      await NotificationHelper.showProgressNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show indeterminate progress notification',
                    onPressed: () async {
                      await NotificationHelper.showIndeterminateProgressNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show notification without timestamp',
                    onPressed: () async {
                      await NotificationHelper.showNotificationWithoutTimestamp();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show notification with custom timestamp',
                    onPressed: () async {
                      await NotificationHelper.showNotificationWithCustomTimestamp();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show notification with custom sub-text',
                    onPressed: () async {
                      await NotificationHelper.showNotificationWithCustomSubText();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show notification with chronometer',
                    onPressed: () async {
                      await NotificationHelper.showNotificationWithChronometer();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText:
                    'Show notification with number if the launcher '
                        'supports',
                    onPressed: () async {
                      await NotificationHelper.showNotificationWithNumber();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show notification with sound controlled by '
                        'alarm volume',
                    onPressed: () async {
                      await NotificationHelper.showNotificationWithAudioAttributeAlarm();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Create grouped notification channels',
                    onPressed: () async {
                      await createNotificationChannelGroup();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Delete notification channel group',
                    onPressed: () async {
                      await deleteNotificationChannelGroup();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Create notification channel',
                    onPressed: () async {
                      await createNotificationChannel();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Delete notification channel',
                    onPressed: () async {
                      await deleteNotificationChannel();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Get notification channels',
                    onPressed: () async {
                      await getNotificationChannels();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Start foreground service',
                    onPressed: () async {
                      await NotificationHelper.startForegroundService();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText:
                    'Start foreground service with blue background '
                        'notification',
                    onPressed: () async {
                      await NotificationHelper.startForegroundServiceWithBlueBackgroundNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Stop foreground service',
                    onPressed: () async {
                      await stopForegroundService();
                    },
                  ),
                ],
                if (!kIsWeb &&
                    (Platform.isIOS || Platform.isMacOS)) ...<Widget>[
                  const Text(
                    'iOS and macOS-specific examples',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Request permission',
                    onPressed: _requestPermissions,
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show notification with subtitle',
                    onPressed: () async {
                      await NotificationHelper.showNotificationWithSubtitle();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show notification with icon badge',
                    onPressed: () async {
                      await NotificationHelper.showNotificationWithIconBadge();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show notifications with thread identifier',
                    onPressed: () async {
                      await NotificationHelper.showNotificationsWithThreadIdentifier();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText:
                    'Show notification with time sensitive interruption '
                        'level',
                    onPressed: () async {
                      await NotificationHelper.showNotificationWithTimeSensitiveInterruptionLevel();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show notification with banner but not in '
                        'notification centre',
                    onPressed: () async {
                      await NotificationHelper.showNotificationWithBannerNotInNotificationCentre();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText:
                    'Show notification in notification centre only',
                    onPressed: () async {
                      await NotificationHelper.showNotificationInNotificationCentreOnly();
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<void> showFullScreenNotification() async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Turn off your screen'),
        content: const Text(
            'to see the full-screen intent in 5 seconds, press OK and TURN '
                'OFF your screen'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await flutterLocalNotificationsPlugin.zonedSchedule(
                  0,
                  'scheduled title',
                  'scheduled body',
                  tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
                  const NotificationDetails(
                      android: AndroidNotificationDetails(
                          'full screen channel id', 'full screen channel name',
                          channelDescription: 'full screen channel description',
                          priority: Priority.high,
                          importance: Importance.high,
                          fullScreenIntent: true)),
                  androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
                  uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime);

              Navigator.pop(context);
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  Future<void> checkPendingNotificationRequests() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
    await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content:
        Text('${pendingNotificationRequests.length} pending notification '
            'requests'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> createNotificationChannelGroup() async {
    const String channelGroupId = 'your channel group id';
    // create the group first
    const AndroidNotificationChannelGroup androidNotificationChannelGroup =
    AndroidNotificationChannelGroup(
        channelGroupId, 'your channel group name',
        description: 'your channel group description');
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()!
        .createNotificationChannelGroup(androidNotificationChannelGroup);

    // create channels associated with the group
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()!
        .createNotificationChannel(const AndroidNotificationChannel(
        'grouped channel id 1', 'grouped channel name 1',
        description: 'grouped channel description 1',
        groupId: channelGroupId));

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()!
        .createNotificationChannel(const AndroidNotificationChannel(
        'grouped channel id 2', 'grouped channel name 2',
        description: 'grouped channel description 2',
        groupId: channelGroupId));

    await showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text('Channel group with name '
              '${androidNotificationChannelGroup.name} created'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ));
  }

  Future<void> deleteNotificationChannelGroup() async {
    const String channelGroupId = 'your channel group id';
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannelGroup(channelGroupId);

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Channel group with id $channelGroupId deleted'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> stopForegroundService() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.stopForegroundService();
  }

  Future<void> createNotificationChannel() async {
    const AndroidNotificationChannel androidNotificationChannel =
    AndroidNotificationChannel(
      'your channel id 2',
      'your channel name 2',
      description: 'your channel description 2',
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);

    await showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content:
          Text('Channel with name ${androidNotificationChannel.name} '
              'created'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ));
  }

  Future<void> areNotifcationsEnabledOnAndroid() async {
    final bool? areEnabled = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.areNotificationsEnabled();
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(areEnabled == null
              ? 'ERROR: received null'
              : (areEnabled
              ? 'Notifications are enabled'
              : 'Notifications are NOT enabled')),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ));
  }

  Future<void> deleteNotificationChannel() async {
    const String channelId = 'your channel id 2';
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannel(channelId);

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Channel with id $channelId deleted'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> getActiveNotifications() async {
    final Widget activeNotificationsDialogContent =
    await _getActiveNotificationsDialogContent();
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: activeNotificationsDialogContent,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<Widget> _getActiveNotificationsDialogContent() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (androidInfo.version.sdkInt < 23) {
      return const Text(
        '"getActiveNotifications" is available only for Android 6.0 or newer',
      );
    }

    try {
      final List<ActiveNotification>? activeNotifications =
      await flutterLocalNotificationsPlugin.getActiveNotifications();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Active Notifications',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Divider(color: Colors.black),
          if (activeNotifications!.isEmpty)
            const Text('No active notifications'),
          if (activeNotifications.isNotEmpty)
            for (ActiveNotification activeNotification in activeNotifications)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'id: ${activeNotification.id}\n'
                        'channelId: ${activeNotification.channelId}\n'
                        'groupKey: ${activeNotification.groupKey}\n'
                        'tag: ${activeNotification.tag}\n'
                        'title: ${activeNotification.title}\n'
                        'body: ${activeNotification.body}',
                  ),
                  if (Platform.isAndroid && activeNotification.id != null)
                    TextButton(
                      child: const Text('Get messaging style'),
                      onPressed: () {
                        _getActiveNotificationMessagingStyle(
                            activeNotification.id!, activeNotification.tag);
                      },
                    ),
                  const Divider(color: Colors.black),
                ],
              ),
        ],
      );
    } on PlatformException catch (error) {
      return Text(
        'Error calling "getActiveNotifications"\n'
            'code: ${error.code}\n'
            'message: ${error.message}',
      );
    }
  }

  Future<void> _getActiveNotificationMessagingStyle(int id, String? tag) async {
    Widget dialogContent;
    try {
      final MessagingStyleInformation? messagingStyle =
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
          .getActiveNotificationMessagingStyle(id, tag: tag);
      if (messagingStyle == null) {
        dialogContent = const Text('No messaging style');
      } else {
        dialogContent = SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('person: ${_formatPerson(messagingStyle.person)}\n'
                    'conversationTitle: ${messagingStyle.conversationTitle}\n'
                    'groupConversation: ${messagingStyle.groupConversation}'),
                const Divider(color: Colors.black),
                if (messagingStyle.messages == null) const Text('No messages'),
                if (messagingStyle.messages != null)
                  for (final Message msg in messagingStyle.messages!)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('text: ${msg.text}\n'
                            'timestamp: ${msg.timestamp}\n'
                            'person: ${_formatPerson(msg.person)}'),
                        const Divider(color: Colors.black),
                      ],
                    ),
              ],
            ));
      }
    } on PlatformException catch (error) {
      dialogContent = Text(
        'Error calling "getActiveNotificationMessagingStyle"\n'
            'code: ${error.code}\n'
            'message: ${error.message}',
      );
    }

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Messaging style'),
        content: dialogContent,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatPerson(Person? person) {
    if (person == null) {
      return 'null';
    }

    final List<String> attrs = <String>[];
    if (person.name != null) {
      attrs.add('name: "${person.name}"');
    }
    if (person.uri != null) {
      attrs.add('uri: "${person.uri}"');
    }
    if (person.key != null) {
      attrs.add('key: "${person.key}"');
    }
    if (person.important) {
      attrs.add('important: true');
    }
    if (person.bot) {
      attrs.add('bot: true');
    }
    if (person.icon != null) {
      attrs.add('icon: ${_formatAndroidIcon(person.icon)}');
    }
    return 'Person(${attrs.join(', ')})';
  }

  String _formatAndroidIcon(Object? icon) {
    if (icon == null) {
      return 'null';
    }
    if (icon is DrawableResourceAndroidIcon) {
      return 'DrawableResourceAndroidIcon("${icon.data}")';
    } else if (icon is ContentUriAndroidIcon) {
      return 'ContentUriAndroidIcon("${icon.data}")';
    } else {
      return 'AndroidIcon()';
    }
  }

  Future<void> getNotificationChannels() async {
    final Widget notificationChannelsDialogContent =
    await _getNotificationChannelsDialogContent();
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: notificationChannelsDialogContent,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<Widget> _getNotificationChannelsDialogContent() async {
    try {
      final List<AndroidNotificationChannel>? channels =
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
          .getNotificationChannels();

      return Container(
        width: double.maxFinite,
        child: ListView(
          children: <Widget>[
            const Text(
              'Notifications Channels',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Divider(color: Colors.black),
            if (channels?.isEmpty ?? true)
              const Text('No notification channels')
            else
              for (AndroidNotificationChannel channel in channels!)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('id: ${channel.id}\n'
                        'name: ${channel.name}\n'
                        'description: ${channel.description}\n'
                        'groupId: ${channel.groupId}\n'
                        'importance: ${channel.importance.value}\n'
                        'playSound: ${channel.playSound}\n'
                        'sound: ${channel.sound?.sound}\n'
                        'enableVibration: ${channel.enableVibration}\n'
                        'vibrationPattern: ${channel.vibrationPattern}\n'
                        'showBadge: ${channel.showBadge}\n'
                        'enableLights: ${channel.enableLights}\n'
                        'ledColor: ${channel.ledColor}\n'),
                    const Divider(color: Colors.black),
                  ],
                ),
          ],
        ),
      );
    } on PlatformException catch (error) {
      return Text(
        'Error calling "getNotificationChannels"\n'
            'code: ${error.code}\n'
            'message: ${error.message}',
      );
    }
  }

}


class SecondPage extends StatefulWidget {
  const SecondPage(
      this.payload, {
        Key? key,
      }) : super(key: key);

  static const String route = '/secondPage';

  final String? payload;

  @override
  State<StatefulWidget> createState() => SecondPageState();
}

class SecondPageState extends State<SecondPage> {
  String? _payload;

  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Second Screen'),
    ),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('payload ${_payload ?? ''}'),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Go back!'),
          ),
        ],
      ),
    ),
  );
}

class InfoValueString extends StatelessWidget {
  const InfoValueString({
    required this.title,
    required this.value,
    Key? key,
  }) : super(key: key);

  final String title;
  final Object? value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
    child: Text.rich(
      TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: '$title ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: '$value',
          )
        ],
      ),
    ),
  );
}


class PaddedElevatedButton extends StatelessWidget {
  const PaddedElevatedButton({
    required this.buttonText,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
    child: ElevatedButton(
      onPressed: onPressed,
      child: Text(buttonText),
    ),
  );
}


class PaddedTitle extends StatelessWidget {
  const PaddedTitle(
    this.text,
  {Key? key,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
    child: Column(
      children: [
        Divider(),
        SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ],
    )
  );
}