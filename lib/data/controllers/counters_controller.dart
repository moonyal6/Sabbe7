import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:language_builder/language_builder.dart';
import 'package:provider/provider.dart';
import 'package:sabbeh_clone/shared/helpers/cache_helper.dart';

import '../../shared/constants/constants.dart';
import '../../shared/helpers/counter_methods.dart';
import '../../ui/cubit/firebase_cubits/auth/auth_cubit.dart';
import '../../ui/cubit/firebase_cubits/auth/auth_states.dart';
import '../../ui/cubit/firebase_cubits/firestore/firestore_cubit.dart';


final _defaultCounterData = {
  cnt1_key: {
    'name' : LanguageBuilder.texts!['@reports']['@local_report']['@counters'][cnt1_key],
    'count': 0,
    'default': true
  },
  cnt2_key: {
    'name' : LanguageBuilder.texts!['@reports']['@local_report']['@counters'][cnt2_key],
    'count': 0,
    'default': true
  },
  cnt3_key: {
    'name' : LanguageBuilder.texts!['@reports']['@local_report']['@counters'][cnt3_key],
    'count': 0,
    'default': true
  },
};



class CountersController extends ChangeNotifier{

  static CountersController get(context, {bool listen = true}) =>
      Provider.of<CountersController>(context, listen: listen);

  //todo: secure [_countersData] by methods
  Map<String, dynamic> _countersData = CacheHelper.getString(key: 'counters') != ''
      ? jsonDecode(CacheHelper.getString(key: 'counters'))
      : _defaultCounterData;

  get cnt1 => _countersData[cnt1_key];
  get cnt2 => _countersData[cnt2_key];
  get cnt3 => _countersData[cnt3_key];

  Map<String, dynamic> get countersMap => _countersData;

  Future<bool> _updateCache() async => await CacheHelper
      .saveData(key: 'counters', value: jsonEncode(_countersData));

  void increment(BuildContext context, {
    required String counterKey, required bool isDefault}) async
  {
    final firestore = FirestoreCubit.get(context);
    final authState = AuthCubit.get(context).state;

    _countersData[counterKey]!['count']++;
    final count = _countersData[counterKey]!['count'];
    notifyListeners();
    print(count);

    counterMethods(context, count);
    _updateCache();
    print('length ${countersMap.length}');

    if(authState is AuthLoggedInState) {
      String uid = authState.uId;
      firestore.addUserCount(
        context,
        uid: uid,
        counterKey: counterKey,
        isDefault: isDefault
      );
      if(isDefault) {
        firestore.addCountGlobal({counterKey: 1});
      }
    }
  }


  void addNewCounter(counterName){
    final int mapLength = _countersData.length;
    if(mapLength < 8){
      _countersData['counter_${mapLength+1}'] = {
        'name' : counterName,
        'count': 0,
        'default': false
      };
      print('added');
      print('length ${countersMap.length}');
      _updateCache();
      notifyListeners();
    }else{
      print('limit is 5 counters');
    }
  }

  void removeCounter(counterName){
    final int mapLength = _countersData.length;
    if(mapLength > 3){
      _countersData.remove(counterName);
      print('removed');
      print('length ${countersMap.length}');
      _updateCache();
      notifyListeners();
    }
    else{
      print('at least 3 counters');
    }
  }

  Future<void> resetCounterData(BuildContext context) async{

    await AuthCubit.get(context).signOut();
    _countersData = _defaultCounterData;
    _updateCache();
    notifyListeners();
  }
}