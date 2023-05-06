import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_builder/language_builder.dart';
import 'package:provider/provider.dart';
import 'package:sabbeh_clone/shared/helpers/notice_helper.dart';
import '../../data/controllers/counters_controller.dart';
import '../../data/controllers/notification_controller.dart';
import '../../shared/helpers/cache_helper.dart';
import '../components/app_page/app_page.dart';
import '../components/app_page/app_page_components/card/page_card.dart';
import '../components/app_page/app_page_components/settings_tile.dart';
import 'package:sabbeh_clone/data/controllers/settings_controller.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  static String route = 'settings_cubits';
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}


class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> _pageText = LanguageBuilder.texts!['@settings_page'];

    bool vibration = SettingsController.get(context).vibration;
    bool sound = SettingsController.get(context).sound;
    bool notifications = SettingsController.get(context).notifications;
    // int noticeInterval = SettingsController.get(context).noticeInterval;

    return AppPage(
      title: _pageText['title'],
      child: Column(
        children: [
          PageCard(
            title: _pageText['@titles']['general'],
            children: [
              SettingsTile(
                title: _pageText['@tiles']['vibration'],
                icon: Icons.vibration,
                trailing: Switch(
                  value: vibration,
                  activeColor: Colors.blue,
                  activeTrackColor: Colors.white,
                  onChanged: (bool value){
                    // setState(() {
                      SettingsController.get(context, listen: false).toggle(Settings.Vibration);
                    // });
                  },
                ),
              ),
              SettingsTile(
                title: _pageText['@tiles']['sound'],
                icon: Icons.volume_up_outlined,
                trailing: Switch(
                  value: sound,
                  activeColor: Colors.blue,
                  activeTrackColor: Colors.white,
                  onChanged: (bool value){
                    // setState(() {
                      SettingsController.get(context, listen: false).toggle(Settings.Sound);
                    // });
                  },
                ),
              ),
              SettingsTile(
                title: _pageText['@tiles']['language'],
                icon: Icons.language,
                trailing: DropdownButton<String>(
                  // value: appLang['@lang_data']['lang_name'],
                  value: LanguageBuilder.getCurrentLang(),
                  onChanged: (value) {
                    LanguageBuilder.changeLanguage(value!, context);
                    CacheHelper.saveData(key: 'lang', value: value);
                    CountersController.get(context, listen: false)
                        .updateCountersNames();
                  },
                  items:
                  // [
                  // ar['@lang_data']['lang_name'],
                  // en['@lang_data']['lang_name'],
                  // tr['@lang_data']['lang_name'],
                  // ]
                  LanguageBuilder.getAvailableLanguages()
                      .map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          PageCard(
            title: _pageText['@titles']['notifications'],
            children: [
              SettingsTile(
                title: _pageText['@tiles']['enable_notifications'],
                icon: Icons.notifications_none_outlined,
                trailing: Switch(
                  value: notifications,
                  activeColor: Colors.blue,
                  activeTrackColor: Colors.white,
                  onChanged: (value){
                    SettingsController.get(context, listen: false)
                        .toggle(Settings.Notification);
                  },
                ),
              ),
              SettingsTile(
                title: _pageText['@tiles']['count_number'],
                icon: Icons.pin_outlined,
                trailing: DropdownButton(
                  value: CacheHelper.getInteger(key: "notice_count") != 0
                      ? CacheHelper.getInteger(key: "notice_count") : 5,
                  items: [
                    DropdownMenuItem(child: Text('3'), value: 3),
                    DropdownMenuItem(child: Text('5'), value: 5),
                    DropdownMenuItem(child: Text('10'), value: 10),
                  ],
                  onChanged: (value){
                    setState(() {
                      CacheHelper.saveData(key: "notice_count", value: value);
                    });
                  },
                ),
              ),
              SettingsTile(
                title: _pageText['@tiles']['notification_delay'],
                icon: Icons.timer_outlined,
                trailing: DropdownButton(
                  value: CacheHelper.getInteger(key: "notice_delay") != 0
                      ? CacheHelper.getInteger(key: "notice_delay") : 1800,
                  items: [
                    DropdownMenuItem(
                        child: Text(
                            '15 ${_pageText['@drop_downs']['minute']}'),
                        value: 900,
                    ),
                    DropdownMenuItem(
                        child: Text(
                            '30 ${_pageText['@drop_downs']['minute']}'),
                        value: 1800,
                    ),
                    DropdownMenuItem(
                        child: Text(
                            '1 ${_pageText['@drop_downs']['hour']}'),
                        value: 3600,
                    ),
                    DropdownMenuItem(
                        child: Text(
                            '3 ${_pageText['@drop_downs']['hour']}'),
                        value: 10800,
                    ),
                  ],
                  onChanged: (value){
                    setState(() {
                      // noticeInterval = value!;
                      CacheHelper.saveData(key: 'notice_delay', value: value);
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
