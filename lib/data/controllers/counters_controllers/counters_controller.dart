// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
//
// import '../../../shared/helpers/cache_helper.dart';
// import '../../../shared/helpers/counter_methods.dart';
// import '../../../ui/cubit/firebase_cubits/auth/auth_cubit.dart';
// import '../../../ui/cubit/firebase_cubits/auth/auth_states.dart';
// import '../../../ui/cubit/firebase_cubits/firestore/firestore_cubit.dart';
//
// final Map<String, dynamic> counters = {
//   'counter_1': 0,
//   'counter_2': 0,
//   'counter_3': 0,
// };
//
// class CounterController extends GetxController{
//   // int get counter_1 => counters['counter_1'];
//   var counter_1 = 0.obs;
//   var counter_2 = 0.obs;
//   var counter_3 = 0.obs;
//
//   // increment() => {};
//   initCounters(){
//     counter_1 = CacheHelper.getString(key: 'counter_1') as RxInt;
//   }
//
//   void increment(BuildContext context, {required String counterKey}) async{
//     int count = 0;
//     switch(counterKey){
//       case 'counter_1':
//         counter_1 = counter_1 + 1;
//         count = counter_1 as int;
//         break;
//       case 'counter_2':
//         count = counter_1 as int;
//         break;
//       case 'counter_3':
//         count = counter_1 as int;
//         break;
//     }
//
//     final firestore = FirestoreCubit.get(context);
//     final authState = AuthCubit.get(context).state;
//
//     counterMethods(context, count);
//     await CacheHelper.saveData(key: counterKey, value: count);
//     if(authState is AuthLoggedInState) {
//       String uid = authState.uId;
//       firestore.addCountGlobal(1);
//       firestore.addUserCount(uid: uid, counterKey: counterKey);
//     }
//   }
//
// }
