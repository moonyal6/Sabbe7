import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabbeh_clone/shared/helpers/cache_helper.dart';
import 'package:sabbeh_clone/data/controllers/notification_controller.dart';

enum Settings {
  Vibration,
  Sound,
  Notification,
}

class SettingsController extends ChangeNotifier{

  static SettingsController get(context, {bool listen = true}) =>
      Provider.of<SettingsController>(context, listen: listen);

  bool _vibration = CacheHelper.getBool(key: 'vibration');
  bool _sound = CacheHelper.getBool(key: 'sound');
  bool _notifications = CacheHelper.getBool(key: 'notifications');
  int noticeInterval = CacheHelper.getInteger(key: 'notice_delay');

  get vibration => _vibration;
  get sound => _sound;
  get notifications => _notifications;


  void toggle(Settings type){
    switch(type){
      case Settings.Vibration:
        _vibration = !_vibration;
        CacheHelper.saveData(key: 'vibration', value: _vibration);
        break;
      case Settings.Sound:
        _sound = !_sound;
        CacheHelper.saveData(key: 'sound', value: _sound);
        break;
      case Settings.Notification:
        _notifications = !_notifications;
        CacheHelper.saveData(key: 'notifications', value: _notifications);
        _notifications
            ? NotificationController.scheduleNewNotification()
            : NotificationController.cancelNotifications();
        break;
    }
    notifyListeners();
  }
}