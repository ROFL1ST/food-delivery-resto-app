import 'dart:convert';

class ProductResponseModel {
  final String? status;
  final String? message;
  final Product? data;

  ProductResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory ProductResponseModel.fromJson(String str) =>
      ProductResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductResponseModel.fromMap(Map<String, dynamic> json) =>
      ProductResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Product.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": data?.toMap(),
      };
}

class Product {
  final String? name;
  final String? description;
  final String? price;
  final String? stock;
  final String? isAvailable;
  final String? isFavorite;
  final int? userId;
  final String? image;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int? id;

  Product({
    this.name,
    this.description,
    this.price,
    this.stock,
    this.isAvailable,
    this.isFavorite,
    this.userId,
    this.image,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        name: json["name"],
        description: json["description"],
        price: json["price"] is int ? json["price"].toString() : json["price"],
        stock: json["stock"] is int ? json["stock"].toString() : json["stock"],
        isAvailable: json["is_available"] is int
            ? json["is_available"].toString()
            : json["is_available"],
        isFavorite: json["is_favorite"] is int
            ? json["is_favorite"].toString()
            : json["is_favorite"],
        userId: json["user_id"],
        image: json["image"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "description": description,
        "price": price,
        "stock": stock,
        "is_available": isAvailable,
        "is_favorite": isFavorite,
        "user_id": userId,
        "image": image,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
      };
}
