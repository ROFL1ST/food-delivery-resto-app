import 'dart:convert';

import 'package:food_delivery_resto_app/data/models/response/product_response_modeld.dart';



class ProductsResponseModel {
  final String? status;
  final String? message;
  final List<Product>? data;

  ProductsResponseModel({
    this.status,
    this.message,
    this.data,
  });

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
      'data': data?.map((x) => x.toMap()).toList(),
    };
  }

  factory ProductsResponseModel.fromMap(Map<String, dynamic> map) {
    return ProductsResponseModel(
      status: map['status'],
      message: map['message'],
      data: map['data'] != null
          ? List<Product>.from(map['data']?.map((x) => Product.fromMap(x)))
          : null,
    );
  }

  factory ProductsResponseModel.fromJson(String source) =>
      ProductsResponseModel.fromMap(json.decode(source));
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final dynamic emailVerifiedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? phone;
  final dynamic address;
  final String? roles;
  final dynamic licensePlate;
  final String? restaurantName;
  final String? restaurantAddress;
  final String? photo;
  final String? latlong;

  User({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.phone,
    this.address,
    this.roles,
    this.licensePlate,
    this.restaurantName,
    this.restaurantAddress,
    this.photo,
    this.latlong,
  });

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        phone: json["phone"],
        address: json["address"],
        roles: json["roles"],
        licensePlate: json["license_plate"],
        restaurantName: json["restaurant_name"],
        restaurantAddress: json["restaurant_address"],
        photo: json["photo"],
        latlong: json["latlong"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "phone": phone,
        "address": address,
        "roles": roles,
        "license_plate": licensePlate,
        "restaurant_name": restaurantName,
        "restaurant_address": restaurantAddress,
        "photo": photo,
        "latlong": latlong,
      };
}
