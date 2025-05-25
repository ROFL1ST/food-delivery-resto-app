import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_resto_app/core/constants/variables.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../core/core.dart';

class ProfileHeader extends StatelessWidget {
  final String? photoUrl;
  const ProfileHeader({super.key, required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(height: height * 0.15),
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.gray4,
          child: CachedNetworkImage(
            imageUrl: '${Variables.baseUrl}/uploads/profile/${photoUrl ?? ''}',
            fit: BoxFit.cover,
            width: width * 0.25,
            height: width * 0.25,
            placeholder:
                (context, url) => Icon(
                  IconsaxPlusBold.user,
                  size: width * 0.08,
                  color: AppColors.gray3, // Menggunakan gray3
                ),
            errorWidget: (context, url, error) {
              log('Error loading image: $error');
              return Icon(
                IconsaxPlusBold.user,
                size: width * 0.08,
                color: AppColors.gray3, // Menggunakan gray3
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 80.0),
          child: IconButton(
            onPressed: () {},
            icon: Assets.icons.editCircle.svg(),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}

class CustomClip extends CustomClipper<Path> {
  const CustomClip();

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height * 0.75,
    );
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClip oldClipper) {
    return false;
  }
}
