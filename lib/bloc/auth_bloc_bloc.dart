import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:pos_project/models/users.dart';
import 'package:pos_project/services/firestore_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

class AuthBlocBloc extends Bloc<AuthBlocEvent, AuthBlocState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService firestoreService;

  AuthBlocBloc(this.firestoreService) : super(AuthBlocInitialState()) {
    on<SignUpRequestEvent>((event, emit) async {
      emit(AuthBlocLoadingState());

      try {
        UserCredential userCredential =
            await _firebaseAuth.createUserWithEmailAndPassword(
                email: event.email, password: event.password);

        final user = Users(
            name: event.name, email: event.email, password: event.password);

        bool isAdded =
            await firestoreService.addUser(user, userCredential.user!.uid);

        if (isAdded) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool("isLoggedIn", true);
          await prefs.setString('userId', userCredential.user!.uid);
          emit(AuthBlocSuccessState());
        }
      } catch (e) {
        emit(AuthBlocErrorState(error: 'failed to add user to firestore $e'));
      }
    });

    on<SignInRequestEvent>((event, emit) async {
      emit(AuthBlocLoadingState());

      try {
        final credentials = await _firebaseAuth.signInWithEmailAndPassword(
            email: event.email, password: event.password);

        DocumentSnapshot userDoc = await firestoreService.userCollection
            .doc(credentials.user!.uid)
            .get();

        if (userDoc.exists) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool("isLoggedIn", true);
          await prefs.setString('userId', credentials.user!.uid);
          emit(AuthBlocSuccessState());
        } else {
          emit(AuthBlocErrorState(error: 'user not exists in the database'));
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('no user found for that email');
        } else if (e.code == 'wrong-password') {
          print('wrong password provided for that user');
        }
      }
    });
    on<AppStartupEvent>((event, emit) async {
      emit(AuthBlocLoadingState());

      try {
        final prefs = await SharedPreferences.getInstance();
        final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

        if (isLoggedIn) {
          emit(AuthBlocSuccessState());
        } else {
          emit(AuthBlocInitialState());
        }
      } catch (e) {
        emit(AuthBlocErrorState(error: e.toString()));
      }
    });
    on<LogOutEvent>((event, emit) async {
      emit(AuthBlocLoadingState());
      try {
        await _firebaseAuth.signOut();
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove("isLoggedIn");
        await prefs.remove("userId");
        emit(AuthBlocInitialState());
      } catch (e) {
        emit(AuthBlocErrorState(error: 'signOut failed: $e'));
      }
    });

    on<FetchUserDataEvent>((event, emit) async {
      emit(UserDataLoadingState());
      print("Fetching user data for UID: ${event.uid}");
      try {
        final userData = await firestoreService.getUserData(event.uid);
        final userName = userData['name'] as String;
        emit(UserDataLoadedState(userName: userName));
      } catch (e) {
        print('Error fetching user: ${e.toString()}');

        emit(UserDataErrorState(error: e.toString()));
      }
    });
  }
}
