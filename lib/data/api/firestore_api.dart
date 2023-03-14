// create, read, update, delete
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreApi {

  Future<void> setDoc({required String docRef, required Map<String, dynamic> fields}) {
    return FirebaseFirestore.instance.doc(docRef).set(fields);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDoc({required String docRef}) {
    return FirebaseFirestore.instance.doc(docRef).get();
  }

  Future<void> updateDoc({required String docRef, required Map<String, dynamic> fields}) {
    return FirebaseFirestore.instance.doc(docRef).update(fields);
  }

  Future<void> deleteDoc({required String docRef}) async {
    return FirebaseFirestore.instance.doc(docRef).delete();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> docStream({required String docRef}) {
    return FirebaseFirestore.instance.doc(docRef).snapshots();
  }

}