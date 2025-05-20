import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:food_delivery_resto_app/core/constants/colors.dart';
import 'package:food_delivery_resto_app/core/core.dart';
import 'package:food_delivery_resto_app/data/models/request/register_request_model.dart';
import 'package:food_delivery_resto_app/presentation/auth/bloc/register/register_bloc.dart';
import 'package:food_delivery_resto_app/presentation/auth/pages/login_pages.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final restaurantNameController = TextEditingController();
  final restaurantAddressController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final imagePicker = ImagePicker();
  XFile? image;
  double? latitude;
  double? longitude;
  String? restaurantAddress;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentPosition();
  }

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    nameController.dispose();
    restaurantNameController.dispose();
    restaurantAddressController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        image = pickedFile;
      });
    }
  }

  Future<void> getCurrentPosition() async {
    try {
      Location location = Location();

      bool serviceEnabled;
      PermissionStatus permissionGranted;
      LocationData locationData;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      locationData = await location.getLocation();
      latitude = locationData.latitude;
      longitude = locationData.longitude;

      if (latitude != null && longitude != null) {
        await getAddressFromLatLng(latitude!, longitude!);
      }

      setState(() {});
    } on PlatformException catch (e) {
      if (e.code == 'IO_ERROR') {
        debugPrint(
          'A network error occurred trying to lookup the supplied coordinates: ${e.message}',
        );
      } else {
        debugPrint('Failed to lookup coordinates: ${e.message}');
      }
    } catch (e) {
      debugPrint('An unknown error occurred: $e');
    }
  }

  Future<void> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        lat,
        lng,
      );
      geo.Placemark place = placemarks[0];
      restaurantAddress =
          "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
    } catch (e) {
      debugPrint('Failed to get address: $e');
    }
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
                  horizontal: 18.0,
                  vertical: 30.0,
                ),
                margin: const EdgeInsets.only(top: 50.0),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28.0),
                  ),
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
                    const SpaceHeight(14.0),
                    CustomTextField(
                      controller: restaurantNameController,
                      label: 'Restaurant Name',
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(
                        Icons.restaurant,
                        color: AppColors.primary,
                      ),
                    ),
                    // const SpaceHeight(14.0),
                    // CustomTextField(
                    //   controller: restaurantAddressController,
                    //   label: 'Restaurant Address',
                    //   textInputAction: TextInputAction.next,
                    //   prefixIcon: const Icon(
                    //     Icons.person,
                    //     color: AppColors.primary,
                    //   ),
                    // ),
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
                    // const SpaceHeight(18.0),
                    // CustomTextField(
                    //   controller: confirmPasswordController,
                    //   label: 'Confirm Password',
                    //   obscureText: true,
                    //   textInputAction: TextInputAction.done,
                    //   prefixIcon: const Icon(
                    //     Icons.key,
                    //     color: AppColors.primary,
                    //   ),
                    // ),
                    const SpaceHeight(33.0),
                    BlocListener<RegisterBloc, RegisterState>(
                      listener: (context, state) {
                        // TODO: implement listener
                        state.maybeWhen(
                          orElse: () {},
                          registerSuccess: (data) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Register Success, please login'),
                              ),
                            );

                            context.pushReplacement(const LoginPage());
                          },
                          error: (message) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Register Failed: $message"),
                                backgroundColor: AppColors.red,
                              ),
                            );
                          },
                        );
                      },
                      child: BlocBuilder<RegisterBloc, RegisterState>(
                        builder: (context, state) {
                          return state.maybeWhen(
                            orElse: () {
                              return Button.filled(
                                onPressed: () {
                                  final RegisterRequestModel
                                  request = RegisterRequestModel(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    phone: phoneController.text,
                                    restaurantName:
                                        restaurantNameController.text,
                                    restaurantAddress: restaurantAddress ?? '-',
                                    latlong:
                                        '${latitude ?? 0},${longitude ?? 0}',
                                    photo: image,
                                  );
                                  context.read<RegisterBloc>().add(
                                    RegisterEvent.register(
                                      requestModel: request,
                                    ),
                                  );
                                },
                                label: 'Sign Up',
                              );
                            },
                            loading: () {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          );
                        },
                      ),
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
                              style: const TextStyle(color: AppColors.primary),
                              recognizer:
                                  TapGestureRecognizer()
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
                child: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      pickImage();
                    },
                    child: ClipOval(
                      child: ColoredBox(
                        color: AppColors.gray5,
                        child:
                            image != null
                                ? Image.file(
                                  File(image!.path),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                                : Padding(
                                  padding: const EdgeInsets.all(35.0),
                                  child: Icon(
                                    Icons.camera_enhance_rounded,
                                    size: 25,
                                  ),
                                ),
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
