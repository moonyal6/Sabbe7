// import 'package:background_fetch/background_fetch.dart';
// import 'package:sabbeh_clone/shared/helpers/cache_helper.dart';
// import 'package:sabbeh_clone/shared/helpers/notice_helper.dart';
//
// import '../../data/controllers/notification_controller.dart';
//
//
// class BackgroundHelper {
//
//
//   @pragma('vm:entry-point')
//   static void backgroundFetchHeadlessTask(HeadlessTask task) async {
//     NoticeHelper noticeHelper = NoticeHelper();
//     String taskId = task.taskId;
//     bool isTimeout = task.timeout;
//
//     await CacheHelper.saveData(key: 'timeout', value: isTimeout);
//     if (isTimeout) {
//       await noticeHelper.stopRepeatingNotification();
//       await NoticeHelper.createTimeOutNotification();
//       print("[BackgroundFetch] Headless task timed-out: $taskId");
//       BackgroundFetch.finish(taskId);
//       return;
//     }
//
//       print('[BackgroundFetch] Headless event received.');
//     await NotificationController.createNewNotification();
//     BackgroundFetch.finish(taskId);
//   }
//
//
//   static Future<void> initPlatformState(bool mounted) async
//   {
//     NoticeHelper noticeHelper = NoticeHelper();
//     await BackgroundFetch.configure(BackgroundFetchConfig(
//         minimumFetchInterval: 15,
//         stopOnTerminate: false,
//         enableHeadless: true,
//         requiresBatteryNotLow: false,
//         requiresCharging: false,
//         requiresStorageNotLow: false,
//         requiresDeviceIdle: false,
//         requiredNetworkType: NetworkType.NONE
//     ),
//
//             (String taskId) async // <-- Event handler
//                 {
//                   await CacheHelper.saveData(key: 'timeout', value: false);
//                   await NoticeHelper.createTestNotification();
//                   print("[BackgroundFetch] Event received $taskId");
//                   // BackgroundFetch.finish(taskId);
//                   },
//
//             (String taskId) async // <-- Task timeout handler.
//                 {
//                   await CacheHelper.saveData(key: 'timeout', value: true);
//                   await noticeHelper.stopRepeatingNotification();
//                   await NoticeHelper.createTimeOutNotification();
//                   print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
//                   // BackgroundFetch.finish(taskId);
//                 });
//
//     // BackgroundFetch.scheduleTask(TaskConfig(
//     //     taskId: "com.transistorsoft.customtask",
//     //     delay: 5000,  // <-- milliseconds
//     //   stopOnTerminate: false,
//     //   enableHeadless: true,
//     //   periodic: true,
//     // ));
//
//     if (!mounted) return;
//   }
// }
