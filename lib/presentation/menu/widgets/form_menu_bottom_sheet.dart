import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_resto_app/data/models/request/product_request_model.dart';
import 'package:food_delivery_resto_app/presentation/menu/bloc/add_product/add_product_bloc.dart';
import 'package:food_delivery_resto_app/presentation/menu/bloc/get_product/get_product_bloc.dart';
import 'package:food_delivery_resto_app/presentation/menu/widgets/custom_switch.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/core.dart';
import '../models/menu_model.dart';

class FormMenuBottomSheet extends StatefulWidget {
  const FormMenuBottomSheet({super.key});

  @override
  State<FormMenuBottomSheet> createState() => _FormMenuBottomSheetState();
}

class _FormMenuBottomSheetState extends State<FormMenuBottomSheet> {
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late final TextEditingController priceController;
  late final TextEditingController stockController;
  late final TextEditingController imageController;

  bool isFavorite = false;
  bool isAvailable = true;

  XFile? image;

  @override
  void initState() {
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    priceController = TextEditingController();
    stockController = TextEditingController();
    imageController = TextEditingController();
    // nameController = TextEditingController(text: widget.item?.name);
    // priceController =
    //     TextEditingController(text: widget.item?.price?.toString() ?? '');
    // stockController =
    //     TextEditingController(text: widget.item?.stock?.toString() ?? '');
    // imageController = TextEditingController(text: widget.item?.imageUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 18.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Text(
            //   widget.item != null ? 'Edit Menu' : 'Tambah Menu',
            //   style: Theme.of(context).textTheme.titleLarge?.copyWith(
            //         fontWeight: FontWeight.bold,
            //       ),
            // ),
            const SizedBox(height: 16),

            // Nama Menu
            CustomTextField(
              controller: nameController,
              label: 'Nama Menu',
              prefixIcon: const Icon(Icons.restaurant_menu_outlined),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // deskripsi
            CustomTextField(
              controller: descriptionController,
              label: 'Deskripsi Menu',
              prefixIcon: const Icon(IconsaxPlusBold.document_text),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            // Harga
            CustomTextField(
              controller: priceController,
              label: 'Harga',
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(IconsaxPlusBold.dollar_circle),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Stok
            CustomTextField(
              controller: stockController,
              label: 'Stok',
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(IconsaxPlusBold.box),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Foto Menu
            CustomImagePicker(
              label: 'Foto Menu',
              // imageUrl: widget.item?.imageUrl,
              onChanged: (imagePath) {
                image = imagePath;
              },
            ),
            const SizedBox(height: 16),
            // Tersedia
            CustomSwitch(
              label: 'Tersedia',
              value: isAvailable,
              onChanged: (value) {
                setState(() {
                  isAvailable = value;
                });
              },
            ),
            const SizedBox(height: 16),
            // Favorit
            CustomSwitch(
              label: 'Favorit',
              value: isFavorite,
              onChanged: (value) {
                setState(() {
                  isFavorite = value;
                });
              },
            ),
            const SizedBox(height: 30),

            // Tombol Simpan
            BlocConsumer<AddProductBloc, AddProductState>(
              listener: (context, state) {
                state.maybeWhen(
                  orElse: () {},
                  success: () {
                    Navigator.pop(context);

                    context.showDialogSuccess(
                      'Berhasil',
                      'Menu berhasil ditambahkan',
                    );
                    Navigator.pop(context);
                    context.read<GetProductBloc>().add(
                      const GetProductEvent.getProducts(),
                    );
                  },
                  error: (message) {
                    context.showDialogError('Gagal', message);
                  },
                );
              },
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (nameController.text.isEmpty ||
                              priceController.text.isEmpty ||
                              stockController.text.isEmpty) {
                            context.showDialogError(
                              'Failed',
                              'Terdapat inputan yang masih kosong',
                            );
                          } else {
                            final data = ProductRequestModel(
                              name: nameController.text,
                              description: descriptionController.text,
                              price: priceController.text.toInt,
                              stock: stockController.text.toInt,
                              isFavorite: isFavorite ? 1 : 0,
                              isAvailable: isAvailable ? 1 : 0,
                              image: image!,
                            );
                            context.read<AddProductBloc>().add(
                              AddProductEvent.addProduct(data: data),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Simpan',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },

                  loading: () {
                    return const Center(child: CircularProgressIndicator());
                  },
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
