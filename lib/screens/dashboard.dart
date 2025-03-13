import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_project/bloc/auth_bloc_bloc.dart';
import 'package:pos_project/bloc/bloc/sales_bloc.dart';
import 'package:pos_project/bloc/bloc/sales_event.dart';
import 'package:pos_project/bloc/bloc/sales_state.dart';
import 'package:pos_project/bloc/bloc/user_data_bloc.dart';
import 'package:pos_project/screens/inventory.dart';

import 'package:pos_project/screens/sales_screen.dart';
// import 'package:pos_project/screens/sales_report.dart';
import 'package:pos_project/widgets/image_picker_circle_avatar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    String uid = FirebaseAuth.instance.currentUser!.uid;

    context.read<ReportBloc>().add(FetchDailyReport(uid));
    context.read<ReportBloc>().add(FetchWeeklyReport(uid));
    context.read<ReportBloc>().add(FetchMonthlyReport(uid));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.lightBlue.shade200,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Dashboard'),
        ),
        drawer: Drawer(
            backgroundColor: Colors.white,
            child: Column(
              spacing: height * 0.05,
              children: [
                SizedBox(
                  width: width * 1.0,
                  height: height * 0.35,
                  child: DrawerHeader(
                    decoration: const BoxDecoration(
                      color: const Color.fromARGB(255, 120, 225, 244),
                      boxShadow: [
                        BoxShadow(color: Colors.white),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Center(
                            child: ImagePickerCircleAvatar(
                          radius: 50,
                        )),
                        SizedBox(
                          height: height * 0.05,
                          width: width * 0.4,
                          child: Center(
                            child: BlocBuilder<UserDataBloc, UserDataState>(
                              builder: (context, state) {
                                if (state is UserDataLoadingState) {
                                  return const CircularProgressIndicator();
                                } else if (state is UserDataLoadedState) {
                                  return Text(
                                    'Welcome ${state.userName}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  );
                                } else {
                                  return const Text('unable to fetch user');
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Dashboard'),
                  leading: const Icon(Icons.dashboard),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Dashboard(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Inventory Management'),
                  leading: const Icon(Icons.inventory),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Inventory()));
                  },
                ),
                ListTile(
                  title: const Text('Sales'),
                  leading: const Icon(Icons.point_of_sale_sharp),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SalesScreen()));
                  },
                ),
                ListTile(
                  title: const Text('log out'),
                  leading: const Icon(Icons.logout),
                  onTap: () async {
                    context.read<AuthBlocBloc>().add(LogOutEvent());
                  },
                )
              ],
            )),
        body: BlocBuilder<ReportBloc, ReportState>(
          builder: (context, state) {
            if (state is ReportLoading) {
              return const CircularProgressIndicator();
            } else if (state is ReportLoaded) {
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.white,
                              offset: Offset(5, 5),
                              blurRadius: 7),
                          BoxShadow(
                              color: Colors.lightBlue,
                              offset: Offset(-8, -8),
                              blurRadius: 20),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        color: Color.fromARGB(255, 3, 209, 255),
                      ),
                      padding: EdgeInsets.all(9),
                      width: width * 0.4,
                      height: height * 0.4,
                      child: Center(
                          child: Text('Daily Sales: ${state.totalAmount}')),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.white,
                              offset: Offset(5, 5),
                              blurRadius: 7),
                          BoxShadow(
                              color: Colors.lightBlue,
                              offset: Offset(-8, -8),
                              blurRadius: 20),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        color: Color.fromARGB(255, 3, 209, 255),
                      ),
                      padding: EdgeInsets.all(9),
                      width: width * 0.4,
                      height: height * 0.4,
                      child: Center(
                        child: Text('Weekly Sales: ${state.totalAmount}'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.white,
                              offset: Offset(5, 5),
                              blurRadius: 7),
                          BoxShadow(
                              color: Colors.lightBlue,
                              offset: Offset(-8, -8),
                              blurRadius: 20),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        color: Color.fromARGB(255, 3, 209, 255),
                      ),
                      padding: EdgeInsets.all(9),
                      width: width * 0.4,
                      height: height * 0.4,
                      child: Center(
                          child: Text('Monthly Sales: ${state.totalAmount}')),
                    ),
                  ),
                ],
              );
            } else if (state is ReportError) {
              return Text(state.message);
            } else {
              return const Text("No data available");
            }
          },
        ));
  }
}
