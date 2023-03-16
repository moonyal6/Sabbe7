import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sabbeh_clone/shared/helpers/cache_helper.dart';

import '../../../shared/helpers/counter_methods.dart';
import '../firebase_cubits/auth/auth_cubit.dart';
import '../firebase_cubits/auth/auth_states.dart';
import '../firebase_cubits/firestore/firestore_cubit.dart';

mixin CounterMixin {
  void increment(BuildContext context, {
    required int count, required String counterKey}) async{
    final firestore = FirestoreCubit.get(context);
    final authState = AuthCubit.get(context).state;

    counterMethods(context, count);
    await CacheHelper.saveData(key: counterKey, value: count);
    if(authState is AuthLoggedInState) {
      String uid = authState.uId;
      firestore.addCountGlobal({counterKey: 1});
      firestore.addUserCount(
          uid: uid,
          counterKey: counterKey
      );
    }

    // await context.read<SharedPrefCubit>().incrementCounter();
    // print(context.read<SharedPrefCubit>().counter);
  }

  void reset(BuildContext context, String counterField){
    context.read<FirestoreCubit>().resetUserCount(context, counterField);
  }
}