import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';
import 'index.dart';



@immutable
class DoctorsData {

  const DoctorsData({
    required this.id,
    required this.fullName,
    required this.nmc,
    required this.email,
    required this.password,
  });

  final int id;
  final String fullName;
  final String nmc;
  final String email;
  final String password;

  factory DoctorsData.fromJson(Map<String,dynamic> json) => DoctorsData(
    id: json['id'] as int,
    fullName: json['full_name'].toString(),
    nmc: json['nmc'].toString(),
    email: json['email'].toString(),
    password: json['password'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': fullName,
    'nmc': nmc,
    'email': email,
    'password': password
  };

  DoctorsData clone() => DoctorsData(
    id: id,
    fullName: fullName,
    nmc: nmc,
    email: email,
    password: password
  );


  DoctorsData copyWith({
    int? id,
    String? fullName,
    String? nmc,
    String? email,
    String? password
  }) => DoctorsData(
    id: id ?? this.id,
    fullName: fullName ?? this.fullName,
    nmc: nmc ?? this.nmc,
    email: email ?? this.email,
    password: password ?? this.password,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is DoctorsData && id == other.id && fullName == other.fullName && nmc == other.nmc && email == other.email && password == other.password;

  @override
  int get hashCode => id.hashCode ^ fullName.hashCode ^ nmc.hashCode ^ email.hashCode ^ password.hashCode;
}
