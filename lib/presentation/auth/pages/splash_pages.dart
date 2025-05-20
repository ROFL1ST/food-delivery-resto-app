import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_delivery_resto_app/presentation/auth/pages/login_pages.dart';
import '../../../core/core.dart';
class SplashPages extends StatefulWidget {
  const SplashPages({super.key});

  @override
  State<SplashPages> createState() => _SplashPagesState();
}

class _SplashPagesState extends State<SplashPages> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(milliseconds: 3000),
      () => context.pushReplacement(const LoginPage()),
    );
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Center(
          child: Assets.images.logo.image(),
        ),
      ),
      // bottomNavigationBar: SizedBox(
      //   height: 100.0,
      //   child: Align(
      //     alignment: Alignment.center,
      //     child: Assets.images.logoCwb.image(width: 96.0),
      //   ),
      // ),
    );
  }
}