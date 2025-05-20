import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../models/menu_model.dart';

class FormMenuBottomSheet extends StatefulWidget {
  final MenuModel? item;
  const FormMenuBottomSheet({super.key, this.item});

  @override
  State<FormMenuBottomSheet> createState() => _FormMenuBottomSheetState();
}

class _FormMenuBottomSheetState extends State<FormMenuBottomSheet> {
  late final TextEditingController nameController;
  late final TextEditingController priceController;
  late final TextEditingController stockController;
  late final TextEditingController imageController;

  @override
  void initState() {
    nameController = TextEditingController(text: widget.item?.name);
    priceController =
        TextEditingController(text: widget.item?.price?.toString() ?? '');
    stockController =
        TextEditingController(text: widget.item?.stock?.toString() ?? '');
    imageController = TextEditingController(text: widget.item?.imageUrl);
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
            Text(
              widget.item != null ? 'Edit Menu' : 'Tambah Menu',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Nama Menu
            CustomTextField(
              controller: nameController,
              label: 'Nama Menu',
              prefixIcon: const Icon(Icons.restaurant_menu_outlined),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Harga
            CustomTextField(
              controller: priceController,
              label: 'Harga',
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.attach_money),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Stok
            CustomTextField(
              controller: stockController,
              label: 'Stok',
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.storage_outlined),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Foto Menu
            CustomImagePicker(
              label: 'Foto Menu',
              imageUrl: widget.item?.imageUrl,
              onChanged: (imagePath) {
                imageController.text = imagePath ?? '';
              },
            ),
            const SizedBox(height: 30),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (nameController.text.isEmpty ||
                      priceController.text.isEmpty ||
                      stockController.text.isEmpty ||
                      imageController.text.isEmpty) {
                    context.showDialogError(
                        'Failed', 'Terdapat inputan yang masih kosong');
                  } else {
                    context.pop();
                    if (widget.item != null) {
                      context.showDialogSuccess('Sukses Edit Menu',
                          'Menu kamu dapat dilihat di daftar menu.');
                    } else {
                      context.showDialogSuccess('Sukses Tambah Menu',
                          'Menu kamu berhasil ditambahkan.');
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Simpan',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
