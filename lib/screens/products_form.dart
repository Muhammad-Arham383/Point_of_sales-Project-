import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_project/bloc/bloc/inventory_bloc.dart';
import 'package:pos_project/models/products.dart';
import 'package:pos_project/widgets/buttons.dart';

class InventoryManagement extends StatefulWidget {
  const InventoryManagement({super.key});

  @override
  State<InventoryManagement> createState() => _InventoryManagementState();
}

class _InventoryManagementState extends State<InventoryManagement> {
  late TextEditingController _productName;
  late TextEditingController _category;
  late TextEditingController _stock;
  late TextEditingController _price;
  @override
  void initState() {
    super.initState();
    _productName = TextEditingController();
    _category = TextEditingController();
    _stock = TextEditingController();
    _price = TextEditingController();
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
    void fetchProducts() {
      if (_productName.text.isNotEmpty &&
          _category.text.isNotEmpty &&
          _stock.text.isNotEmpty &&
          _price.text.isNotEmpty) {
        String userId = FirebaseAuth.instance.currentUser!.uid;

        // Create a new product instance
        Products product = Products(
          productName: _productName.text,
          productCategory: _category.text,
          stockQuantity: int.parse(_stock.text),
          price: double.parse(_price.text),
        );
        context.read<InventoryBloc>().add(
              AddProductEvent(products: product, userId: userId),
            );
      } else {
        // ignore: avoid_print
        print("One or more fields are empty!");
      }
      Navigator.pop(context);
    }

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
            backgroundColor: const Color.fromARGB(255, 41, 121, 255),
            title: const Text('Add Product',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),
            centerTitle: true,
            shape: const RoundedRectangleBorder(
              side: BorderSide(
                  color: Colors.blue,
                  strokeAlign: BorderSide.strokeAlignInside,
                  width: 10),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50)),
            )),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: height * 0.02, horizontal: width * 0.08),
                child: TextFormField(
                  controller: _productName,
                  decoration: const InputDecoration(
                      labelText: 'Product Name', border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: height * 0.02, horizontal: width * 0.08),
                child: TextFormField(
                  controller: _category,
                  decoration: const InputDecoration(
                      labelText: 'Category', border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: height * 0.02, horizontal: width * 0.08),
                child: TextFormField(
                  controller: _stock,
                  decoration: const InputDecoration(
                      labelText: 'Stock', border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: height * 0.02, horizontal: width * 0.08),
                child: TextFormField(
                  controller: _price,
                  decoration: const InputDecoration(
                      labelText: 'Purchase Price',
                      border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.1, vertical: height * 0.06),
                child: SizedBox(
                  width: width * 0.9,
                  height: height * 0.05,
                  child: CustomButtons(
                    color: const Color.fromARGB(255, 41, 121, 255),
                    text: Text('Save and Publish',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.06)),
                    onPressed: fetchProducts,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
