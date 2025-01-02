// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Users {
  String name;
  String email;
  String password;
  Users({
    required this.name,
    required this.email,
    required this.password,
  });

  Users copyWith({
    String? name,
    String? email,
    String? password,
  }) {
    return Users(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Users.fromJson(String source) =>
      Users.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Users(name: $name, email: $email, password: $password)';

  @override
  bool operator ==(covariant Users other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode => name.hashCode ^ email.hashCode ^ password.hashCode;
}
