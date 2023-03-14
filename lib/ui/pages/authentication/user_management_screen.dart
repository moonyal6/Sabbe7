import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sabbeh_clone/main.dart';
import 'package:sabbeh_clone/ui/components/card/page_button_card.dart';
import '../../../shared/constants/text_constants/turkish_text_constants.dart';
import '../../components/card/card_components/card_tile.dart';
import '../../components/card/card_components/card_tile_components/card_tile_button.dart';
import '../../components/card/page_card.dart';
import '../../components/header/page_header.dart';
import '../../cubit/firebase_cubits/auth/auth_cubit.dart';
import '../../cubit/firebase_cubits/auth/auth_states.dart';
import '../../providers/lang_provider.dart';



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
    Map<String, dynamic> _pageText = appLang['@account_management_page'];

    String mail = AuthCubit.get(context)
        .currentUser!.email;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              PageHeader(
                title: _pageText['title'],
              ),
              Column(

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
                       // PageButtonCard(
                       //     text: 'Hesabı Sil',
                       //     textColor: Colors.red,
                       //     onPressed: (){
                       //       _showDialog(context,
                       //           title: 'Delete Account?',
                       //           content: Text('Are you sure you want to delete your account?'),
                       //           actions: [
                       //             TextButton(
                       //               child: Text(
                       //                 'Cancel',
                       //                 style: _whiteColor,
                       //               ),
                       //               onPressed: () => Navigator.pop(context),
                       //             ),
                       //             // TextButton(
                       //             //   child: Text(
                       //             //     'Delete',
                       //             //     style: TextStyle(
                       //             //         color: Colors.red
                       //             //     ),
                       //             //   ),
                       //             //   onPressed: (){
                       //             //     context.read<AuthCubit>().deleteUser(context);
                       //             //     Navigator.pop(context);
                       //             //     },
                       //             // ),
                       //           ]
                       //       );
                       //     }
                       // ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}
