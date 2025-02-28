import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_project/bloc/bloc/cart_bloc.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  @override
  void initState() {
    super.initState();
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    context.read<CartBloc>().add(
          FetchTransactions(
            userId: uid,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sales History")),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoaded) {
            return ListView.builder(
              itemCount: state.transactions.length,
              itemBuilder: (context, index) {
                final transaction = state.transactions[index];

                return ListTile(
                  tileColor: Colors
                      .primaries[Random().nextInt(Colors.primaries.length)],
                  title: Text(transaction.title),
                  subtitle: Column(
                    children: [
                      Text("Quantity: ${transaction.quantity}"),
                      Text("Amount: \$${transaction.amount}"),
                    ],
                  ),
                  trailing: Text("Date: ${transaction.date}"),
                );
              },
            );
          } else {
            return const Center(child: Text("No sales history found."));
          }
        },
      ),
    );
  }
}
