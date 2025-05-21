import 'package:flutter/material.dart';
import 'package:food_delivery_resto_app/core/constants/colors.dart';
import 'package:food_delivery_resto_app/presentation/menu/pages/menu_page.dart';
import 'package:food_delivery_resto_app/presentation/menu/pages/order_page.dart';
import 'package:food_delivery_resto_app/presentation/menu/pages/profile_page.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final _widgets = [
    const Text('Home Page'), // Placeholder for Home Page
    const MenuPage(),
    const OrderPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _widgets),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
        decoration: BoxDecoration(border: Border.all(color: AppColors.stroke)),
        child: Theme(
          data: ThemeData(
            splashColor: Colors.white,
            highlightColor: Colors.white,
          ),
          child: SalomonBottomBar(
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            items: [
              /// Home
              SalomonBottomBarItem(
                icon: const Icon(IconsaxPlusBold.home_2),
                title: const Text("Home"),
                selectedColor: AppColors.primary,
                unselectedColor: AppColors.gray2
              ),
          
              /// Menu
              SalomonBottomBarItem(
                icon: const Icon(IconsaxPlusBold.menu_1),
                title: const Text("Menu"),
                selectedColor: AppColors.primary,
                unselectedColor: AppColors.gray2
              ),
          
              /// Orders
              SalomonBottomBarItem(
                icon: const Icon(IconsaxPlusBold.shopping_cart),
                title: const Text("Orders"),
                selectedColor: AppColors.primary,
                unselectedColor: AppColors.gray2
              ),
          
              /// Profile
              SalomonBottomBarItem(
                icon: const Icon(IconsaxPlusBold.profile),
                title: const Text("Profile"),
                selectedColor: AppColors.primary,
                unselectedColor: AppColors.gray2
              ),
            ],
          ),
        ),
      ),
    );
  }
}
