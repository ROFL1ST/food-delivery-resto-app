import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class ProductRequestModel {
  final String name;
  final String description;
  final int price;
  final int stock;
  final int isFavorite;
  final int isAvailable;
  final XFile image;
  ProductRequestModel({
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.isFavorite,
    required this.isAvailable,
    required this.image,
  });

  ProductRequestModel copyWith({
    String? name,
    String? description,
    int? price,
    int? stock,
    int? isFavorite,
    int? isAvailable,
    XFile? image,
  }) {
    return ProductRequestModel(
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      isFavorite: isFavorite ?? this.isFavorite,
      isAvailable: isAvailable ?? this.isAvailable,
      image: image ?? this.image,
    );
  }

  Map<String, String> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price.toString(),
      'stock': stock.toString(),
      'is_favorite': isFavorite.toString(),
      'is_available': isAvailable.toString(),
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'ProductRequestModel(name: $name, description: $description, price: $price, stock: $stock, isFavorite: $isFavorite, isAvailable: $isAvailable, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductRequestModel &&
        other.name == name &&
        other.description == description &&
        other.price == price &&
        other.stock == stock &&
        other.isFavorite == isFavorite &&
        other.isAvailable == isAvailable &&
        other.image == image;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        description.hashCode ^
        price.hashCode ^
        stock.hashCode ^
        isFavorite.hashCode ^
        isAvailable.hashCode ^
        image.hashCode;
  }
}
