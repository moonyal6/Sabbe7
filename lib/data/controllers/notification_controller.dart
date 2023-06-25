import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:language_builder/language_builder.dart';
import 'package:provider/provider.dart';
import 'package:sabbeh_clone/data/controllers/settings_controller.dart';
import 'package:sabbeh_clone/shared/helpers/cache_helper.dart';
import 'package:sabbeh_clone/shared/helpers/notice_helper.dart';

import '../../shared/constants/cache_constants.dart';
import 'counters_controller.dart';


enum NotificationInterval {
  every15minutes,
  every30minutes,
  every1hour,
  every3hours
}

Map<NotificationInterval, RepeatInterval> map = {
  NotificationInterval.every15minutes: RepeatInterval.everyMinute,
  NotificationInterval.every30minutes: RepeatInterval.hourly,
  NotificationInterval.every1hour: RepeatInterval.daily,
  NotificationInterval.every3hours: RepeatInterval.weekly,
};

Map<int, RepeatInterval> intToRepeatInterval = {
  15: RepeatInterval.everyMinute,
  30: RepeatInterval.hourly,
  60: RepeatInterval.daily,
  180: RepeatInterval.weekly,
};

//Convert [NotificationController] to a provider to control notifications easily.

class NotificationController extends ChangeNotifier{

  static NotificationController get(context, {bool listen = true}) =>
      Provider.of<NotificationController>(context, listen: listen);


  // Initialize values

  void setNotificationReminder(BuildContext context) async
  {
    Map language = LanguageBuilder.texts!['@notification'];
    int countPer = await CacheHelper.getInteger(key: CacheKeys.noticeCount);
    countPer != 0 ? null
        : {countPer = 5, CacheHelper.saveData(key: CacheKeys.noticeCount, value: 5)};

    String content = "${language['content']}, $countPer ${language['per_count']}: ";
    Iterable<String> countersNames =
        CountersController.get(context, listen: false).countersMap.keys;

    int len = countersNames.length;
    countersNames.toList().asMap().forEach((index, counter) {
      content = content + counter;
      if(index == len) content = '$content.';
      else if(index + 1 == len) content = '$content ${language['and']} ';
      else content = '$content, ';
    });

    NotificationHelper.showReminderNotification(
      title: language['title'],
      body: content,
      actionBtn1: language['@buttons']['add'],
      actionBtn2: language['@buttons']['dismiss'],
      interval: _getRepeatInterval(await _getNotificationInterval()),
    );
    print('Reminder Notification have been set');
  }

  Future<void> updateValues(BuildContext context,
      {int? countPer, int? interval})
  async {
    countPer != null ? await CacheHelper.
    saveData(key: CacheKeys.noticeCount, value: countPer): null;
    interval != null ? await CacheHelper
        .saveData(key: CacheKeys.noticeInterval, value: interval): null;
    SettingsController.get(context, listen: false).notifications
        ? setNotificationReminder(context): null;
  }


  Future<NotificationInterval> _getNotificationInterval() async{
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
    return await _getNotificationInterval();
  }

  RepeatInterval _getRepeatInterval(NotificationInterval interval){
    switch(interval){
      case NotificationInterval.every15minutes:
        return RepeatInterval.everyMinute;
      case NotificationInterval.every30minutes:
        return RepeatInterval.hourly;
      case NotificationInterval.every1hour:
        return RepeatInterval.daily;
      case NotificationInterval.every3hours:
        return RepeatInterval.weekly;
    }
  }

  // int _getIntervalInt(NotificationInterval interval){
  //   switch(interval){
  //     case NotificationInterval.every15minutes:
  //       return 15;
  //     case NotificationInterval.every30minutes:
  //       return 30;
  //     case NotificationInterval.every1hour:
  //       return 60;
  //     case NotificationInterval.every3hours:
  //       return 180;
  //   }
  // }

}