import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_builder/language_builder.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sabbeh_clone/shared/constants/constants.dart';
import 'package:sabbeh_clone/ui/pages/authentication/sign_in_page.dart';
import '../../components/app_page/app_page_components/dialogs/error_dialog.dart';
import '../../components/app_page/app_page_components/text_fields.dart';
import '../../../data/controllers/counters_controller.dart';
import '../../cubit/firebase_cubits/auth/auth_cubit.dart';
import '../../cubit/firebase_cubits/auth/auth_states.dart';


bool showSpinner = false;

class SignUpScreen extends StatefulWidget {
  static const String route = 'signUp';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> _pageText = LanguageBuilder.texts!['@auth_pages']['@sign_up_page'];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner
        ,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 65,horizontal: 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 100,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(_pageText['title'],
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    TextFields.email(
                      context,
                      onChanged: (value) => _email = value,
                    ),
                    const SizedBox(height: 10),
                    TextFields.password(
                      context,
                      onChanged: (value) => _password = value,
                      obscureText: true,
                    ),
                  ],
                ),
                IntrinsicWidth(
                  stepWidth: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BlocConsumer<AuthCubit, AuthStates>(
                        builder: (context, state) {
                          return MaterialButton(
                            color: Colors.white70,
                            child: Text(_pageText['sign_up']),
                            textColor: Colors.black,
                            onPressed: () async{
                              Map<String, int> counters = //CountersProvider.get(context).countersMap;
                              {
                                cnt1_key: CountersController.get(context).cnt1,
                                cnt2_key: CountersController.get(context).cnt2,
                                cnt3_key: CountersController.get(context).cnt3,
                              };

                              AuthCubit.get(context)
                                  .createUser(
                                    email: _email,
                                    password: _password,
                                    counters: counters
                              );
                              await SystemChannels.textInput.invokeMethod('TextInput.hide');
                            },
                          );
                        },
                        listener: (context, state) {
                          if(state is AuthLoadingState){
                            setState(() {
                              showSpinner = true;
                            });
                          }
                          if(state is AuthErrorState){
                            setState(() {
                              showSpinner = false;
                            });
                            showErrorDialog(context);
                          }
                          else if (state is AuthLoggedInState){
                            setState(() {
                              showSpinner = false;
                            });
                            Navigator.pop(context);
                          }
                        },
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(_pageText['sign_in_text'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13
                            ),
                          ),
                          TextButton(
                            child: Text(_pageText['sign_in'],
                              style: TextStyle(
                                  color: Colors.blue
                              ),
                            ),
                            onPressed: () => Navigator.popAndPushNamed(context, SignInScreen.route),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

