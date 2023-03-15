import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../shared/constants/style_constants/text_style_constants.dart';
import '../cubit/counters_cubits/default_counters_cubits/counter_cubit1.dart';
import '../cubit/counters_cubits/default_counters_cubits/counter_cubit2.dart';
import '../cubit/counters_cubits/default_counters_cubits/counter_cubit3.dart';
import '../cubit/firebase_cubits/auth/auth_cubit.dart';
import '../cubit/firebase_cubits/auth/auth_states.dart';
import '../cubit/firebase_cubits/firestore/firestore_cubit.dart';


//TODO: when removing this class don't forget to remove route from 'main.dart'.
class DebugScreen extends StatelessWidget {
  const DebugScreen({Key? key}) : super(key: key);
  static String route = 'debug';

  SnackBar _snackBar(String text){
    return SnackBar(
      content: Text(text,
          style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.grey.shade900,
      duration: const Duration(seconds: 2),
    );
  }

void _showSnackBar(BuildContext context, String text){
  ScaffoldMessenger.of(context).showSnackBar(
      _snackBar(text));
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
              style: kDrawerTiles,
            ),
            children: [
              _debugTile(
                text: 'sign out',
                onTap: () async{
                  context.read<AuthCubit>().signOut();
                  //todo: call showSnackBar
                },
              ),

              _debugTile(
                    text: "log as sample",
                    onTap: () {
                      final email = 'sample@mail.com';
                      final password = '123456';
                      final auth = AuthCubit.get(context);
                      auth.signInUser(
                          email: email,
                          password: password,
                      );
                    },
                  ),

              _debugTile(
                text: "create sample",
                onTap: () {
                  final email = 'sample@mail.com';
                  final password = '123456';
                  final auth = AuthCubit.get(context);

                  List<int> counters = [
                    CounterCubit1.get(context).state,
                    CounterCubit2.get(context).state,
                    CounterCubit3.get(context).state,
                  ];
                  auth.createUser(
                      email: email,
                      password: password,
                      counters: counters
                  );
                },
              ),

              _debugTile(
                text: 'get user data',
                onTap: () async{
                  final user = AuthCubit.get(context).currentUser;
                  print(user != null?
                  'User: ${user.email}': 'NO USER FOUND!');
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
          style: kDrawerTiles,
        ),
        children: [
          _debugTile(
            text: 'rest global counter',
            onTap: (){
              context.read<FirestoreCubit>().resetGlobalCounter();
              },
          ),
          _debugTile(
            text: 'rest counter',
            onTap: (){},
            trailing: DropdownButton(
              items: ['Counter 1', 'Counter 2', 'Counter 3']
                  .map<DropdownMenuItem<String>>((String value) {
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
  _debugTile({required this.text, required this.onTap, this.trailing});

  final String text;
  final Function()? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(text,
          style: kDrawerTiles
      ),
      onTap: onTap,
      trailing: trailing,
    );
  }
}

