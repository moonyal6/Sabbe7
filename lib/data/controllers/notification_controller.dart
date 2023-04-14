import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:sabbeh_clone/main.dart';

class NotificationController {

  static Future<void> initNotification() async {
    AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
        null,
        [
          NotificationChannel(
              // channelGroupKey: 'testing',
              channelKey: 'testing',
              channelName: 'testing',
              channelDescription: 'Notification channel for basic tests',
              // defaultColor: Color(0xFF9D50DD),
              // ledColor: Colors.white
        )
        ],
        // Channel groups are only visual and are not required
        // channelGroups: [
        //   NotificationChannelGroup(
        //       channelGroupKey: 'testing',
        //       channelGroupName: 'testing')
        // ],
        debug: true

    );

  }


  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future <void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future <void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future <void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future <void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here

    // Navigate into pages, avoiding to open the notification details page over another details page already opened
    SabbehApp.navigatorKey.currentState?.pushNamedAndRemoveUntil('/notification-page',
            (route) => (route.settings.name != '/notification-page') || route.isFirst,
        arguments: receivedAction);
  }
}