import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_project/bloc/auth_bloc_bloc.dart';
import 'package:pos_project/bloc/bloc/cart_bloc.dart';
import 'package:pos_project/bloc/bloc/inventory_bloc.dart';
import 'package:pos_project/bloc/bloc/sales_bloc.dart';
import 'package:pos_project/bloc/bloc/user_data_bloc.dart';
import 'package:pos_project/screens/sign_up_screen.dart';
import 'package:pos_project/services/firestore_services.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.android, name: 'Updated');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBlocBloc>(
          create: (context) => AuthBlocBloc(firestoreService),
        ),
        BlocProvider<InventoryBloc>(
          create: (context) => InventoryBloc(firestoreService),
        ),
        BlocProvider(
            create: (context) =>
                UserDataBloc(firestoreService: firestoreService)),
        BlocProvider(
          create: (context) => CartBloc(
              firestoreService: firestoreService,
              inventoryBloc: context.read<InventoryBloc>()),
        ),
        BlocProvider(create: (context) => ReportBloc(firestoreService))
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Point Of Sale'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    context.read<AuthBlocBloc>().add(AppStartupEvent());

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (uid.isNotEmpty) {
        context.read<UserDataBloc>().add(FetchUserDataEvent(uid: uid));
      }
    } catch (e) {
      Text('Error fetching user: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SignUpScreen());
  }
}
