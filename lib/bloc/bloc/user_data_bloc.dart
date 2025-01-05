import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pos_project/services/firestore_services.dart';
part 'user_data_event.dart';
part 'user_data_state.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  final FirestoreService firestoreService;
  UserDataBloc({required this.firestoreService})
      : super(UserDataInitialState()) {
    on<FetchUserDataEvent>((event, emit) async {
      emit(UserDataLoadingState());
      print("Fetching user data for UID: ${event.uid}");
      try {
        final userData = await firestoreService.getUserData(event.uid);
        final userName = userData['name'] as String;
        emit(UserDataLoadedState(userName: userName));
      } catch (e) {
        print('Error fetching user: ${e.toString()}');

        emit(UserDataErrorState(errorMessage: e.toString()));
      }
    });
  }
}
