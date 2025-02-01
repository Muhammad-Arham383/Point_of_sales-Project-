import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_project/bloc/bloc/cart_bloc.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.cartItems.isEmpty) {
            return const Center(child: Text("Your cart is empty"));
          }
          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: state.cartItems.values.map((item) {
                    return ListTile(
                      title: Text(item.productName),
                      subtitle: Text(
                          "Price: \$${item.price} x ${item.stockQuantity}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              if (item.stockQuantity > 1) {
                                context.read<CartBloc>().add(
                                    UpdateProductQuantity(item.productId,
                                        item.stockQuantity - 1));
                              }
                            },
                          ),
                          Text(item.stockQuantity.toString()),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              context.read<CartBloc>().add(
                                  UpdateProductQuantity(
                                      item.productId, item.stockQuantity + 1));
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              Text("Total: \$${state.totalPrice}"),
              ElevatedButton(
                onPressed: () {
                  context.read<CartBloc>().add(ConfirmPurchase());
                },
                child: const Text("Confirm Purchase"),
              ),
            ],
          );
        },
      ),
    );
  }
}
