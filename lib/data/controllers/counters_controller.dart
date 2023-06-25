import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:language_builder/language_builder.dart';
import 'package:provider/provider.dart';
import 'package:sabbeh_clone/shared/helpers/cache_helper.dart';

import '../../shared/constants/cache_constants.dart';
import '../../shared/constants/constants.dart';
import '../../shared/helpers/counter_methods.dart';
import '../../ui/cubit/firebase_cubits/auth/auth_cubit.dart';
import '../../ui/cubit/firebase_cubits/auth/auth_states.dart';
import '../../ui/cubit/firebase_cubits/firestore_cubit.dart';


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

  //todo: make _countersData an object  
  Map<String, dynamic> _countersData = CacheHelper.getString(
      key: CacheKeys.startupTime) != ''
      ? jsonDecode(CacheHelper.getString(key: CacheKeys.counters))
      : _defaultCounterData;

  Map sessionCounters = {};


  get cnt1 => _countersData[cnt1_key];
  get cnt2 => _countersData[cnt2_key];
  get cnt3 => _countersData[cnt3_key];


  Map<String, dynamic> get countersMap => _countersData;

  // Map<String, dynamic> get sessionCounters => _sessionCounters;

  // Map<String, dynamic> get sessionCounters => _sessionCounters;

  DateTime _now = DateTime.now();

  void _updateCache() async {
    // notifyListeners();
    CacheHelper.saveData(key: CacheKeys.counters, value: jsonEncode(_countersData));
  }


  void incrementSessionMap(String key){
    sessionCounters.update(key, (value) => ++value, ifAbsent: () => 1);
    notifyListeners();
  }


  void resetSessionMap(String key){
    sessionCounters.update(key, (value) => 0);
    notifyListeners();
  }


  Future<void> increment(BuildContext context, {
    required String counterKey, int count = 1, required bool isDefault, bool active = false}) async
  {
    final firestore = FirestoreCubit.get(context);
    final authState = AuthCubit.get(context).state;

    _countersData[counterKey]!['count'] = _countersData[counterKey]!['count'] + count;
    // active? sessionCounters.update(counterKey, (value) => value + 1, ifAbsent: () => 1): null;
    print('sessionCounter: ${sessionCounters[counterKey].toString()}');
    notifyListeners();
    final newCount = _countersData[counterKey]!['count'];
    print('$counterKey count: $newCount');

    counterMethods(context, newCount);
    _updateCache();

    if(authState is AuthLoggedInState) {
      String uid = authState.uId;
      // firestore.addCountGlobal({counterKey: 1});
      firestore.addUserCount(
          uid: uid,
          counterKey: counterKey,
          count: newCount, isDefault: isDefault
      );
      if(isDefault) {
        // firestore.addCountGlobal({counterKey: count});
      }
    }
  }


  Future<void> backgroundIncrement(BuildContext context) async
  {
    print('background adding');
    int backgroundCount = await CacheHelper.getInteger(
        key: CacheKeys.backgroundAdding);
    for(var key in _countersData.keys) {
      await increment(context,
        counterKey: key,
        count: backgroundCount,
        isDefault: _countersData[key]['default'],
        active: false
      );
    }
    // notifyListeners();
    // CacheHelper.removeData(key: 'background_adding');
  }


  Future<void> dailyReset({bool isDebug = false}) async
  {
    final cacheStartTime = await CacheHelper.getString(
        key: CacheKeys.startupTime);

    final previousStartupTime = cacheStartTime.isNotEmpty
        ? DateTime.parse(cacheStartTime) : DateTime.now();
    final nextMidnight = DateTime(
        previousStartupTime.year,
        previousStartupTime.month,
        previousStartupTime.day + 1); // returns exactly the next midnight

    final next5mins = previousStartupTime.add(Duration(minutes: 5));

    if (_now.isAfter(nextMidnight) || isDebug) {
      print('daily resting counters');
      for(var key in _countersData.keys) {
        _countersData[key]['count'] = 0;
      }
      _updateCache();
    }
     await CacheHelper.saveData(key: CacheKeys.startupTime,
         value: _now.toString(), dPrint: true);
    notifyListeners();
  }


  void addNewCounter(String counterName){
    final String newCounterKey = 'counter_${_countersData.length+1}';
    if(_countersData.length < 8){
      _countersData[newCounterKey] = {
        'name' : counterName.trim(),
        'count': 0,
        'default': false
      };
      sessionCounters[newCounterKey] = 0;
      print('added new counter: $newCounterKey');
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
      sessionCounters.remove(counterName);
      print('removed');
      print('length ${countersMap.length}');
      _updateCache();
      notifyListeners();
    }
    else{
      print('at least 3 counters');
    }
  }


  Future<void> resetCounterData(BuildContext context) async
  {
    await AuthCubit.get(context).signOut();
    _countersData = _defaultCounterData;
    _updateCache();
    notifyListeners();
  }


  Future<void> updateCountersNames() async
  {
    print('Updating counters lang to ${LanguageBuilder.getCurrentLang()}');
    _countersData[cnt1_key]['name'] = LanguageBuilder
        .texts!['@reports']['@local_report']['@counters'][cnt1_key];
    _countersData[cnt2_key]['name'] = LanguageBuilder
        .texts!['@reports']['@local_report']['@counters'][cnt2_key];
    _countersData[cnt3_key]['name'] = LanguageBuilder
        .texts!['@reports']['@local_report']['@counters'][cnt3_key];
    _updateCache();
    notifyListeners();
  }

}
