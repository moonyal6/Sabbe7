import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_builder/language_builder.dart';
import 'package:provider/provider.dart';

import '../components/app_page/app_page.dart';
import '../components/app_page/app_page_components/card/page_card.dart';
import '../components/app_page/app_page_components/header/page_header.dart';
import '../components/app_page/app_page_components/settings_tile.dart';
import '../cubit/settings_cubits/sound_cubit.dart';
import '../cubit/settings_cubits/vibration_cubit.dart';


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

    bool vibration = context.read<VibrationCubit>().state;
    bool sound = context.read<SoundCubit>().state;

    return AppPage(
      title: _pageText['title'],
      child: Column(
        children: [
          PageCard(
            children: [
              SettingsTile(
                title: _pageText['@tiles']['vibration'],
                icon: Icons.vibration,
                trailing: Switch(
                  value: vibration,
                  activeColor: Colors.blue,
                  activeTrackColor: Colors.white,
                  onChanged: (bool value){
                    setState(() {
                      context.read<VibrationCubit>().toggleVibration();
                    });
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
                    setState(() {
                      context.read<SoundCubit>().toggleSound();
                    });
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
        ],
      ),
    );
  }
}
