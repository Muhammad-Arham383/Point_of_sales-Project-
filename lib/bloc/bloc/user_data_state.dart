part of 'user_data_bloc.dart';

@immutable
sealed class UserDataState {}

final class UserDataInitialState extends UserDataState {}

final class UserDataLoadingState extends UserDataState {}

final class UserDataLoadedState extends UserDataState {
  UserDataLoadedState({required this.userName});
  final String userName;
}

final class UserDataErrorState extends UserDataState {
  UserDataErrorState({required this.errorMessage});
  final String errorMessage;
}
