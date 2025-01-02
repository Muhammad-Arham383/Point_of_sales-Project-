import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_project/bloc/bloc/inventory_bloc.dart';
import 'package:pos_project/services/firestore_services.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  late TextEditingController _productNameController;
  late TextEditingController _quantityController;
  @override
  void initState() {
    super.initState();
    _productNameController = TextEditingController();
    _quantityController = TextEditingController();
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  final firestoreService = FirestoreService();

  void _onProductNameChanged() {
    final productName = _productNameController.text.trim();
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (productName.isNotEmpty) {
      context.read<InventoryBloc>().add(
            FetchProductByNameEvent(
                productName: productName, uid: uid, price: 0.0),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.lightBlue.shade200,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 41, 121, 255),
          centerTitle: true,
          title: const FittedBox(
            child: Text(
              'Purchase Order',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Align(
            alignment: Alignment.center,
            child: BlocBuilder<InventoryBloc, InventoryState>(
              builder: (context, state) {
                if (state is InventoryLoadingState) {
                  return const CircularProgressIndicator();
                } else if (state is InventoryErrorState) {
                  return Text(
                    'Error: ${state.errorMessage}',
                    style: const TextStyle(color: Colors.red),
                  );
                } else if (state is ProductByNameLoadedState) {
                  return Row(
                    spacing: 15,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          FittedBox(
                            child: Text(
                              'Product: ${state.product.productName}',
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              'Price per Unit: \$${state.product.price}',
                              style: const TextStyle(fontSize: 20),
                            ),
                          )
                        ],
                      )
                    ],
                  );
                } else {
                  return Container(
                    margin: EdgeInsets.only(top: height * 0.06),
                    width: width * 0.9,
                    height: height * 0.7,
                    decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.white,
                              offset: Offset(5, 5),
                              blurRadius: 7),
                          BoxShadow(
                              color: Colors.lightBlue,
                              offset: Offset(-8, -8),
                              blurRadius: 20)
                        ],
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                        color: Color.fromARGB(255, 161, 213, 237)),
                    child: Column(
                      spacing: 10,
                      children: [
                        Container(
                          width: width * 0.7,
                          height: height * 0.06,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              color: Color.fromARGB(255, 41, 121, 255)),
                          child: const FittedBox(
                            child: Text(
                              "Purchase Order",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.6,
                          child: TextFormField(
                            controller: _productNameController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Product Name'),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.6,
                          child: TextFormField(
                            onChanged: (value) {
                              final quantity = int.tryParse(value) ?? 0;

                              context.read<InventoryBloc>().add(
                                    UpdateQuantityEvent(quantity: quantity),
                                  );
                            },
                            keyboardType: TextInputType.number,
                            controller: _quantityController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Quantity'),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _onProductNameChanged,
                          child: const Text('Search Product'),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ));
  }
}
