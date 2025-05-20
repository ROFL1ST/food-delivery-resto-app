import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_resto_app/core/constants/colors.dart';
import 'package:food_delivery_resto_app/core/core.dart';
import 'package:food_delivery_resto_app/presentation/auth/pages/register_pages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          SizedBox(
            height: height * 0.5,
            child: Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Center(child: Assets.images.logo.image()),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28.0),
                ),
                child: ColoredBox(
                  color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18.0,
                      vertical: 30.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SpaceHeight(8.0),
                        const Text(
                          'Masukkan Kredensial akun untuk melanjutkan  masuk dalam aplikasi',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppColors.gray3,
                          ),
                        ),
                        const SpaceHeight(14.0),
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
                        const SpaceHeight(18.0),
                        CustomTextField(
                          controller: passwordController,
                          label: 'Password',
                          obscureText: true,
                          prefixIcon: const Icon(
                            Icons.key,
                            color: AppColors.primary,
                          ),
                        ),
                        const SpaceHeight(33.0),
                        Button.filled(onPressed: () {}, label: 'Sign In'),

                        const SpaceHeight(16.0),
                        Center(
                          child: Text.rich(
                            TextSpan(
                              text: 'Belum memiliki akun? ',
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: AppColors.gray3,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Daftar',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                  ),
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () {
                                          context.push(const RegisterPage());
                                        },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
