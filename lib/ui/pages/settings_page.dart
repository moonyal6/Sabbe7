import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sabbeh_clone/main.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/constants/constants.dart';
import '../../shared/constants/text_constants/arabic_text_constants.dart';
import '../../shared/constants/text_constants/english_text_constants.dart';
import '../../shared/constants/text_constants/turkish_text_constants.dart';
import '../components/app_pages_components/settings_tile.dart';
import '../cubit/settings_cubits/sound_cubit.dart';
import '../cubit/settings_cubits/vibration_cubit.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  static String route = 'settings_cubits';
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}




Future<void> _launchAboutUsURL() async {
  String _lang = appLang['@lang_data']['lang_short'];

  final _uri = Uri.parse(
      _lang == 'TR'? aboutUsUrlTr:
      _lang == 'AR'? aboutUsUrlAr:
      aboutUsUrl
  );
  if (!await launchUrl(_uri)) {
    throw Exception('Could not launch $_uri');
  }
}



class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> _pageText = appLang['@settings_page'];

    bool vibration = context.read<VibrationCubit>().state;
    bool sound = context.read<SoundCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: Text(_pageText['title']),
        titleSpacing: 15,
        elevation: 2,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(19),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Column(
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
                    // SettingsTile(
                    //   title: _pageText['@tiles']['language'],
                    //   icon: Icons.language,
                    //   trailing: DropdownButton<String>(
                    //     value: appLang['@lang_data']['lang_short'],
                    //     onChanged: (value) => {},
                    //         // LangHelper().setLang(value),
                    //     items: [
                    //       ar['@lang_data']['lang_short'],
                    //       en['@lang_data']['lang_short'],
                    //       tr['@lang_data']['lang_short'],
                    //     ].map<DropdownMenuItem<String>>((value) {
                    //       return DropdownMenuItem<String>(
                    //         value: value,
                    //         child: Text(value),
                    //       );
                    //     }).toList(),
                    //   ),
                    // ),
                    SettingsTile(
                      title: _pageText['@tiles']['about_us'],
                      icon: Icons.info_outline,
                      onTap: () {
                        _launchAboutUsURL();
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
