import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:language_builder/language_builder.dart';
import 'package:provider/provider.dart';
import 'package:sabbeh_clone/shared/helpers/cache_helper.dart';

import '../../../shared/constants/constants.dart';
import '../../../shared/helpers/counter_methods.dart';
import '../firebase_cubits/auth/auth_cubit.dart';
import '../firebase_cubits/auth/auth_states.dart';
import '../firebase_cubits/firestore/firestore_cubit.dart';

class CountersProvider extends ChangeNotifier{

  static CountersProvider get(context, {bool listen = true}) =>
      Provider.of<CountersProvider>(context, listen: listen);

  //todo: secure [_countersData] by methods
  Map<String, dynamic> _countersData = CacheHelper.getString(key: 'counters') != ''
      ? jsonDecode(CacheHelper.getString(key: 'counters'))
      : {
          cnt1_key: {
            'name' : LanguageBuilder.texts!['@reports']['@local_report']['@counters'][cnt1_key],
            'count': 0
          },
          cnt2_key: {
            'name' : LanguageBuilder.texts!['@reports']['@local_report']['@counters'][cnt2_key],
            'count': 0
          },
          cnt3_key: {
            'name' : LanguageBuilder.texts!['@reports']['@local_report']['@counters'][cnt3_key],
            'count': 0
          },
        };

  get cnt1 => _countersData[cnt1_key];
  get cnt2 => _countersData[cnt2_key];
  get cnt3 => _countersData[cnt3_key];

  Map<String, dynamic> get countersMap => _countersData;


  void increment(BuildContext context, {
    required String counterKey}) async{
    final firestore = FirestoreCubit.get(context);
    final authState = AuthCubit.get(context).state;

    _countersData[counterKey]!['count']++;
    notifyListeners();
    final count = _countersData[counterKey]!['count'];
    print(count);

    counterMethods(context, count);
    await CacheHelper.saveData(key: 'counters', value: jsonEncode(_countersData));
    print('length ${countersMap.length}');


    if(authState is AuthLoggedInState) {
      String uid = authState.uId;
      // firestore.addCountGlobal({counterKey: 1});
      firestore.addUserCount(
          uid: uid,
          counterKey: counterKey
      );
    }
  }


  void addNewCounter(counterName){
    final int mapLength = _countersData.length;
    if(mapLength < 5){
      _countersData['counter_${mapLength+1}'] = {
        'name' : counterName,
        'count': 0,
      };
      print('added');
      print('length ${countersMap.length}');
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
      notifyListeners();
    }
    else{
      print('at least 3 counters');
    }
  }
}