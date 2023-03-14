import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sabbeh_clone/main.dart';
import 'package:sabbeh_clone/ui/cubit/counters_cubits/counter_cubit1.dart';
import 'package:sabbeh_clone/ui/pages/authentication/sign_in_screen.dart';
import '../../../shared/constants/text_constants/turkish_text_constants.dart';
import '../../components/dialogs/error_dialog.dart';
import '../../components/text_fields.dart';
import '../../cubit/counters_cubits/counter_cubit2.dart';
import '../../cubit/counters_cubits/counter_cubit3.dart';
import '../../cubit/firebase_cubits/auth/auth_cubit.dart';
import '../../cubit/firebase_cubits/auth/auth_states.dart';
import '../../providers/lang_provider.dart';


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
    Map<String, dynamic> _pageText = appLang['@auth_pages']['@sign_up_page'];

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
                              List<int> counters = [
                                CounterCubit1.get(context).state,
                                CounterCubit2.get(context).state,
                                CounterCubit3.get(context).state,
                              ];
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

