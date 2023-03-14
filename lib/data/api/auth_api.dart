import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

const userCollection = 'users';
const countersCollection = 'counters';

class AuthApi {

  User? get currentUser => FirebaseAuth.instance.currentUser;

  Future<UserCredential> loginUser(
      {required String email, required String password}) {
    return FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> registerUser(
      {required String email, required String password}) {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createUserDataDocs(
      {required UserModel user})  {
   return FirebaseFirestore.instance
        .collection(userCollection)
        .doc(user.id)
        .set(user.toMap());
  }

  Future<void> createUserCounterDocs({required UserModel user}){
    return FirebaseFirestore.instance
        .collection(countersCollection)
        .doc(user.id)
        .set(user.counterMap());
  }

  Future<void> signOut(){
    return FirebaseAuth.instance.signOut();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> checkUserExistInFirebase(
      {required String uId}) {
    return FirebaseFirestore.instance.collection(userCollection).doc(uId).get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData(
      {required String uId}) {
    return FirebaseFirestore.instance.collection(userCollection).doc(uId).get();
  }

  Future<void>? deleteUser({required String uId}){
    return FirebaseAuth.instance.currentUser?.delete();
  }

  Future<void> deleteUserDataDocs({required String uId}){
    return FirebaseFirestore.instance
        .collection(userCollection)
        .doc(uId).delete();
  }

  Future<void> deleteUserCounterDocs({required String uId}){
    return FirebaseFirestore.instance
        .collection(countersCollection)
        .doc(uId).delete();
  }

  Future<void>? updateEmail({required String newEmail}) {
    return FirebaseAuth.instance.currentUser?.updateEmail(newEmail);
  }

  Future<void> updateEmailDocs({required String uId, required String newEmail}) {
    return FirebaseFirestore.instance.collection(userCollection).doc(uId).update({
      'email': newEmail
    });
  }

  Future<void>? updatePassword({required String newPassword}) {
    return FirebaseAuth.instance.currentUser?.updatePassword(newPassword);
  }

}
