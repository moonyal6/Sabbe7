import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sabbeh_clone/data/controllers/counters_controller.dart';

import '../../shared/constants/constants.dart';
import '../../shared/constants/style_constants/text_style_constants.dart';
import '../../shared/constants/text_constants/arabic_text_constants.dart';
import '../cubit/firebase_cubits/auth/auth_cubit.dart';
import '../cubit/firebase_cubits/auth/auth_states.dart';


//TODO: when removing this class don't forget to remove route from 'main.dart'.
class DebugScreen extends StatefulWidget {
  const DebugScreen({Key? key}) : super(key: key);
  static String route = 'debug';

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  String _notificationValue = '15 min';


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

    SnackBar snackBar({required String text, SnackBarAction? action}) => SnackBar(
      content: Text(text,
          style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.grey.shade900,
      duration: const Duration(seconds: 2),
      action: action,
    );

    if(listen){
      final authState = AuthCubit.get(context).state;
      if (authState is AuthErrorState) {
        print(authState.errorMessage);
        ScaffoldMessenger.of(context).showSnackBar(snackBar(
          text: errorMessage,
          action: SnackBarAction(
            label: 'View Error',
            onPressed: () {
              _showDialog(context, text: authState.errorMessage);
            },
          ),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(snackBar(
          text: text,
        ));
      }
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(snackBar(
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
            text: 'rest counter',
            enabled: false,
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
          _debugTile(
            text: 'add counter',
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
                      CountersController.get(context, listen: false).addNewCounter(value);
                    },
                  ),
              );
            },
          ),
          _debugTile(
            text: 'remove last counter',
            onTap: (){
              CountersController.get(context, listen: false).removeCounter(
                CountersController.get(context, listen: false).countersMap.keys.last
              );
            },
          ),
          _debugTile(
            text: 'wipe counter date',
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
            initiallyExpanded: false,
            title: const Text('notification',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            ),
            children: [
              _debugTile(
                text: 'send notification now',
                onTap: (){
                  AwesomeNotifications().createNotification(
                      content: NotificationContent(
                          id: 15,
                          channelKey: 'testing',
                          title: 'Simple Notification',
                          body: 'Simple body',
                          actionType: ActionType.Default
                      )
                  );
                },
              ),
              _debugTile(
                text: 'schedule notification',
                // enabled: false,
                onTap: ()async{
                  String localTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();

                  await AwesomeNotifications().createNotification(
                      content: NotificationContent(
                          id: 15,
                          channelKey: 'testing',
                          title: 'Notification at every single minute',
                          body:
                          ' minute.',
                          notificationLayout: NotificationLayout.BigPicture,
                          bigPicture: 'asset://assets/images/melted-clock.png',
                          category: NotificationCategory.Reminder),
                      schedule: NotificationCalendar(
                        minute: 1,
                        // second: 20,
                        repeats: true,
                        // allowWhileIdle: true
                      ));
                },
                trailing:
                DropdownButton(
                  value: _notificationValue,
                  items: [
                    '15 min',
                    // '2'
                  ].map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _notificationValue = newValue!;
                    });
                  },
                ),
                // DropdownButton(
                //   // value: _notificationValue,
                //   hint: Text('repeat every'),
                //   items: [
                //     '15min',
                //     // "30min",
                //     // "1h",
                //     "3h",
                //   ].map((value) {
                //     return DropdownMenuItem(
                //       child: Text('every $value'),
                //     );
                //   }).toList(),
                //   onChanged: (value){
                //     setState(() {
                //       _notificationValue = value!;
                //     });
                //   },
                // ),
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
      textColor: enabled? Colors.white: Colors.grey,
      title: Text(text,
          style: kDrawerTiles
      ),
      onTap: enabled? onTap: null,
      trailing: trailing,
    );
  }
}

