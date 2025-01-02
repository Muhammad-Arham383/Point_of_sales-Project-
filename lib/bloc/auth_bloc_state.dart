part of 'auth_bloc_bloc.dart';

@immutable
sealed class AuthBlocState {}

final class AuthBlocInitialState extends AuthBlocState {}

final class AuthBlocLoadingState extends AuthBlocState {}

final class AuthBlocSuccessState extends AuthBlocState {}

final class AuthBlocErrorState extends AuthBlocState {
  final String error;
  AuthBlocErrorState({required this.error});
}
