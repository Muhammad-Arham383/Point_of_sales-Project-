import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_project/bloc/bloc/inventory_bloc.dart';
import 'package:pos_project/screens/products_form.dart';
import 'package:pos_project/widgets/containerListTile.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    context.read<InventoryBloc>().add(ProductsFetchEvent(userId: userId));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade200,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 41, 121, 255),
        title: const Text('Inventory'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const InventoryManagement()));
        },
        child: const Icon(Icons.add),
      ),
      body:
          BlocBuilder<InventoryBloc, InventoryState>(builder: (context, state) {
        if (state is InventoryLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is InventoryLoadedState) {
          return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: width * 0.02),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: ListTileContainer(
                      productName: product.productName,
                      productCategory: product.productCategory,
                      stockQuantity: product.stockQuantity,
                      price: product.price),
                );
              });
        } else if (state is InventoryErrorState) {
          return Center(
            child: Text(state.errorMessage),
          );
        } else {
          return const Center(child: Text('no Product found'));
        }
      }),
    );
  }
}
