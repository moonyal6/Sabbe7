import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sabbeh_clone/data/api/auth_api.dart';



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


class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  static AuthCubit get(context) => BlocProvider.of(context);

  UserModel? currentUser;

  final _auth = AuthApi();


  //// Create a New User
  // TODO #DONE#: call 'register' then call 'createUserFields' and catch error
  Future<void> createUser(
      {required String email, required String password, required Map<String, int> counters}) async {
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
  void createUserFields(
      {required String email, required String uid, required Map<String, int> counters}){
    //user model
    UserModel user = UserModel(
      id: uid,
      email: email,
      counters: counters,
    );
    //call auth method
    _auth.createUserDataDocs(user: user).then((value) {
      _auth.createUserCounterDocs(user: user).then((value) async{
        // final result = user.counters.reduce((sum, value) => sum + value);
        FirestoreCubit().addCountGlobal(counters);
        currentUser = user;
        emit(AuthLoggedInState(uid));
        await CacheHelper.saveData(key: 'uid', value: currentUser!.id);
      }).catchError((onError){
        _auth.deleteUserDataDocs(uId: uid);
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
      await CacheHelper.saveData(key: 'uid', value: uid);
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


  Future<void> getUserData({required String? uId}) async{
    if (uId != null) {
      if (uId.isNotEmpty) {
        await _auth.getUserData(uId: uId).then((value) {
          if (value.exists) {
            currentUser = UserModel.fromJsonMap(
                map: value.data()!,
                uId: value.id
            );
          } else {
            print("User not found");
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
  Future<void> signOut()async {

    if(state is AuthLoggedInState){
      _auth.signOut().then((value) async {
        print('signing out');
        currentUser = null;
        emit(AuthLoggedOutState());
        await CacheHelper.removeData(key: 'uid');
        print('signed out success');
      }).catchError((onError) {
        emit(AuthErrorState(onError.toString()));
        print("can't sign out");
      });
    }
    else{
      print("can't find user");
      emit(AuthErrorState('No User Found'));
    }
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