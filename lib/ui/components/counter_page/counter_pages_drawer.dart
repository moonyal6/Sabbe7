import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sabbeh_clone/main.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/constants/constants.dart';
import '../../../shared/constants/style_constants/text_style_constants.dart';
import '../../../shared/constants/text_constants/turkish_text_constants.dart';
import '../../cubit/firebase_cubits/auth/auth_cubit.dart';
import '../../cubit/firebase_cubits/auth/auth_states.dart';
import '../../pages/authentication/sign_in_page.dart';
import '../../pages/authentication/user_management_page.dart';
import '../../pages/debug_screen.dart';
import '../../pages/reports/global_report_screen.dart';
import '../../pages/reports/personal_report.dart';
import '../../pages/settings_page.dart';



class CounterPageDrawer extends StatelessWidget {


  Future<void> _launchStoreURL() async {
    String _lang = appLang['@lang_data']['lang_short'];

    final _uri = Uri.parse(
        _lang == 'TR'? sabbehStoreUrlTr:
        _lang == 'AR'? sabbehStoreUrlAr:
        sabbehStoreUrl
    );
    if (!await launchUrl(_uri)) {
      throw Exception('Could not launch $_uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> _pageText = appLang['@drawer'];

    final List<Widget> drawerList = [
      BlocBuilder<AuthCubit, AuthStates>(
        builder: (context, state){
          if(state is AuthLoggedInState){
            return DrawerListTile(
              icon: Icons.person_outline,
              text: _pageText['account_management'],
              onTap: () => {Navigator.pushNamed(context, UserManagementScreen.route)},
            );
          }
          else{
            return DrawerListTile(
              icon: Icons.login_outlined,
              text: _pageText['sign_in'],
              onTap: () => {Navigator.pushNamed(context, SignInScreen.route)},
            );
          }
        }
      ),
      DrawerListTile(
        icon: Icons.settings_outlined,
        text: _pageText['settings'],
        onTap: () => {Navigator.pushNamed(context, SettingsPage.route)},
      ),
      DrawerListTile(
        icon: Icons.summarize_outlined,
        text: _pageText['local_report'],
        onTap: () => {Navigator.pushNamed(context, PersonalReportScreen.route)},
      ),
      DrawerListTile(
        icon: Icons.public_outlined,
        text: _pageText['global_report'],
        onTap: () => {Navigator.pushNamed(context, GlobalReportScreen.route)},
      ),
      DrawerListTile(
        iconImage: Image.asset(
          'assets/images/sabbehLogo.png',
          scale: 65,
        ),
        text: 'Sabbe7 Store',
        onTap: () => _launchStoreURL(),
      )
    ];


    void _checkDebug(){
      if (false){
      // if (kDebugMode) {
        drawerList.add(
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                 thickness: 0.4,
                ),
              ),
              DrawerListTile(
                icon: Icons.bug_report_outlined,
                text: 'Debug',
                onTap: () {
                  Navigator.pushNamed(context, DebugScreen.route);
                },
              ),
            ],
          ),
        );
      }
    }

    _checkDebug();

    return SizedBox(
      width: 230,
      child: Drawer(
        backgroundColor: Colors.black87,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 160,
              child: DrawerHeader(                              ////DrawerHeader
                  // padding: EdgeInsets.only(top: 15),
                  child: Image.asset('assets/images/sabbeh_splash_logo.png',
                    // scale: 0.5,
                    alignment: Alignment.centerLeft,
                  ),
              ),
            ),
            const SizedBox(height: 15),
            Column(
              children: drawerList,
            )
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({this.icon, required this.text, required this.onTap, this.iconImage});

  final Widget? iconImage;
  final IconData? icon;
  final String text;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(                         ////Counter Report Tile
     leading: iconImage ?? Icon(icon,
       size: 30,
     ),
     title:  Text(text,
       style: kDrawerTiles,
     ),
     onTap: onTap,
            );
  }
}
