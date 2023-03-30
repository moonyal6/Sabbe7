import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../shared/constants/constants.dart';
import '../../shared/constants/style_constants/text_style_constants.dart';
import '../cubit/counters_cubits/default_counters_cubits/counter_cubit1.dart';
import '../cubit/counters_cubits/default_counters_cubits/counter_cubit2.dart';
import '../cubit/counters_cubits/default_counters_cubits/counter_cubit3.dart';
import '../cubit/counters_cubits/default_counters_cubits/counter_cubit4.dart';
import '../cubit/counters_cubits/default_counters_cubits/counter_cubit5.dart';
import '../cubit/counters_cubits/default_counters_cubits/counter_cubit6.dart';
import '../cubit/firebase_cubits/auth/auth_cubit.dart';
import '../cubit/firebase_cubits/auth/auth_states.dart';
import '../cubit/firebase_cubits/firestore/firestore_cubit.dart';


//TODO: when removing this class don't forget to remove route from 'main.dart'.
class DebugScreen extends StatelessWidget {
  const DebugScreen({Key? key}) : super(key: key);
  static String route = 'debug';

  SnackBar _snackBar({required String text, SnackBarAction? action}){
    return SnackBar(
      content: Text(text,
          style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.grey.shade900,
      duration: const Duration(seconds: 2),
      action: action,
    );
  }

  void _showDialog(BuildContext context,
      {required String text,
        // required String title
      }){

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        // backgroundColor: Color(0xff1c1a1a),
        // title:  Text(title),
        content: Text(text) ,
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context,
      {required String text, String errorMessage = 'Error', bool listen = true}){
    if(listen){
      final authState = AuthCubit.get(context).state;
      if (authState is AuthErrorState) {
        print(authState.errorMessage);
        ScaffoldMessenger.of(context).showSnackBar(_snackBar(
          text: errorMessage,
          action: SnackBarAction(
            label: 'View Error',
            onPressed: () {
              _showDialog(context, text: authState.errorMessage);
            },
          ),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(_snackBar(
          text: text,
        ));
      }
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(_snackBar(
        text: text,
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug'),
      ),
      body: Column(
        children:  [
          ////Authentication Section
           ExpansionTile(
             initiallyExpanded: true,
            title: const Text('authentication',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            ),
            children: [
              _debugTile(
                    text: 'sign out',
                    onTap: () async{
                      context.read<AuthCubit>().signOut();
                      //todo: call showSnackBar
                      _showSnackBar(context,
                        text: 'Signed Out',
                        errorMessage: "Can't Sign Out",
                      );
                  },
                  ),

              _debugTile(
                    text: "log as sample",
                    onTap: () async{
                      final email = 'sample@mail.com';
                      final password = '123456';
                      final auth = AuthCubit.get(context);
                      await auth.signInUser(
                          email: email,
                          password: password,
                      );
                      _showSnackBar(context,
                        text: 'Logged In');
                    },
                  ),

              _debugTile(
                text: "create sample",
                onTap: () async{
                  final email = 'sample@mail.com';
                  final password = '123456';
                  final auth = AuthCubit.get(context);
                  Map<String, int> counters = {
                    cnt1_key: CounterCubit1.get(context).state, cnt2_key: CounterCubit2.get(context).state,
                    cnt3_key: CounterCubit3.get(context).state, cnt4_key: CounterCubit4.get(context).state,
                    cnt5_key: CounterCubit5.get(context).state, cnt6_key: CounterCubit6.get(context).state,
                  };
                  await auth.createUser(
                      email: email,
                      password: password,
                      counters: counters
                  );
                  _showSnackBar(context, text: 'Created Sample Account');
                },
              ),

              _debugTile(
                text: 'get user data',
                onTap: () async{
                  final user = AuthCubit.get(context).currentUser != null
                      ? AuthCubit.get(context).currentUser!.email
                      : 'No User Found'

                  ;
                  _showSnackBar(context, text: user, listen: false);
                  print(user);
                  //todo: call showSnackBar
                },
              ),

              _debugTile(
                text: 'delete account',
                onTap: () async{
                  final auth = AuthCubit.get(context);
                  final state = auth.state;
                  if(state is AuthLoggedInState){
                    final uid = state.uId;
                    auth.deleteUser(uid: uid);
                  }
                  else{
                    print('NO USER FOUND!');
                    //todo: call showSnackBar
                  }


                  //todo: call showSnackBar
                },
              ),
            ],
          ),

      ////Counter Control Section
      ExpansionTile(
        initiallyExpanded: false,
        title: const Text('counter',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        children: [
          _debugTile(
            text: 'rest global counter',
            enabled: false,
            onTap: (){
            //   context.read<FirestoreCubit>().resetGlobalCounter();
              },
          ),
          _debugTile(
            text: 'rest counter',
            onTap: (){},
            trailing: DropdownButton(
              hint: Text('counter'),
              items: [cnt1_key,
                      cnt2_key,
                      cnt3_key,
                      cnt4_key,
                      cnt5_key,
                      cnt6_key,
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value){},
            ),
          ),
        ],
      ),
      //
      //     ////Prints Section.
      //     ExpansionTile(
      //       initiallyExpanded: false,
      //       title: const Text('prints',
      //         style: kDrawerTiles,
      //       ),
      //       children: [
      //         _debugTile(
      //             text: 'print global counter',
      //             onTap: (){
      //               /* Bug Lines */
      //               // Provider.of<UserData>(context, listen: false).getGlobalCounter('ttl_cnt');
      //               // Provider.of<UserData>(context, listen: false).getGlobalCounter('ttl_cnt1');
      //               // Provider.of<UserData>(context, listen: false).getGlobalCounter('ttl_cnt2');
      //               // Provider.of<UserData>(context, listen: false).getGlobalCounter('ttl_cnt3');
      //
      //             })
      //       ],
      //     ),
        ],
      ),
    );
  }
}



class _debugTile extends StatelessWidget {
  _debugTile({required this.text, this.onTap, this.trailing, this.enabled = true});

  final String text;
  final Function()? onTap;
  final Widget? trailing;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: enabled,
      title: Text(text,
          style: kDrawerTiles
      ),
      onTap: onTap,
      trailing: trailing,
    );
  }
}

