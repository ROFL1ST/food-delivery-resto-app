// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel {
    String message;
    Data data;
    String status;

    LoginResponseModel({
        required this.message,
        required this.data,
        required this.status,
    });

    factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
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
    User user;
    String token;

    Data({
        required this.user,
        required this.token,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: User.fromJson(json["user"]),
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "token": token,
    };
}

class User {
    int id;
    String name;
    String email;
    dynamic emailVerifiedAt;
    DateTime createdAt;
    DateTime updatedAt;
    String phone;
    dynamic address;
    String roles;
    dynamic licensePlate;
    String restaurantName;
    String restaurantAddress;
    String photo;
    String latlong;

    User({
        required this.id,
        required this.name,
        required this.email,
        required this.emailVerifiedAt,
        required this.createdAt,
        required this.updatedAt,
        required this.phone,
        required this.address,
        required this.roles,
        required this.licensePlate,
        required this.restaurantName,
        required this.restaurantAddress,
        required this.photo,
        required this.latlong,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        phone: json["phone"],
        address: json["address"],
        roles: json["roles"],
        licensePlate: json["license_plate"],
        restaurantName: json["restaurant_name"],
        restaurantAddress: json["restaurant_address"],
        photo: json["photo"],
        latlong: json["latlong"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
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
