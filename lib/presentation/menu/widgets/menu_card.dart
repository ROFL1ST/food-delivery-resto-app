import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_resto_app/core/constants/colors.dart';
import 'package:food_delivery_resto_app/core/constants/variables.dart';
import 'package:food_delivery_resto_app/core/core.dart';
import 'package:food_delivery_resto_app/data/models/response/product_response_modeld.dart';
import 'package:food_delivery_resto_app/presentation/menu/bloc/delete_product/delete_product_bloc.dart';
import 'package:food_delivery_resto_app/presentation/menu/bloc/get_product/get_product_bloc.dart';
import 'package:food_delivery_resto_app/presentation/menu/widgets/form_edit_menu_bottom_sheet.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../models/menu_model.dart';
import 'form_menu_bottom_sheet.dart';

class MenuCard extends StatelessWidget {
  final Product item;
  const MenuCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    Timer? timer;
    print('${Variables.baseUrl}/uploads/products/${item.image}');
    return GestureDetector(
      onTap: () {
        // Aksi ketika kartu ditekan
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar menu
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                imageUrl: '${Variables.baseUrl}/uploads/products/${item.image}',
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Container(
                      height: 120,
                      color: AppColors.gray1,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                errorWidget: (context, url, error) {
                  print('Error loading image: $error');
                  return Container(
                    height: 120,
                    color: AppColors.gray1,
                    child: const Icon(
                      Icons.broken_image,
                      color: AppColors.gray2,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama menu
                  Text(
                    item.name ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Harga menu
                  Text(
                    item.price!.toInt.currencyFormatRp,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Informasi stok dan aksi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Stok
                      Text(
                        'Stok: ${item.stock}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.gray2,
                        ),
                      ),
                      // Tombol aksi
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              IconsaxPlusBold.edit,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder:
                                    (context) =>
                                        FormEditMenuBottomSheet(item: item),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              IconsaxPlusBold.trash,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: const Text('Hapus Menu'),
                                      content: Text(
                                        'Apakah Anda yakin ingin menghapus menu "${item.name}"?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.pop(context),
                                          child: const Text('Batal'),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.redAccent,
                                          ),
                                          onPressed: () {
                                            context.read<DeleteProductBloc>().add(
                                              DeleteProductEvent.deleteProduct(
                                                id: item.id!,
                                              ),
                                            );
                                            context.pop();
                                            context.read<GetProductBloc>().add(
                                              const GetProductEvent.getProducts(),
                                            );
                                            context.showDialogSuccess(
                                              'Berhasil',
                                              'Menu berhasil dihapus',
                                            );

                                            // Logika hapus menu
                                          },
                                          child: const Text(
                                            'Hapus',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
