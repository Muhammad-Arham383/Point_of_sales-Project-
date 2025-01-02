// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Sales {
  final String id;
  final String productName;
  final String productQuantity;
  final String productPrice;
  Sales({
    required this.id,
    required this.productName,
    required this.productQuantity,
    required this.productPrice,
  });

  Sales copyWith({
    String? id,
    String? productName,
    String? productQuantity,
    String? productPrice,
  }) {
    return Sales(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      productQuantity: productQuantity ?? this.productQuantity,
      productPrice: productPrice ?? this.productPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'productName': productName,
      'productQuantity': productQuantity,
      'productPrice': productPrice,
    };
  }

  factory Sales.fromMap(Map<String, dynamic> map) {
    return Sales(
      id: map['id'] as String,
      productName: map['productName'] as String,
      productQuantity: map['productQuantity'] as String,
      productPrice: map['productPrice'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Sales.fromJson(String source) =>
      Sales.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Sales(id: $id, productName: $productName, productQuantity: $productQuantity, productPrice: $productPrice)';
  }

  @override
  bool operator ==(covariant Sales other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.productName == productName &&
        other.productQuantity == productQuantity &&
        other.productPrice == productPrice;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        productName.hashCode ^
        productQuantity.hashCode ^
        productPrice.hashCode;
  }
}
