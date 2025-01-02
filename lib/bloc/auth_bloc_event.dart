part of 'auth_bloc_bloc.dart';

@immutable
sealed class AuthBlocEvent {}

class SignUpRequestEvent extends AuthBlocEvent {
  final String name;
  final String email;
  final String password;

  SignUpRequestEvent(
      {required this.name, required this.email, required this.password});
}

class SignInRequestEvent extends AuthBlocEvent {
  final String email;
  final String password;
  SignInRequestEvent({required this.email, required this.password});
}

class LogOutEvent extends AuthBlocEvent {}

class AppStartupEvent extends AuthBlocEvent {}
