import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_resto_app/data/datasources/auth_local_datasources.dart';

import '../../../core/core.dart';
import '../widgets/profile_header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? email;
  String? restaurantName;
  String? phone;
  String? restaurantAddress;
  String? photo;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    // Simulate a network call or data refresh
    final authData = await AuthLocalDatasources().getAuthData();
    if (authData != null) {
      setState(() {
        email = authData.data?.user?.email ?? '';
        restaurantName = authData.data?.user?.restaurantName ?? 'Restaurant';
        phone = authData.data?.user?.phone ?? '';
        restaurantAddress = authData.data?.user?.restaurantAddress ?? '';
        photo = authData.data?.user?.photo ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomRefreshIndicator(
          onRefresh: _fetchData,
          builder: (context, child, controller) {
            return Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 80 * controller.value,
                  child: Opacity(
                    opacity: controller.value.clamp(0.0, 1.0),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ), // Menggunakan warna primary
                          value: controller.isArmed ? null : controller.value,
                        ),
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0.0, controller.value * 80),
                  child: child,
                ),
              ],
            );
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                ProfileHeader(photoUrl: photo,),
                const SpaceHeight(10.0),
                Text(
                  restaurantName ?? 'Restaurant',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  '$email | $phone',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.primary),
                ),
                const SpaceHeight(30.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    color: AppColors.white,
                    child: Column(
                      children: [
                        ListTile(
                          leading: Assets.icons.myAccountCircle.svg(),
                          title: const Text('My Account'),
                          subtitle: const Text('Make changes to your account'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Assets.icons.logoutCircle.svg(),
                          title: const Text('Log out'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Assets.icons.helpAndSupportCircle.svg(),
                          title: const Text('Help & Support'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Assets.icons.aboutAppCircle.svg(),
                          title: const Text('About App'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                const SpaceHeight(30.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
