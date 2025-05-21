import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_resto_app/presentation/menu/bloc/get_product/get_product_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/core.dart';
import '../models/menu_model.dart';
import '../widgets/form_menu_bottom_sheet.dart';
import '../widgets/menu_card.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<GetProductBloc>().add(GetProductEvent.getProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar
          SliverAppBar(
            backgroundColor: Colors.white,
            floating: true,
            pinned: true,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'Menu',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (context) => const FormMenuBottomSheet(),
                  );
                },
                icon: const Icon(Icons.add, color: Colors.black),
              ),
            ],
          ),

          // Sliver untuk konten
          BlocBuilder<GetProductBloc, GetProductState>(
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () {
                  return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
                loading: _buildLoadingSkeleton,
                error: (message) {
                  return SliverToBoxAdapter(
                    child: Center(child: Text("Terjadi Kesalahan")),
                  );
                },
                loaded: (menus) {
                  if (menus.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody:
                          false, // Menghindari scroll ketika konten kosong
                      child: Center(
                        child: Text(
                          'No Menu Available',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 3 / 4,
                            ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => MenuCard(item: menus[index]),
                          childCount: menus.length,
                        ),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget _buildLoadingSkeleton() {
  return SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    sliver: SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 3 / 4,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => _menuSkeleton(),
        childCount: 6, // Jumlah dummy skeleton
      ),
    ),
  );
}

Widget _menuSkeleton() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 8,
          spreadRadius: 2,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gambar skeleton
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama skeleton
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(height: 16, width: 100, color: Colors.white),
              ),
              const SizedBox(height: 6),
              // Harga skeleton
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(height: 14, width: 80, color: Colors.white),
              ),
              const SizedBox(height: 8),
              // Stok skeleton
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(height: 12, width: 60, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
