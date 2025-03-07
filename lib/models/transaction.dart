// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Transactions {
  final String id;
  final String title;
  final double amount;
  final int quantity;
  final DateTime date;
  Transactions(
      {required this.id,
      required this.title,
      required this.amount,
      required this.date,
      required this.quantity});

  Transactions copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    int? quantity,
  }) {
    return Transactions(
        id: id ?? this.id,
        title: title ?? this.title,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        quantity: quantity ?? this.quantity);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.millisecondsSinceEpoch,
      'quantity': quantity
    };
    return map;
  }

  factory Transactions.fromMap(Map<String, dynamic> map) {
    return Transactions(
      id: map['id'] as String,
      title: map['title'] as String,
      amount: map['amount'] as double,
      quantity: map['quantity'] as int,
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Transactions.fromJson(String source) =>
      Transactions.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Transactions(id: $id, title: $title, amount: $amount, date: $date)';
  }

  @override
  bool operator ==(covariant Transactions other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.amount == amount &&
        other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ amount.hashCode ^ date.hashCode;
  }

  static Future<List<Transactions>> fromFirestore(
      QueryDocumentSnapshot<Object?> doc) {
    return Future.value([
      Transactions(
          id: doc.id,
          title: doc['title'] as String,
          amount: doc['amount'] as double,
          date: doc['date'],
          quantity: doc['quantity'] as int),
    ]);
  }
}
