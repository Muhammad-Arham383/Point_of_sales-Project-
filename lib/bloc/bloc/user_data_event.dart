part of 'user_data_bloc.dart';

@immutable
sealed class UserDataEvent {}

class FetchUserDataEvent extends UserDataEvent {
  final String uid;
  FetchUserDataEvent({required this.uid});
}
