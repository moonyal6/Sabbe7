import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_builder/language_builder.dart';
import '../../components/app_page/app_page.dart';
import '../../components/app_page/app_page_components/card/card_components/card_tile.dart';
import '../../components/app_page/app_page_components/card/page_button_card.dart';
import '../../components/app_page/app_page_components/card/page_card.dart';
import '../../components/app_page/app_page_components/header/page_header.dart';
import '../../cubit/firebase_cubits/auth/auth_cubit.dart';
import '../../cubit/firebase_cubits/auth/auth_states.dart';



const _whiteColor = TextStyle(
    color: Colors.white
);

class UserManagementScreen extends StatefulWidget {
  UserManagementScreen({Key? key}) : super(key: key);
  static String route = 'user management';

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {

  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  String? _password;
  String? _email;

  _showDialog(BuildContext context, {
    required String title,
    required Widget content,
    required List<Widget> actions,
  }){
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Color(0xff1c1a1a),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18)
        ),

        title:  Text(title),
        content: content,
        actions: actions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> _pageText = LanguageBuilder.texts!['@account_management_page'];

    String mail = AuthCubit.get(context)
        .currentUser!.email;

    return AppPage(
      title: _pageText['title'],
      headerPadding: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 42, bottom: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_circle,
                  size: 89,
                ),
                Padding(
                  padding: const EdgeInsets.only(top:32, left: 8),
                  child: Text(mail,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: PageCard(
                  children: [
                    CardTile(
                      title: _pageText['email'],
                      subtitle: Text(mail),
                    ),
                    CardTile(
                      title: _pageText['password'],
                      subtitle: Text('●●●●●●●●',
                        style: TextStyle(
                            letterSpacing: 3,
                            fontSize: 15
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: PageButtonCard(
                  text: _pageText['sign_out'],
                  textColor: Colors.red,
                  onPressed: (){
                    _showDialog(context,
                      title: _pageText['@sign_out_dialog']['title'],
                      content: Text(_pageText['@sign_out_dialog']['content']),
                      actions: [
                        TextButton(
                          child: Text(
                            _pageText['@sign_out_dialog']['@buttons']['cancel'],
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        BlocListener<AuthCubit, AuthStates>(
                          child: TextButton(
                            child: Text(
                              _pageText['@sign_out_dialog']['@buttons']['sign_out'],
                              style: _whiteColor,
                            ),
                            onPressed: () {
                              AuthCubit.get(context).signOut();
                              Navigator.pop(context);
                            },
                          ),
                          listener: (context, state) {
                            if(state is AuthLoggedOutState){
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ],
                    );
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
