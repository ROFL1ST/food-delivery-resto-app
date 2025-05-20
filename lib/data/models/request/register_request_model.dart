// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class RegisterRequestModel {
  String name;
  String email;
  String password;
  String phone;
  String restaurantName;
  String restaurantAddress;
  String latlong;
  XFile? photo;
  RegisterRequestModel({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.restaurantName,
    required this.restaurantAddress,
    required this.latlong,
    this.photo,
  });

  RegisterRequestModel copyWith({
    String? name,
    String? email,
    String? password,
    String? phone,
    String? restaurantName,
    String? restaurantAddress,
    String? latlong,
    XFile? photo,
  }) {
    return RegisterRequestModel(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantAddress: restaurantAddress ?? this.restaurantAddress,
      latlong: latlong ?? this.latlong,
      photo: photo ?? this.photo,
    );
  }

  Map<String, String> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'restaurant_name': restaurantName,
      'restaurant_address': restaurantAddress,
      'latlong': latlong,
    };
  }

  factory RegisterRequestModel.fromMap(Map<String, dynamic> map) {
    return RegisterRequestModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      phone: map['phone'] ?? '',
      restaurantName: map['restaurantName'] ?? '',
      restaurantAddress: map['restaurantAddress'] ?? '',
      latlong: map['latlong'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RegisterRequestModel.fromJson(String source) =>
      RegisterRequestModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RegisterRequestModel(name: $name, email: $email, password: $password, phone: $phone, restaurantName: $restaurantName, restaurantAddress: $restaurantAddress, latlong: $latlong, photo: $photo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RegisterRequestModel &&
        other.name == name &&
        other.email == email &&
        other.password == password &&
        other.phone == phone &&
        other.restaurantName == restaurantName &&
        other.restaurantAddress == restaurantAddress &&
        other.latlong == latlong &&
        other.photo == photo;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        password.hashCode ^
        phone.hashCode ^
        restaurantName.hashCode ^
        restaurantAddress.hashCode ^
        latlong.hashCode ^
        photo.hashCode;
  }
}
