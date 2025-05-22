import 'dart:developer';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_resto_app/core/constants/colors.dart';
import 'package:food_delivery_resto_app/data/models/response/order_response_modeld.dart';
import 'package:food_delivery_resto_app/presentation/menu/bloc/get_order/get_order_bloc.dart';
import 'package:food_delivery_resto_app/presentation/menu/widgets/order_card.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _controller = IndicatorController(refreshEnabled: true);

  String _selectedFilter = 'pending';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<GetOrderBloc>().add(
      GetOrderEvent.getOrder(status: _selectedFilter),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Orders",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60), // Tinggi filter
          child: Container(
            color:
                Theme.of(
                  context,
                ).scaffoldBackgroundColor, // Background agar transparan
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildFilterChip('pending'),
                  const SizedBox(width: 8),
                  _buildFilterChip('processing'),
                  const SizedBox(width: 8),
                  _buildFilterChip('prepared'),
                  const SizedBox(width: 8),
                  _buildFilterChip('ready_for_delivery'),
                  const SizedBox(width: 8),
                  _buildFilterChip('completed'),
                  const SizedBox(width: 8),
                  _buildFilterChip('canceled'),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [

          // Content layer
          CustomRefreshIndicator(
            onRefresh: () async {
              // Implement your refresh logic here
              context.read<GetOrderBloc>().add(
                GetOrderEvent.getOrder(status: _selectedFilter),
              );
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
                BlocBuilder<GetOrderBloc, GetOrderState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      orElse:
                          () => const SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                      loading:
                          () => const SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                      error: (message) {
                        log(message);
                        return const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(child: Text('Error loading orders')),
                        );
                      },
                      loaded: (orders) {
                        if (orders.isEmpty) {
                          return SliverFillRemaining(
                            // Menggunakan SliverFillRemaining agar pesan kosong mengisi sisa ruang
                            hasScrollBody: false,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    IconsaxPlusBold.box,
                                    size: 80,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Tidak ada pesanan untuk status ini.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return SliverPadding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            sliver: SliverList.builder(
                              itemCount: orders.length,
                              itemBuilder: (context, index) {
                                final order = orders[index];
                                return OrderCard(order: order);
                              },
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

  Widget _buildFilterChip(String status) {
    bool isSelected = _selectedFilter == status;
    return ChoiceChip(
      label: Text(
        status == 'ready_for_delivery'
            ? 'READY FOR DELIVERY'
            : status.toUpperCase(),
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.primary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.primary.withOpacity(0.1),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedFilter = status;
          });

          context.read<GetOrderBloc>().add(
            GetOrderEvent.getOrder(status: _selectedFilter),
          );
        }
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color:
              isSelected
                  ? AppColors.primary
                  : AppColors.primary.withOpacity(0.5),
          width: 1.0,
        ),
      ),
    );
  }
}
