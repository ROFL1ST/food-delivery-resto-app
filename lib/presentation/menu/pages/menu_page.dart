import 'dart:developer';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
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
  final _controller = IndicatorController(refreshEnabled: true);

  @override
  void initState() {
    super.initState();
    context.read<GetProductBloc>().add(GetProductEvent.getProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        
        title: const Text(
          "Menu",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => const FormMenuBottomSheet(),
              );
            },
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            ), 
          ),
        ],
      ),

      body: Stack(
        children: [
          // Background layer

          // Refresh indicator and content
          CustomRefreshIndicator(
            controller: _controller,
            trigger: IndicatorTrigger.leadingEdge,
            onRefresh: () async {
              log('Refresh triggered');
              context.read<GetProductBloc>().add(GetProductEvent.getProducts());
            },
            builder: (context, child, controller) {
              final double progressValue = controller.value.clamp(0.0, 1.0);
              return Stack(
                children: <Widget>[
                  // Indikator refresh
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 80, // Tinggi area indikator
                    child: Opacity(
                      opacity: controller.value.clamp(
                        0.0,
                        1.0,
                      ), // Opacity berdasarkan seberapa jauh ditarik
                      child: Center(
                        child: Transform.scale(
                          scale: controller.value.clamp(
                            0.0,
                            1.0,
                          ), // Skala berdasarkan seberapa jauh ditarik
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5, // Ketebalan garis
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.gray4,
                            ),
                            // Kunci utamanya di sini:
                            // Jika controller.isArmed (siap untuk refresh), kita set value ke null (berputar)
                            // Jika belum isArmed, kita gunakan progressValue (mengisi)
                            value: controller.isArmed ? null : progressValue,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Konten utama yang bergerak saat refresh
                  Transform.translate(
                    offset: Offset(
                      0.0,
                      controller.value * 80, // Bergerak sejauh tinggi indikator
                    ),
                    child: child,
                  ),
                ],
              );
            },
            child: CustomScrollView(
              slivers: [
                BlocBuilder<GetProductBloc, GetProductState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      orElse:
                          () => const SliverToBoxAdapter(
                            child: Center(child: CircularProgressIndicator()),
                          ),
                      loading: _buildLoadingSkeleton,
                      error: (message) {
                        log(message);
                        return const SliverToBoxAdapter(
                          child: Center(child: Text("Terjadi Kesalahan")),
                        );
                      },
                      loaded: (menus) {
                        if (menus.isEmpty) {
                          return const SliverFillRemaining(
                            hasScrollBody: false,
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
                                (context, index) =>
                                    MenuCard(item: menus[index]),
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
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        childCount: 6,
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
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(height: 16, width: 100, color: Colors.white),
              ),
              const SizedBox(height: 6),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(height: 14, width: 80, color: Colors.white),
              ),
              const SizedBox(height: 8),
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
