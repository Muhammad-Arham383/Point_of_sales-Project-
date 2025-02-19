import 'package:flutter/material.dart';

class ReceiptScreen extends StatelessWidget {
  final List<Map<String, dynamic>> purchasedProducts;
  
  const ReceiptScreen(
      {super.key,
      required this.purchasedProducts,
      });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
        padding: EdgeInsets.symmetric(
            vertical: width * 0.19, horizontal: height * 0.19),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        child: Column(
          spacing: height * 0.03,
          mainAxisSize: MainAxisSize.min,
          children: [
            const FittedBox(
              child: Text("POS APP",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const Text("1016 6th Ave, New York, NY"),
            const Text("Tel: 650-309-1992"),
            const Divider(),
            Column(
              children: purchasedProducts.map((product) {
                return ListTile(
                  title: Text('${product['productName']}'),
                  trailing: Text("${product['price'].toStringAsFixed(2)}"),
                  subtitle: Text("Qty: ${product['stockQuantity']}"),
                );
              }).toList(),
            ),

            const Divider(),

            const FittedBox(
              child: Text("Thank you for your purchase!",
                  style: TextStyle(fontSize: 16)),
            ),
          ],
        ));
  }
}
