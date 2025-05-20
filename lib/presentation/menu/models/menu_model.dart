import '../../../core/core.dart';

class MenuModel {
  final String imageUrl;
  final String name;
  final int price;
  final int stock;

  MenuModel({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.stock,
  });

  String get priceFormatted => price.currencyFormatRp;
}

final menus = [
  MenuModel(
    imageUrl:
        'https://cdn.pixabay.com/photo/2019/11/21/18/28/gopchang-4643143_640.jpg',
    name: 'Ayam Bakar',
    price: 32000,
    stock: 20,
  ),
  MenuModel(
    imageUrl:
        'https://cdn.idntimes.com/content-images/community/2022/05/img-20220505-090628-6d2cbb4bbec2340f770674be006d2944-242a598410a0b5610ba0c2d3bc499931.jpg',
    name: 'Pecel Ayam',
    price: 25000,
    stock: 20,
  ),
  MenuModel(
    imageUrl:
        'https://cdn.idntimes.com/content-images/community/2022/05/img-20220505-090628-6d2cbb4bbec2340f770674be006d2944-242a598410a0b5610ba0c2d3bc499931.jpg',
    name: 'Sate Kelinci',
    price: 35000,
    stock: 20,
  ),
  MenuModel(
    imageUrl:
        'https://cdn.pixabay.com/photo/2019/11/21/18/28/gopchang-4643143_640.jpg',
    name: 'Ayam Bakar',
    price: 32000,
    stock: 20,
  ),
  MenuModel(
    imageUrl:
        'https://cdn.idntimes.com/content-images/community/2022/05/img-20220505-090628-6d2cbb4bbec2340f770674be006d2944-242a598410a0b5610ba0c2d3bc499931.jpg',
    name: 'Pecel Ayam',
    price: 25000,
    stock: 20,
  ),
  MenuModel(
    imageUrl:
        'https://cdn.idntimes.com/content-images/community/2022/05/img-20220505-090628-6d2cbb4bbec2340f770674be006d2944-242a598410a0b5610ba0c2d3bc499931.jpg',
    name: 'Sate Kelinci',
    price: 35000,
    stock: 20,
  ),
];
