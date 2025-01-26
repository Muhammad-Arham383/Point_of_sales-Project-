import 'package:flutter/material.dart';
import 'package:pos_project/widgets/image_picker_circle_avatar.dart';
// import 'package:pos_project/widgets/image_picker_circle_avatar.dart';

class ListTileContainer extends StatelessWidget {
  const ListTileContainer({
    required this.productName,
    required this.productCategory,
    required this.stockQuantity,
    required this.price,
    required this.onPressed,
    super.key,
  });

  final String productName;
  final String productCategory;
  final double price;
  final int stockQuantity;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: width * 0.2,
        height: height * 0.3,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.white, offset: Offset(5, 5), blurRadius: 7),
            BoxShadow(
                color: Colors.lightBlue,
                offset: Offset(-8, -8),
                blurRadius: 20),
          ],
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: Color.fromARGB(255, 66, 120, 146),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Center(
                child: FittedBox(
                  child: Text(
                    productName,
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade200),
                  ),
                ),
              ),
              Row(
                children: [
                  const ImagePickerCircleAvatar(
                    radius: 45,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FittedBox(
                          child: Text(
                            "Category: $productCategory",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        FittedBox(
                          child: Text(
                            "Stock Quantity: $stockQuantity",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        FittedBox(
                          child: Text(
                            "Price: $price",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        Center(
                          child: IconButton(
                              icon: Icon(Icons.delete), onPressed: onPressed),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
