import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:food_delivery_resto_app/core/constants/colors.dart';
import 'package:food_delivery_resto_app/core/core.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18.0, vertical: 30.0),
                margin: const EdgeInsets.only(top: 50.0),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(28.0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SpaceHeight(28.0),
                    CustomTextField(
                      controller: emailController,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(
                        Icons.email,
                        color: AppColors.primary,
                      ),
                    ),
                    const SpaceHeight(14.0),
                    CustomTextField(
                      controller: phoneController,
                      label: 'Handphone',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(
                        Icons.phone,
                        color: AppColors.primary,
                      ),
                    ),
                    const SpaceHeight(14.0),
                    CustomTextField(
                      controller: nameController,
                      label: 'Name',
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(
                        Icons.person,
                        color: AppColors.primary,
                      ),
                    ),
                    const SpaceHeight(18.0),
                    CustomTextField(
                      controller: passwordController,
                      label: 'Password',
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(
                        Icons.key,
                        color: AppColors.primary,
                      ),
                    ),
                    const SpaceHeight(18.0),
                    CustomTextField(
                      controller: confirmPasswordController,
                      label: 'Confirm Password',
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      prefixIcon: const Icon(
                        Icons.key,
                        color: AppColors.primary,
                      ),
                    ),
                    const SpaceHeight(33.0),
                    Button.filled(
                      onPressed: () => context.pop(),
                      label: 'Sign Up',
                    ),
                    const SpaceHeight(16.0),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          text: 'Sudah memiliki akun? ',
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: AppColors.gray3,
                          ),
                          children: [
                            TextSpan(
                              text: 'Login',
                              style: const TextStyle(
                                color: AppColors.primary,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => context.pop(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ClipOval(
                  child: ColoredBox(
                    color: AppColors.gray5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Assets.images.logo.image(
                        height: 100.0,
                        width: 100.0,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
