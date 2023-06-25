import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_builder/language_builder.dart';
import 'package:provider/provider.dart';
import 'package:sabbeh_clone/shared/helpers/notice_helper.dart';
import '../../data/controllers/counters_controller.dart';
import '../../data/controllers/notification_controller.dart';
import '../../shared/constants/cache_constants.dart';
import '../../shared/helpers/cache_helper.dart';
import 'package:sabbeh_clone/ui/components/app_page/app_page_components/dialogs/page_dialog.dart';

import '../../data/controllers/counters_controller.dart';
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
    int noticeInterval = SettingsController.get(context).noticeInterval;
    String newCounterName = '';

    return AppPage(
      title: _pageText['title'],
      child: ListView(
        children: [
          Column(
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
                          SettingsController.get(context, listen: false)
                              .toggle(context, Settings.Vibration);
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
                          SettingsController.get(context, listen: false)
                              .toggle(context, Settings.Sound);
                        // });
                      },
                    ),
                  ),
                  SettingsTile(
                    title: _pageText['@tiles']['language'],
                    icon: Icons.language,
                    trailing: DropdownButton<String>(
                      value: LanguageBuilder.getCurrentLang(),
                      onChanged: (value) async{
                        await CacheHelper
                            .saveData(key: CacheKeys.language, value: value);
                         LanguageBuilder.changeLanguage(value!, context);

                        // CountersController.get(context, listen: false)
                        //     .updateCountersNames();
                      },
                      items:
                      LanguageBuilder.getAvailableLanguages()
                          .map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  SettingsTile(
                    title: _pageText['@tiles']['add_counter'],
                    icon: Icons.add_box_outlined,
                    onTap: (){
                      PageDialog.showPageDialog(
                        context,
                        title: 'Add Counter',
                        content: TextField(
                          autofocus: true,
                          onChanged: (value) => newCounterName = value,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Counter Name',
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: Text('Cancel',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: Text('Add'),
                            onPressed: () {
                                CountersController.get(context, listen: false)
                                    .addNewCounter(newCounterName);
                                Navigator.pop(context);
                              },
                          ),
                        ]
                      );
                    },
                  )
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
                            .toggle(context, Settings.Notification);
                      },
                    ),
                  ),
                  SettingsTile(
                    title: _pageText['@tiles']['count_number'],
                    icon: Icons.pin_outlined,
                    trailing: DropdownButton(
                      value: CacheHelper.getInteger(key: CacheKeys.noticeCount) != 0
                          ? CacheHelper.getInteger(key: CacheKeys.noticeCount) : 5,
                      items: [
                        DropdownMenuItem(child: Text('3'), value: 3),
                        DropdownMenuItem(child: Text('5'), value: 5),
                        DropdownMenuItem(child: Text('10'), value: 10),
                      ],
                      onChanged: (value){
                        setState(() {
                          // CacheHelper.saveData(key: "notice_count", value: value);
                          NotificationController.get(context, listen: false)
                              .updateValues(context, countPer: value);
                        });
                      },
                    ),
                  ),
                  SettingsTile(
                    title: _pageText['@tiles']['notification_delay'],
                    icon: Icons.timer_outlined,
                    trailing: DropdownButton(
                      value: CacheHelper.getInteger(key: CacheKeys.noticeInterval) != 0
                          ? CacheHelper.getInteger(key: CacheKeys.noticeInterval) : 30,
                      items: [
                        DropdownMenuItem(
                            child: Text(
                                '15 ${_pageText['@drop_downs']['minute']}'),
                            value: 15),
                        DropdownMenuItem(
                            child: Text(
                                '30 ${_pageText['@drop_downs']['minute']}'),
                            value: 30),
                        DropdownMenuItem(
                            child: Text(
                                '1 ${_pageText['@drop_downs']['hour']}'),
                            value: 60),
                        DropdownMenuItem(
                            child: Text(
                                '3 ${_pageText['@drop_downs']['hour']}'),
                            value: 180),
                      ],
                      onChanged: (value){
                        setState(() {
                          // CacheHelper.saveData(key: "notice_count", value: value);
                          NotificationController.get(context, listen: false)
                              .updateValues(context, interval: value);
                        });
                      },
                    ),
                  ),
                  // SettingsTile(
                  //   icon: Icons.send,
                  //   title: '#send notification now#',
                  //   onTap: () => NotificationsController.showNotification(),
                  // )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
