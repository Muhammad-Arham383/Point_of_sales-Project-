import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_project/bloc/bloc/inventory_bloc.dart';
import 'package:pos_project/screens/sales_screen.dart';
import 'package:pos_project/widgets/containerListTile.dart';

class SalesReport extends StatelessWidget {
  const SalesReport({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (builder) => const SalesScreen()));
        },
        child: const Icon(Icons.add),
      ),
      body:
          BlocBuilder<InventoryBloc, InventoryState>(builder: (context, state) {
        if (state is InventoryLoadingState) {
          return const CircularProgressIndicator();
        } else if (state is InventoryLoadedState) {
          ListView.builder(
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
          return Text(state.errorMessage);
        } else {
          return const Center(child: Text('no Product found'));
        }
        return const Center(child: Text('no Product found'));
      }),
    );
  }
}
