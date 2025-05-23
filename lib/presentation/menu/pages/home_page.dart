import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_resto_app/core/constants/variables.dart';
import 'package:food_delivery_resto_app/data/models/response/pupular_response_model.dart';
import 'package:food_delivery_resto_app/presentation/menu/bloc/get_overview/get_overview_bloc.dart';
import 'package:food_delivery_resto_app/core/core.dart'; // Make sure this path is correct for currencyFormatRp extension
import 'package:food_delivery_resto_app/data/models/response/overview_response_model.dart';
import 'package:food_delivery_resto_app/presentation/menu/bloc/get_popular_menu/get_popular_menu_bloc.dart'; // Import your model

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Simulasi data menu terpopuler (bisa dari API)
  

  @override
  void initState() {
    super.initState();
    context.read<GetOverviewBloc>().add(GetOverviewEvent.getOverview());
    context.read<GetPopularMenuBloc>().add(GetPopularMenuEvent.getPopularMenu());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Dashboard Mitra Restoran',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black54),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifikasi terbaru...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pengaturan akun...')),
              );
            },
          ),
        ],
      ),
      
      body: Stack(
        children: [
          CustomRefreshIndicator(
            onRefresh: () async {
              log('Refresh triggered');
              context.read<GetOverviewBloc>().add(
                GetOverviewEvent.getOverview(),
              );
            },
            builder: (context, child, controller) {
              final double progressValue = controller.value.clamp(0.0, 1.0);
              return Stack(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 80,
                    child: Opacity(
                      opacity: controller.value.clamp(0.0, 1.0),
                      child: Center(
                        child: Transform.scale(
                          scale: controller.value.clamp(0.0, 1.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.gray4,
                            ),
                            value: controller.isArmed ? null : progressValue,
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
            child: BlocBuilder<GetOverviewBloc, GetOverviewState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse:
                      () => const Center(child: CircularProgressIndicator()),
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                  error: (message) {
                    log(message);
                    return Center(
                      child: Text('Error loading data: $message'),
                    ); // More informative
                  },
                  loaded: (overview) {
                    // Pastikan data tidak null sebelum digunakan
                    final overviewData = overview.data;

                    final int totalOrders = overviewData?.totalOrders ?? 0;
                    // totalProducts tidak digunakan di UI ini, bisa dihilangkan
                    final int totalRevenue = overviewData?.totalRevenue ?? 0;
                    final int pendingOrders = overviewData?.pendingOrders ?? 0;
                    final int todayDeliveries =
                        overviewData?.todayDeliveries ?? 0;
                    final String message = overview.message ?? 'Data fetched.';

                    return CustomScrollView(
                      // <-- CustomScrollView di sini
                      slivers: [
                        SliverToBoxAdapter(
                          // <-- Wrap your Column content in SliverToBoxAdapter
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // --- Welcome Section ---
                                const Text(
                                  'Ringkasan Hari Ini',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // --- Overview Cards (Grid) ---
                                GridView.count(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  children: [
                                    _buildOverviewCard(
                                      context,
                                      icon: Icons.assignment_outlined,
                                      label: 'Total Pesanan',
                                      value: '$totalOrders',
                                      color: Colors.blue.shade50,
                                      textColor: Colors.blue.shade700,
                                    ),
                                    _buildOverviewCard(
                                      context,
                                      icon: Icons.monetization_on_outlined,
                                      label: 'Total Pendapatan',
                                      value:
                                          totalRevenue
                                              .currencyFormatRp, // Use extension
                                      color: Colors.green.shade50,
                                      textColor: Colors.green.shade700,
                                    ),
                                    _buildOverviewCard(
                                      context,
                                      icon: Icons.access_time,
                                      label: 'Pesanan Menunggu',
                                      value: '$pendingOrders',
                                      color: Colors.orange.shade50,
                                      textColor: Colors.orange.shade700,
                                    ),
                                    _buildOverviewCard(
                                      context,
                                      icon: Icons.delivery_dining,
                                      label: 'Terkirim Hari Ini',
                                      value: '$todayDeliveries',
                                      color: Colors.purple.shade50,
                                      textColor: Colors.purple.shade700,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),

                                // --- Popular Menu Items Section ---
                                const Text(
                                  'Menu Terpopuler',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                BlocBuilder<
                                  GetPopularMenuBloc,
                                  GetPopularMenuState
                                >(
                                  builder: (context, state) {
                                    return state.maybeWhen(
                                      orElse: () {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                      loading: () {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                      error: (message) {
                                        log(message);
                                        return const Center(
                                          child: Text('Error loading data'),
                                        );
                                      },
                                      loaded: (popularMenu) {
                                        if (popularMenu.isEmpty) {
                                          return const Center(
                                            child: Text(
                                              'No Popular Menu Available',
                                            ),
                                          );
                                        } else {
                                          return SizedBox(
                                            height: 180,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  popularMenu.length,
                                              itemBuilder: (context, index) {
                                                final item =
                                                    popularMenu[index];
                                                return _buildPopularMenuItemCard(
                                                  context,
                                                  item,
                                                );
                                              },
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(height: 30),

                                // --- Quick Actions Section ---
                                const Text(
                                  'Aksi Cepat',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildQuickActionButton(
                                      context,
                                      icon: Icons.add_circle_outline,
                                      label: 'Buat Pesanan Manual',
                                      onTap: () {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Membuka form pesanan manual...',
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    _buildQuickActionButton(
                                      context,
                                      icon: Icons.restaurant_menu_outlined,
                                      label: 'Edit Menu',
                                      onTap: () {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Membuka editor menu...',
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    _buildQuickActionButton(
                                      context,
                                      icon: Icons.person_outline,
                                      label: 'Dukungan',
                                      onTap: () {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Menghubungi dukungan...',
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),

                                // --- Footer Info (optional) ---
                                Center(
                                  child: Text(
                                    message,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Color textColor,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      color: color,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Anda menekan $label')));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32, color: textColor),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopularMenuItemCard(
    BuildContext context,
    Datum item,
  ) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(9),
              ),
              child: CachedNetworkImage(
                imageUrl: '${Variables.baseUrl}/uploads/products/${item.image}',
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Container(
                      height: 120,
                      color: AppColors.gray1,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                errorWidget: (context, url, error) {
                  print('Error loading image: $error');
                  return Container(
                    height: 120,
                    color: AppColors.gray1,
                    child: const Icon(
                      Icons.broken_image,
                      color: AppColors.gray2,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.sales ?? "0x terjual",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200, width: 1),
            ),
            child: Icon(icon, size: 28, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 80,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
