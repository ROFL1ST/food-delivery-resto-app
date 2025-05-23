import 'dart:convert';

class OrderResponseModel {
  final String? status;
  final String? message;
  final Order? data;

  OrderResponseModel({this.status, this.message, this.data});

  factory OrderResponseModel.fromJson(String str) =>
      OrderResponseModel.fromMap(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toMap());

  factory OrderResponseModel.fromMap(Map<String, dynamic> json) =>
      OrderResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Order.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "data": data?.toMap(),
  };
}

class Order {
  final int? id;
  final int? userId;
  final String? restaurantName;
  final String? userName;
  final String? driverName;
  final int? restaurantId;
  final dynamic driverId;
  final int? totalPrice;
  final int? shippingCost;
  final int? totalBill;
  final dynamic paymentMethod;
  final String? status;
  final dynamic shippingAddress;
  final String? shippingLatlong;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<OrderItem>? orderItems;

  Order({
    this.id,
    this.userId,
    this.restaurantId,
    this.restaurantName,
    this.userName,
    this.driverName,
    this.driverId,
    this.totalPrice,
    this.shippingCost,
    this.totalBill,
    this.paymentMethod,
    this.status,
    this.shippingAddress,
    this.shippingLatlong,
    this.createdAt,
    this.updatedAt,
    this.orderItems,
  });

  factory Order.fromJson(String str) => Order.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Order.fromMap(Map<String, dynamic> json) => Order(
    id: json["id"],
    userId: json["user_id"],
    restaurantId: json["restaurant_id"],
    restaurantName: json["restaurant_name"],
    userName: json["user_name"],
    driverName: json["driver_name"],
    driverId: json["driver_id"],
    totalPrice: json["total_price"],
    shippingCost: json["shipping_cost"],
    totalBill: json["total_bill"],
    paymentMethod: json["payment_method"],
    status: json["status"],
    shippingAddress: json["shipping_address"],
    shippingLatlong: json["shipping_latlong"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    orderItems:
        json["order_items"] == null
            ? []
            : List<OrderItem>.from(
              json["order_items"]!.map((x) => OrderItem.fromJson(x)),
            ),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "user_id": userId,
    "restaurant_id": restaurantId,
    "driver_id": driverId,
    "restaurant_name": restaurantName,
    "user_name": userName,
    "driver_name": driverName,
    "total_price": totalPrice,
    "shipping_cost": shippingCost,
    "total_bill": totalBill,
    "payment_method": paymentMethod,
    "status": status,
    "shipping_address": shippingAddress,
    "shipping_latlong": shippingLatlong,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "order_items":
        orderItems == null
            ? []
            : List<dynamic>.from(orderItems!.map((x) => x.toJson())),
  };
}

class OrderItem {
  final int? id;
  final int? orderId;
  final int? productId;
  final int? quantity;
  final int? price;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Product? product;

  OrderItem({
    this.id,
    this.orderId,
    this.productId,
    this.quantity,
    this.price,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  factory OrderItem.fromRawJson(String str) =>
      OrderItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    id: json["id"],
    orderId: json["order_id"],
    productId: json["product_id"],
    quantity: json["quantity"],
    price: json["price"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    product: json["product"] == null ? null : Product.fromJson(json["product"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "product_id": productId,
    "quantity": quantity,
    "price": price,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "product": product?.toJson(),
  };
}

class Product {
  final int? id;
  final String? name;
  final String? description;
  final int? price;
  final int? stock;
  final int? isAvailable;
  final int? isFavorite;
  final String? image;
  final int? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    this.id,
    this.name,
    this.description,
    this.price,
    this.stock,
    this.isAvailable,
    this.isFavorite,
    this.image,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    price: json["price"],
    stock: json["stock"],
    isAvailable: json["is_available"],
    isFavorite: json["is_favorite"],
    image: json["image"],
    userId: json["user_id"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "price": price,
    "stock": stock,
    "is_available": isAvailable,
    "is_favorite": isFavorite,
    "image": image,
    "user_id": userId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
