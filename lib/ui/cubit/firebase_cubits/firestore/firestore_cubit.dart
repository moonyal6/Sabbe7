import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sabbeh_clone/data/api/firestore_api.dart';
import 'package:sabbeh_clone/shared/constants/constants.dart';
import 'package:sabbeh_clone/shared/helpers/cache_helper.dart';

import 'firestore_states.dart';


const exampleRef = 'counters/sample@mail.com';


/*
todo:
  - edit firestore collections to separate global data and users data and counters:
        * Users collection:
            should contain only users data for example email, name, uId ect.
        * Counters collection:
            contains all users counters each document named by user's id.
        * Global Data collection:
            this collection has the global counters and it's a space for other
            data shared for all users.

 */

class FirestoreCubit extends Cubit<FirestoreStates>{
  FirestoreCubit(): super(FirestoreInitialState());

  static FirestoreCubit get(context) => BlocProvider.of(context);

  String _userCounterCollection(uid) => 'counters/$uid';

  final _firestoreApi = FirestoreApi();

  final _globalRef = "/global_data/global_counters";


  /* Global Counter Methods */

   void addCountGlobal(Map<String, int> counters) {
     // firestoreIncrement(ref: _globalRef, field: 'global_count');

      _firestoreApi.getDoc(docRef: _globalRef).then((value) async{
        try{
          final result = value.data() as Map<String, dynamic>;
          print("adding to global");
          int totalCount = counters.values.reduce((sum, value) => sum + value);
          counters['total_counts'] = totalCount;

          final newData = result;
          for (var key in counters.keys) {
            newData.update(key, (value) => value + counters[key]);
          }

          print("global counter: ${newData['total_counts']}");
          await _firestoreApi.updateDoc(docRef: _globalRef, fields: newData);

          print("added");
        }
        catch(e){
          print("can't add to global : $e");
        }
      });


  }

   void resetGlobalCounter() async{
     // firestoreResetCounter(ref: globalRef, field: "global_count");
     _firestoreApi.updateDoc(
         docRef: _globalRef,
         fields: {
           'total_counts': 0
         });
   }

   Stream globalCounterStream(){
      return _firestoreApi.docStream(docRef: _globalRef);
   }



   /* User Counter Methods */

  getUserCounters({required String uid}){
    return _firestoreApi.getDoc(docRef: _userCounterCollection(uid));
  }

  void addUserCount({required String uid, required String counterKey}){
    _firestoreApi.getDoc(docRef: _userCounterCollection(uid)).then((value) {
      final result = value.data() as Map<String, dynamic>;
      try{
        _firestoreApi.updateDoc(
            docRef: _userCounterCollection(uid),
            fields: {counterKey: result[counterKey] + 1});
      }
      catch(e){
        print('field not found');
        _firestoreApi.updateDoc(
            docRef: _userCounterCollection(uid),
            fields: {counterKey: CacheHelper.getInteger(key: counterKey)});
      }
    });
  }

  void updateUserCounterDocs({required String? uid}){
    print('Checking User Counter Docs');
    print('up uid: $uid');
    if(uid != null){
      print('updating');
      _firestoreApi.getDoc(docRef: _userCounterCollection(uid)).then((value) {
        final result = value.data() as Map<String, dynamic>;
        docContains(key) => result.containsKey(key);
        if (!docContains(cnt4_key) &&
            !docContains(cnt5_key) &&
            !docContains(cnt6_key)) {
          int counter4 = CacheHelper.getInteger(key: cnt4_key);
          int counter5 = CacheHelper.getInteger(key: cnt5_key);
          int counter6 = CacheHelper.getInteger(key: cnt6_key);
          _firestoreApi.updateDoc(docRef: _userCounterCollection(uid), fields: {
            'counter_4': counter4,
            'counter_5': counter5,
            'counter_6': counter6,
          });
        }
        print('updated');
      });
    }else{print('not updated');}
  }

   void createUserCounters({required String uid}) async{
     _firestoreApi.setDoc(
         docRef: _userCounterCollection(uid),
         //todo get local counters as map to set them to firestore
         fields: {
           'counter_1': 0,
           'counter_2': 0,
           'counter_3': 0,
           'counter_4': 0,
           'counter_5': 0,
           'counter_6': 0,
         });
   }

   void resetUserCount(BuildContext context, String counterField) {
     // firestoreResetCounter(ref: ref, field: counterField);
     String uid = 'uid';
     _firestoreApi.updateDoc(
         docRef: uid,
         fields: {
           'counter_1': 0,
           'counter_2': 0,
           'counter_3': 0,
         });
   }

   void deleteUserCounters(String? email){
     // _db.doc('counters/$email').delete();
     String uid = 'uid';
     _firestoreApi.deleteDoc(docRef: uid);
   }

}




