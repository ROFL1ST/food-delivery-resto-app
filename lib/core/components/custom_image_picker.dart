// file: custom_image_picker.dart

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';


import '../assets/assets.dart';
import '../constants/colors.dart';
import 'buttons.dart';
import 'spaces.dart';

class CustomImagePicker extends StatefulWidget {
  final String label;
  final void Function(XFile? imagePath) onChanged;
  final String? imageUrl;
  final XFile? selectedImageFile;
  final bool showLabel;
  final double borderRadius;

  const CustomImagePicker({
    super.key,
    required this.label,
    required this.onChanged,
    this.imageUrl,
    this.selectedImageFile, 
    this.showLabel = true,
    this.borderRadius = 8.0,
  });

  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {

  Future<void> _choosePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? selectedFile = await picker.pickImage(source: ImageSource.gallery);

    if (selectedFile != null) {
      final File originalFile = File(selectedFile.path);
      final img.Image? decodedImage = img.decodeImage(
        originalFile.readAsBytesSync(),
      );

      if (decodedImage != null) {
        final img.Image resizedImage = img.copyResize(decodedImage, width: 800);

        final Directory tempDir = await getTemporaryDirectory();
        final String fileName = 'converted_image_${DateTime.now().millisecondsSinceEpoch}.jpeg';
        final File jpegFile = File('${tempDir.path}/$fileName')
          ..writeAsBytesSync(img.encodeJpg(resizedImage, quality: 85));

      
        widget.onChanged(XFile(jpegFile.path)); 
      }
    }
  }


  void _removeSelectedImage() {
 
    widget.onChanged(null); 
  }

  @override
  Widget build(BuildContext context) {
  
    Widget imageContent;
    bool showRemoveButton = false;

    if (widget.selectedImageFile != null) {
   
      imageContent = Image.file(
        File(widget.selectedImageFile!.path),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.error, size: 50, color: Colors.red),
      );
      showRemoveButton = true;
    } else if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      
      imageContent = CachedNetworkImage(
        imageUrl: widget.imageUrl!,
        height: 65.0,
        width: 65.0,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Assets.images.imagePlaceholder.image(
          height: 65.0,
          width: 65.0,
        ),
      );
      showRemoveButton = false; // Jangan tampilkan tombol hapus untuk gambar dari URL
    } else {
      // Jika tidak ada gambar sama sekali
      imageContent = Assets.images.imagePlaceholder.image(
        height: 65.0,
        width: 65.0,
      );
      showRemoveButton = false;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel) ...[
          Text(
            widget.label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SpaceHeight(12.0),
        ],
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: AppColors.stroke),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Button.filled(
                  onPressed: _choosePhoto,
                  label: 'Choose Photo',
                  width: 140.0,
                  height: 30.0,
                  fontSize: 12.0,
                  borderRadius: 5.0,
                ),
              ),
              const Spacer(),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    margin: const EdgeInsets.all(12.0),
                    width: 65.0,
                    height: 65.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        widget.borderRadius,
                      ),
                      border: Border.all(color: AppColors.stroke),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        widget.borderRadius,
                      ),
                      child: imageContent, // Menggunakan widget yang sudah ditentukan di atas
                    ),
                  ),
                  if (showRemoveButton)
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: _removeSelectedImage,
                      icon: const Icon(Icons.cancel),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}