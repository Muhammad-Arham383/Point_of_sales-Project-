import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_project/bloc/bloc/cart_bloc.dart';
import 'package:pos_project/bloc/bloc/inventory_bloc.dart';
import 'package:pos_project/models/products.dart';
// import 'package:pos_project/screens/cart.dart';
import 'package:pos_project/screens/products_form.dart';
// import 'package:pos_project/screens/receipt.dart';
import 'package:pos_project/widgets/containerListTile.dart';

class Inventory extends StatefulWidget {
  const Inventory({
    super.key,
  });

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  @override
  void initState() {
    super.initState();
    _productName = TextEditingController();
    _category = TextEditingController();
    _stock = TextEditingController();
    _price = TextEditingController();
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    context.read<InventoryBloc>().add(ProductsFetchEvent(userId: userId));
  }

  late TextEditingController _productName;
  late TextEditingController _category;
  late TextEditingController _stock;
  late TextEditingController _price;
  // void showReceipt(BuildContext context) {
  //   final cartItems =
  //       context.read<CartBloc>().state.cartItems; // ✅ Get cart items from Bloc
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (context) {
  //       return ReceiptScreen(
  //         purchasedProducts: cartItems.values.map((item) {
  //           return {
  //             'name': item.productName,
  //             'price': item.price,
  //             'quantity': item.stockQuantity,
  //           };
  //         }).toList(),
  //       );
  //     },
  //   );
  // }
  void showDialoge(BuildContext context, Products product) {
    _productName.text = product.productName;
    _category.text = product.productCategory;
    _stock.text = product.stockQuantity.toString();
    _price.text = product.price.toString();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Product'),
            content: Column(
              children: [
                TextField(
                  controller: _productName,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                  ),
                ),
                TextField(
                  controller: _category,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                  ),
                ),
                TextField(
                  controller: _stock,
                  decoration: const InputDecoration(
                    labelText: 'Stock',
                  ),
                ),
                TextField(
                  controller: _price,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  var userId = FirebaseAuth.instance.currentUser?.uid ?? '';
                  final updatedProduct = Products(
                    productName: _productName.text,
                    productCategory: _category.text,
                    stockQuantity: int.parse(_stock.text),
                    price: double.parse(_price.text),
                    productId:
                        product.productId, // Add the correct productId here
                  );
                  context.read<InventoryBloc>().add(
                        UpdateProductEvent(
                            product: updatedProduct, userID: userId),
                      );
                  context
                      .read<InventoryBloc>()
                      .add(ProductsFetchEvent(userId: userId));
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          );
        });
  }

  void showCart(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state.cartItems.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: const Text("Your cart is empty"),
              );
            }
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...state.cartItems.values.map((item) => ListTile(
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
                                            item.stockQuantity - 1),
                                      );
                                }
                              },
                            ),
                            Text(item.stockQuantity.toString()),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                context.read<CartBloc>().add(
                                      UpdateProductQuantity(item.productId,
                                          item.stockQuantity + 1),
                                    );
                              },
                            ),
                          ],
                        ),
                      )),
                  Text("Total: \$${state.totalPrice}"),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CartBloc>().add(ConfirmPurchase());
                      Navigator.pop(context);
                      Future.delayed(const Duration(milliseconds: 500), () {
                        // showReceipt(context);
                      });
                      // Close the bottom sheet
                    },
                    child: const Text("Confirm Purchase"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _productName.dispose();
    _category.dispose();
    _stock.dispose();
    _price.dispose();
    super.dispose();
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
                final isSelected = context
                    .watch<CartBloc>()
                    .state
                    .cartItems
                    .containsKey(product.productId);
                return Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: ListTileContainer(
                    icon: isSelected
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: isSelected ? Colors.lightBlue : null,
                    onTap: () {
                      context
                          .read<CartBloc>()
                          .add(ToggleProductSelection(product));
                      showCart(context);
                    },
                    productName: product.productName,
                    productCategory: product.productCategory,
                    stockQuantity: product.stockQuantity,
                    price: product.price,
                    onPressed: () {
                      final userId =
                          FirebaseAuth.instance.currentUser?.uid ?? '';
                      context.read<InventoryBloc>().add(
                            DeleteProductEvent(
                              userId: userId, // The current logged-in user's ID
                              productId: product
                                  .productId, // Firestore document ID of the product
                            ),
                          );
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('deleted successfully')));
                    },
                    onEditPressed: () {
                      showDialoge(context, product);
                    },
                  ),
                );
              });
        } else if (state is InventoryErrorState) {
          return Center(
            child: Text(state.errorMessage),
          );
        } else if (state is ProductDeletedState) {
          return const Text('Product deleted successfully');
        }

        return const Center(child: Text('no Product found'));
      }),
    );
  }
}
