import 'dart:convert';

class ModelAccount {
  final int? id;
  final String? nama;
  final int phone;
  final String email;
  final String password;

  ModelAccount({
    this.id,
    this.nama,
    required this.phone,
    required this.email,
    required this.password,
  });

  factory ModelAccount.empty() {
    return ModelAccount(
      id: null,
      nama: null,
      phone: 0,
      email: '',
      password: '',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nama': nama,
      'phone': phone,
      'email': email,
      'password': password,
    };
  }

  factory ModelAccount.fromMap(Map<String, dynamic> map) {
    return ModelAccount(
      id: map['id'] != null ? map['id'] as int : null,
      nama: map['nama'] != null ? map['nama'] as String : null,
      phone: map['phone'] as int,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ModelAccount.fromJson(String source) =>
      ModelAccount.fromMap(json.decode(source) as Map<String, dynamic>);
}
