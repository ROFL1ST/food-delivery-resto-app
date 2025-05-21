import 'dart:convert';

import 'package:food_delivery_resto_app/data/models/response/order_response_modeld.dart'; // Pastikan path ini benar

class OrdersResponseModel {
  final String? status;
  final String? message;
  final List<Order>? data;

  OrdersResponseModel({
    this.status,
    this.message,
    this.data,
  });

  // Factory constructor untuk membuat instance dari String JSON
  factory OrdersResponseModel.fromJson(String str) =>
      OrdersResponseModel.fromMap(json.decode(str));

  // Method untuk mengonversi instance menjadi String JSON
  String toJson() => json.encode(toMap());

  // Factory constructor untuk membuat instance dari Map<String, dynamic>
  factory OrdersResponseModel.fromMap(Map<String, dynamic> json) =>
      OrdersResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Order>.from(json["data"]!.map((x) => Order.fromMap(x))),
      );

  // Method untuk mengonversi instance menjadi Map<String, dynamic>
  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}



