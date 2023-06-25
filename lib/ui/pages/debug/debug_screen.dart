import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sabbeh_clone/shared/helpers/cache_helper.dart';
import 'package:sabbeh_clone/shared/helpers/notice_helper.dart';
import 'package:sabbeh_clone/data/controllers/counters_controller.dart';
import 'package:sabbeh_clone/data/controllers/counters_controller.dart';

import '../../../data/controllers/notification_controller.dart';
import '../../../main.dart';
import '../../../shared/constants/cache_constants.dart';
import '../../../shared/constants/constants.dart';
import '../../../shared/constants/style_constants/text_style_constants.dart';
import '../../../shared/constants/text_constants/arabic_text_constants.dart';
import '../../cubit/firebase_cubits/auth/auth_cubit.dart';
import '../../cubit/firebase_cubits/auth/auth_states.dart';


//TODO: when removing this class don't forget to remove route from 'main.dart'.
class DebugScreen extends StatefulWidget {
  DebugScreen({Key? key}) : super(key: key);
  static String route = 'debug';

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  String noticeCountKey = cnt1_key;
  int noticeCountNum = 10;
  int noticeInterval = CacheHelper.getInteger(key: CacheKeys.noticeInterval) != 0
      ? CacheHelper.getInteger(key: CacheKeys.noticeInterval) : 30;

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
      {String? text, Widget? content}){
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: content ?? Text(text!) ,
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
      body: ListView(
        children:  [
          ////Authentication Section
           ExpansionTile(
             initiallyExpanded: false,
            title: const Text('authentication',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            ),
            children: [
              _debugTile(
                    lable: 'sign out',
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
                    lable: "log as sample",
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
                lable: "create sample",
                onTap: () async{
                  final email = 'sample@mail.com';
                  final password = '123456';
                  final auth = AuthCubit.get(context);
                  Map<String, int> counters = {
                    cnt1_key: CountersController.get(context).cnt1,
                    cnt2_key: CountersController.get(context).cnt2,
                    cnt3_key: CountersController.get(context).cnt3
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
                lable: 'get user data',
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
                lable: 'delete account',
                enabled: false,
                onTap: () async{
                  final auth = AuthCubit.get(context);
                  final state = auth.state;
                  if(state is AuthLoggedInState){
                    final uid = state.uId;
                    // auth.deleteUser(uid: uid);
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
        title: const Text('counters',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        children: [
          // _debugTile(
          //   text: 'rest global counter',
          //   enabled: false,
          //   onTap: (){
          //   //   context.read<FirestoreCubit>().resetGlobalCounter();
          //     },
          // ),
          _debugTile(
            lable: 'rest counter',
            // enabled: false,
            onTap: (){CountersController.get(context, listen: false).dailyReset(isDebug: true);},
            // trailing: DropdownButton(
            //   hint: Text('counter'),
            //   items: [cnt1_key,
            //           cnt2_key,
            //           cnt3_key,
            //           cnt4_key,
            //           cnt5_key,
            //           cnt6_key,
            //   ].map<DropdownMenuItem<String>>((String value) {
            //     return DropdownMenuItem<String>(
            //       value: value,
            //       child: Text(value),
            //     );
            //   }).toList(),
            //   onChanged: (value){},
            // ),
          ),
          _debugTile(
            lable: 'add counter',
            onTap: (){
              _showDialog(context,
                  content: DropdownButton(
                    hint: Text('counter name'),
                    items: [
                      '${ar['@reports']['@local_report']['@counters'][cnt4_key]}',
                      '${ar['@reports']['@local_report']['@counters'][cnt5_key]}'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value){
                      CountersController.get(context, listen: false).addNewCounter(value!);
                    },
                  ),
              );
            },
          ),
          _debugTile(
            lable: 'remove last counter',
            onTap: (){
              CountersController.get(context, listen: false).removeCounter(
                CountersController.get(context, listen: false).countersMap.keys.last
              );
            },
          ),
          _debugTile(
            lable: 'wipe counter date',
            onTap: () async{
              await CountersController.get(context, listen: false).resetCounterData(context);
              _showSnackBar(context,
                text: 'Counter data deleted',
                listen: false,
              );
            },
          ),
        ],
      ),
          ExpansionTile(
            initiallyExpanded: true,
            title: const Text('notifications',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            ),
            children: [
              _debugTile(
                  lable: 'send notification',
                  onTap: (){
                    // NoticeHelper.createTestNotification();
                    // NotificationController.createNewNotification();
                  }),
              _debugTile(
                enabled: true,
                lable: 'repeating notification every',
                trailing: ElevatedButton(
                  child:Text('Send'),
                  onPressed: (){
                    NotificationController.get(context, listen: false)
                        .setNotificationReminder(context);
                  },
              ),
                onTap: (){
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            content: Container(
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text('count num'),
                                    trailing: DropdownButton(
                                      value: noticeCountNum,
                                      items: [3, 5, 10]
                                          .map<DropdownMenuItem<int>>((int value) {
                                        return DropdownMenuItem<int>(
                                          value: value,
                                          child: Text(value.toString()),
                                        );
                                      }).toList(),
                                      onChanged: (value){
                                        setState(() {
                                          noticeCountNum = value!;
                                        });
                                        NotificationController.get(context, listen: false)
                                            .updateValues(context, countPer: value);
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    title: Text('notification interval'),
                                    trailing: DropdownButton(
                                      value: noticeInterval,
                                      items: [
                                        DropdownMenuItem(child: Text('15 min'), value: 15),
                                        DropdownMenuItem(child: Text('30 min'), value: 30),
                                        DropdownMenuItem(child: Text('1 h'), value: 60),
                                        DropdownMenuItem(child: Text('3 h'), value: 180),
                                      ],
                                      onChanged: (value){
                                        setState(() {
                                        noticeInterval = value!;
                                        });
                                        NotificationController.get(context, listen: false)
                                            .updateValues(context, interval: value);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          );
                        }
                    ),
                  );
                  // NotificationController.scheduleNewNotification();
                },

              ),
              _debugTile(
                lable: 'stop all notification',
                onTap: () {
                  // NotificationController.cancelNotifications();
                },
              ),
              _debugTile(
                lable: 'go to notifications page',
                onTap: () {
                  Navigator.popAndPushNamed(context, NotificationInitialRoute);
                },
              )
              // _debugTile(text: 'isTimeOut = ${CacheHelper.getBool(key: 'timeout')}')
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
  _debugTile({required this.lable, this.onTap, this.trailing, this.enabled = true});

  final String lable;
  final Function()? onTap;
  final Widget? trailing;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: enabled,
      title: Text(lable,
          style: kDrawerTiles
      ),
      onTap: onTap,
      trailing: trailing,
    );
  }
}

