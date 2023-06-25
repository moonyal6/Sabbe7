import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabbeh_clone/shared/helpers/cache_helper.dart';
import 'package:sabbeh_clone/data/controllers/notification_controller.dart';

import '../../shared/constants/cache_constants.dart';
import '../../shared/helpers/notice_helper.dart';

enum Settings {
  Vibration,
  Sound,
  Notification,
}

class SettingsController extends ChangeNotifier{

  static SettingsController get(context, {bool listen = true}) =>
      Provider.of<SettingsController>(context, listen: listen);

  bool _vibration = CacheHelper.getBool(key: CacheKeys.vibration);
  bool _sound = CacheHelper.getBool(key: CacheKeys.sound);
  bool _notifications = CacheHelper.getBool(key: CacheKeys.notifications);
  int _noticeInterval = CacheHelper.getInteger(key: CacheKeys.noticeInterval) != 0
      ? CacheHelper.getInteger(key: CacheKeys.noticeInterval) : 30;

  // #### Handle notification values in a enumerated way to avoid errors ### //

  get vibration => _vibration;
  get sound => _sound;
  get notifications => _notifications;
  get noticeInterval => _noticeInterval;


  void toggle(BuildContext context, Settings type){
    switch(type){
      case Settings.Vibration:
        _vibration = !_vibration;
        CacheHelper.saveData(key: CacheKeys.vibration, value: _vibration);
        break;
      case Settings.Sound:
        _sound = !_sound;
        CacheHelper.saveData(key: CacheKeys.sound, value: _sound);
        break;
      case Settings.Notification:
        _notifications = !_notifications;
        CacheHelper.saveData(key: CacheKeys.notifications, value: _notifications);
        _notifications
            ? NotificationController.get(context, listen: false)
            .setNotificationReminder(context)
            : NotificationHelper.cancelAllNotifications();
        break;
    }
    notifyListeners();
  }
}