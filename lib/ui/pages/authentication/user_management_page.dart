import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_builder/language_builder.dart';
import 'package:sabbeh_clone/ui/components/app_page/app_page_components/dialogs/page_dialog.dart';
import '../../components/app_page/app_page.dart';
import '../../components/app_page/app_page_components/card/card_components/card_tile.dart';
import '../../components/app_page/app_page_components/card/page_button_card.dart';
import '../../components/app_page/app_page_components/card/page_card.dart';
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
  Map<String, dynamic> _pageText = LanguageBuilder.texts!['@account_management_page'];
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  String? _password;
  String? _email;

  _showSignInDialog(BuildContext context){
     PageDialog.showPageDialog(
       context,
       title: _pageText['@sign_out_dialog']['title'],
       contentText: _pageText['@sign_out_dialog']['content'],
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
  }

  @override
  Widget build(BuildContext context) {

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
                    _showSignInDialog(context);
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
