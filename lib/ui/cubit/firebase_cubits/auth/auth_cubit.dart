
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sabbeh_clone/data/api/auth_api.dart';
import 'package:sabbeh_clone/data/api/firestore_api.dart';



/*
todo:
    issue:
      - can't pass current user to state due variable type difference
      - 'getUser' returns error because 'auth.currentUser' can be null
    objectives:
      - use 'UserModel' instead of 'auth.currentUser'.
      - depend on Models and variable instead of 'auth.currentUser':
        * for api calls depend on uId.
      #DONE# create a 'auth_api' file for authentication methods.
    |
    - #DONE# edit 'createUser' method to create an email field and name the document
      by the user uid.
    - #Late# store uid in shared prefs for auto login in initial state.
*/
//
import 'package:sabbeh_clone/shared/helpers/cache_helper.dart';
import 'package:sabbeh_clone/ui/cubit/firebase_cubits/firestore/firestore_cubit.dart';

import '../../../../data/models/user_model.dart';
import 'auth_states.dart';

// import 'my_auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  static AuthCubit get(context) => BlocProvider.of(context);

  UserModel? currentUser;

  final _auth = AuthApi();


  // Future<void> initState() async{
  //   final initAuth = await FirebaseAuth.instance;
  //   auth = initAuth;
  //   if(auth.currentUser != null){
  //     // emit(AuthLoggedInState(auth.currentUser));// todo
  //   }
  //   else{
  //     emit(AuthLoggedOutState());
  //   }
  // }

  // void getCurrentUser(){
  //   if(_auth.currentUser == null){
  //     emit(AuthLoggedOutState());
  //   }
  //   else{
  //     UserModel user = UserModel(
  //     emit(state)
  //   }
  // }




  //// Create a New User
  // TODO #DONE#: call 'register' then call 'createUserFields' and catch error
  void createUser({required String email, required String password, required List<int> counters}) async {
    print('Auth State: Register: Loading');
    emit(AuthLoadingState());
    //register
    _auth.registerUser(
        email: email,
        password: password).then((value) {
      //create user fields
      createUserFields(
          email: email,
          uid: value.user!.uid,
          counters: counters);
    }).catchError((onError){
      emit(AuthErrorState(onError.toString()));
      print('Auth State: Register: Error');
      print('AuthError: Register: $onError');
    });
  }

  //// create user counter fields
  /*TODO #DONE#: get user data from parameters and store it in UserModel then call
       authApi 'createUserCounterFields' method and pass the UserModel */
  void createUserFields({required String email, required String uid, required List<int> counters}){
    //user model
    UserModel user = UserModel(
      id: uid,
      email: email,
      counters: counters,
    );
    //call auth method
    _auth.createUserDataDocs(user: user).then((value) {
      _auth.createUserCounterDocs(user: user).then((value) async{
        final result = user.counters.reduce((sum, value) => sum + value);
        FirestoreCubit().addCountGlobal(result);
        currentUser = user;
        emit(AuthLoggedInState(uid));
        bool isSaved = await CacheHelper.saveData(key: 'uid', value: currentUser!.id);
        print('is data saved: $isSaved');
        print('logged in');
        print(currentUser!.email);
        print('uId: ${CacheHelper.getString(key: 'uId')}');
      }).catchError((onError){
        emit(AuthErrorState(onError.toString()));
      });
    }).catchError((onError){
      emit(AuthErrorState(onError.toString()));
    });


  }


  ////sign in user
  //TODO: call login from api then call checkUser and catch error
  Future<void> signInUser({required String email, required String password}) async {
    print('Auth State: Loading');
    emit(AuthLoadingState());
    var uid;
    try {
      await _auth.loginUser(
          email: email,
          password: password
      ).then((value) async {
        checkUserExistInFirebase(uid: value.user!.uid);
        uid = value.user!.uid;
        print('logged in');

      }).catchError((onError) {
        emit(AuthErrorState(onError.toString()));
        print('Error Sign In: $onError');
      });
      bool isSaved = await CacheHelper.saveData(key: 'uid', value: uid);
      print('is data saved: $isSaved');
      print('uId: ${CacheHelper.getString(key: 'uId')}');
    }
    on FirebaseAuthException catch (e){
      print('AuthError: Sign In: ${e.code}');
    }
    catch(e){
      print('UnknownError: Sign In: $e');
    }
  }

  //// Check User in Firestore
  void checkUserExistInFirebase({required String uid}){
    print('Auth State: Sign In: Checking');
    _auth.checkUserExistInFirebase(uId: uid).then((user) {
      if(user.exists) {
        currentUser = UserModel.fromJsonMap(map: user.data()!, uId: uid);
        emit(AuthLoggedInState(uid));
        print('Auth State: Sign In: Success');
        print(currentUser!.email);
      }
      else{
        emit(AuthErrorState("Account doesn't exist"));
        print('Auth State: Sign In: Error');
        print('AuthError: Sign In: User Not Found');
      }
    }).catchError((onError) {
      emit(AuthErrorState(onError.toString()));
    });
  }


  void getUserData({required String? uId}) {
    print('getting user');
    if (uId != null) {
      if (uId.isNotEmpty) {
        _auth.getUserData(uId: uId).then((value) {
          if (value.exists) {
            print("User: $uId");
            currentUser =
                UserModel.fromJsonMap(map: value.data()!, uId: value.id);
          } else {
            print("User not found");
            print("User: $uId");
            emit(AuthLoggedOutState());
          }
          emit(AuthLoggedInState(uId));
        }).catchError((onError) {
          emit(AuthErrorState(onError.toString()));
        });
      }
      else{
        print("User not found");
        emit(AuthLoggedOutState());
      }
    }
  }


  //// Sign Out User
  void signOut(){
    emit(AuthLoadingState());
    _auth.signOut().then((value) {
      currentUser = null;
      emit(AuthLoggedOutState());
      CacheHelper.removeData(key: 'uid');
    }).catchError((onError){
      emit(AuthErrorState(onError.toString()));
    });
  }


  //// delete user and user docs
  //TODO: call 'deleteUser' then delete user's docs
  void deleteUser({required String uid}){
    emit(AuthLoadingState());
    _auth.deleteUserDataDocs(uId: uid).then((value) {
      _auth.deleteUserCounterDocs(uId: uid).then((value) {
        _auth.deleteUser(uId: uid)?.then((value) {
          currentUser = null;
          emit(AuthLoggedOutState());
          CacheHelper.removeData(key: 'uid');
          print('Auth State: Delete Account: Logged Out');
        }).catchError((onError){
          emit(AuthErrorState(onError.toString()));
          print('Auth State: Delete Account: Error');
          print('AuthError: Delete Account: $onError');
        });
      }).catchError((onError){
        emit(AuthErrorState(onError.toString()));
        print('Auth State: Delete Account: Error');
        print('AuthError: Delete Account: $onError');
      });
    }).catchError((onError){
      emit(AuthErrorState(onError.toString()));
      print('Auth State: Delete Account: Error');
      print('AuthError: Delete Account: $onError');
    });
  }


  //// update user email
  //TODO: update user's email in auth then in user collection
  void updateUserEmail({required String uid, required String newEmail}){
    emit(AuthLoadingState());
    _auth.updateEmail(newEmail: newEmail)?.then((value) {
      _auth.updateEmailDocs(
          uId: uid,
          newEmail: newEmail,
      ).catchError((onError){
        emit(AuthErrorState(onError.toString()));
      });
      //todo emit state
    }).catchError((onError){
      emit(AuthErrorState(onError.toString()));
    });
  }



  void resetPassword({required String newPassword}){
    emit(AuthLoadingState());
    _auth.updatePassword(newPassword: newPassword)?.then((value) {
      //todo emit state
    }).catchError((onError){
      emit(AuthErrorState(onError.toString()));
    });
  }


//   /* DEBUG METHODS */
//
//   //// Get Current User Data
//   User? getUserData() {
//
//     auth.currentUser != null?
//     print("Current User Data: ${auth.currentUser?.email}"):
//     print("No User Found!");
//     return auth.currentUser;
//   }
//
//
//   //// LogIn or create Sample account.
//   void logSample(BuildContext context){
//     final email = 'sample@gmail.com';
//     final password = '123456';
//     signInUser(email: email, password: password);
//     print("state: ${state}");
//     if(state is AuthErrorState){
//       createUser(context,
//         email: email,
//         password: password,
//       );
//     }
//     if(state is AuthLoggedInState){
//       //todo: call showSnackBar
//     }
//   }
//
}