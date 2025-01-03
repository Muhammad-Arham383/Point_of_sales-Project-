part of 'auth_bloc_bloc.dart';

@immutable
sealed class AuthBlocState {}

final class AuthBlocInitialState extends AuthBlocState {}

final class AuthBlocLoadingState extends AuthBlocState {}

final class AuthBlocSuccessState extends AuthBlocState {}

final class UserDataLoadingState extends AuthBlocState {}

final class UserDataLoadedState extends AuthBlocState {
  UserDataLoadedState({required this.userName});
  final String userName;
}

final class UserDataErrorState extends AuthBlocState {
  final String error;
  UserDataErrorState({required this.error});
}

final class AuthBlocErrorState extends AuthBlocState {
  final String error;
  AuthBlocErrorState({required this.error});
}
