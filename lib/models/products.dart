// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Products {
  final String? productId;
  final String productName;
  final String productCategory;
  final int stockQuantity;
  final double price;
  Products({
    this.productId,
    required this.productName,
    required this.productCategory,
    required this.stockQuantity,
    required this.price,
  });

  Products copyWith({
    String? productName,
    String? productCategory,
    int? stockQuantity,
    double? price,
  }) {
    return Products(
      productId: productId,
      productName: productName ?? this.productName,
      productCategory: productCategory ?? this.productCategory,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productName': productName,
      'productCategory': productCategory,
      'stockQuantity': stockQuantity,
      'price': price,
    };
  }

  factory Products.fromMap(Map<String, dynamic> map) {
    return Products(
      productId: map['productId'] as String,
      productName: map['productName'] as String,
      productCategory: map['productCategory'] as String,
      stockQuantity: map['stockQuantity'] as int,
      price: map['price'] as double,
    );
  }

  factory Products.fromFirestore(DocumentSnapshot docs) {
    final data = docs.data as Map<String, dynamic>;
    return Products(
        productId: docs.id,
        productName: data['productName'],
        productCategory: data["productCategory"],
        stockQuantity: data['stockQuantity'],
        price: data["price"]);
  }
  String toJson() => json.encode(toMap());

  factory Products.fromJson(String source) =>
      Products.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Products(productName: $productName, productCategory: $productCategory, stockQuantity: $stockQuantity, price: $price)';
  }

  @override
  bool operator ==(covariant Products other) {
    if (identical(this, other)) return true;

    return other.productName == productName &&
        other.productCategory == productCategory &&
        other.stockQuantity == stockQuantity &&
        other.price == price;
  }

  @override
  int get hashCode {
    return productName.hashCode ^
        productCategory.hashCode ^
        stockQuantity.hashCode ^
        price.hashCode;
  }
}
