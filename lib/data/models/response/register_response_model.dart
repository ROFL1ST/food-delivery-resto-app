// To parse this JSON data, do
//
//     final registerResponseModel = registerResponseModelFromJson(jsonString);

import 'dart:convert';

RegisterResponseModel registerResponseModelFromJson(String str) => RegisterResponseModel.fromJson(json.decode(str));

String registerResponseModelToJson(RegisterResponseModel data) => json.encode(data.toJson());

class RegisterResponseModel {
    String message;
    Data data;
    String status;

    RegisterResponseModel({
        required this.message,
        required this.data,
        required this.status,
    });

    factory RegisterResponseModel.fromJson(Map<String, dynamic> json) => RegisterResponseModel(
        message: json["message"],
        data: Data.fromJson(json["data"]),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
        "status": status,
    };
}

class Data {
    String name;
    String email;
    String phone;
    String restaurantName;
    String restaurantAddress;
    String latlong;
    String photo;
    String roles;
    DateTime updatedAt;
    DateTime createdAt;
    int id;

    Data({
        required this.name,
        required this.email,
        required this.phone,
        required this.restaurantName,
        required this.restaurantAddress,
        required this.latlong,
        required this.photo,
        required this.roles,
        required this.updatedAt,
        required this.createdAt,
        required this.id,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        restaurantName: json["restaurant_name"],
        restaurantAddress: json["restaurant_address"],
        latlong: json["latlong"],
        photo: json["photo"],
        roles: json["roles"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phone": phone,
        "restaurant_name": restaurantName,
        "restaurant_address": restaurantAddress,
        "latlong": latlong,
        "photo": photo,
        "roles": roles,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
    };
}
