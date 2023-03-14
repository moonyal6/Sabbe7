import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

Map ErrorType = {
  'wrong-password': "Password Incorrect",
  'user-disabled' : "This Account is Disabled",
  'user-not-found' : "This email is not registered",
  'email-already-in-use' : "Email already registered",
  'weak-password': "Your password should be at least 6 characters",
  'invalid-email' : "This email is invalid",
  'too-many-requests' : "Can't sign in now. Try again later",
  'unknown' : "An Unknown Error has Occurred",
};

abstract class AuthStates extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class AuthInitialState extends AuthStates {}


class AuthLoggedInState extends AuthStates {
  AuthLoggedInState(this.uId);
  final String uId;
}


class AuthLoggedOutState extends AuthStates {}


class AuthLoadingState extends AuthStates {}


class AuthErrorState extends AuthStates {
  AuthErrorState(this.errorMessage);
  final String errorMessage;
}