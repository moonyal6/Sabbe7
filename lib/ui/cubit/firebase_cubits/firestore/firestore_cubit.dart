import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sabbeh_clone/data/api/firestore_api.dart';

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

   void addCountGlobal(int count) async {
     // firestoreIncrement(ref: _globalRef, field: 'global_count');
     _firestoreApi.getDoc(docRef: _globalRef).then((value){
       final result = value.data() as Map<String, dynamic>;
        print("global counter: ${result['total_counts']}");
        _firestoreApi.updateDoc(
            docRef: _globalRef,
            fields: {
              'total_counts': result['total_counts'] + count
            });
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

  void addUserCount({required String uid, required String counterKey}){
    _firestoreApi.getDoc(docRef: _userCounterCollection(uid)).then((value) {
      final result = value.data() as Map<String, dynamic>;
      _firestoreApi.updateDoc(
          docRef: _userCounterCollection(uid),
          fields: {
            counterKey: result[counterKey] + 1
          });
    });

  }

   void createUserCounters({required String uid}) async{
     _firestoreApi.setDoc(
         docRef: _userCounterCollection(uid),
         //todo get local counters as map to set them to firestore
         fields: {
           'counter_1': 0,
           'counter_2': 0,
           'counter_3': 0,
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




