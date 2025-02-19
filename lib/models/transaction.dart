// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Transactions {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  Transactions({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
  });

  Transactions copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
  }) {
    return Transactions(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.millisecondsSinceEpoch,
    };
    return map;
  }

  factory Transactions.fromMap(Map<String, dynamic> map) {
    return Transactions(
      id: map['id'] as String,
      title: map['title'] as String,
      amount: map['amount'] as double,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
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
}
