import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_resto_app/core/constants/variables.dart';
import 'package:food_delivery_resto_app/data/datasources/auth_local_datasources.dart';
import 'package:food_delivery_resto_app/data/models/response/pupular_response_model.dart';
import 'package:food_delivery_resto_app/presentation/menu/bloc/get_overview/get_overview_bloc.dart';
import 'package:food_delivery_resto_app/core/core.dart';
import 'package:food_delivery_resto_app/presentation/menu/bloc/get_popular_menu/get_popular_menu_bloc.dart';
import 'package:food_delivery_resto_app/presentation/menu/widgets/home_card_loading.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _userName;
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
    context.read<GetOverviewBloc>().add(const GetOverviewEvent.getOverview());
    context.read<GetPopularMenuBloc>().add(
      const GetPopularMenuEvent.getPopularMenu(),
    );
    final authData = await AuthLocalDatasources().getAuthData();
    if (authData != null) {
      setState(() {
        _userName = authData.data?.user?.name ?? 'User';
        restaurantName = authData.data?.user?.restaurantName ?? 'Restaurant';
        phone = authData.data?.user?.phone ?? '';
        restaurantAddress = authData.data?.user?.restaurantAddress ?? '';
        photo = authData.data?.user?.photo ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
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
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Ringkasan Hari Ini Section ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamat datang, $_userName',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Hari ini, ${DateFormat('dd MMMM yyyy').format(DateTime.now())}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.gray3,
                          ), // Menggunakan gray3
                        ),
                      ],
                    ),
                    // photo profile
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: AppColors.gray4,
                      child: CachedNetworkImage(
                        imageUrl:
                            '${Variables.baseUrl}/uploads/profile/${photo ?? ''}',
                        placeholder:
                            (context, url) => Icon(
                              IconsaxPlusBold.user,
                              size: 25,
                              color: AppColors.gray3, // Menggunakan gray3
                            ),
                        errorWidget: (context, url, error) {
                          log('Error loading image: $error');
                          return Icon(
                            IconsaxPlusBold.user,
                            size: 25,
                            color: AppColors.gray3, // Menggunakan gray3
                          );
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: height * 0.02),
                BlocBuilder<GetOverviewBloc, GetOverviewState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      loading:
                          () => HomeCardLoading(
                            context,
                            width: width,
                            height: height,
                          ),
                      error:
                          (message) => Center(
                            child: Text(
                              'Error: $message',
                              style: const TextStyle(color: AppColors.red),
                            ),
                          ), // Menggunakan AppColors.red
                      loaded: (overview) {
                        final overviewData = overview.data;
                        final int totalOrders = overviewData?.totalOrders ?? 0;
                        final int totalRevenue =
                            overviewData?.totalRevenue ?? 0;
                        final int pendingOrders =
                            overviewData?.pendingOrders ?? 0;
                        final int todayDeliveries =
                            overviewData?.todayDeliveries ?? 0;
                        final int transactionPercentage =
                            overviewData?.transactionPercentage ?? 0;
                        final int pendingPercentage =
                            overviewData?.pendingPercentage ?? 0;
                        final int todayDeliveriesPercentage =
                            overviewData?.todayDeliveriesPercentage ?? 0;
                        return Card(
                          margin: EdgeInsets.zero,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(
                              color: AppColors.stroke,
                              width: 1,
                            ), // Menggunakan stroke dari AppColors
                          ),
                          color: AppColors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Pendapatan Section
                              Card(
                                elevation: 0,

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: const BorderSide(
                                    color: AppColors.stroke,
                                    width: 1,
                                  ), // Menggunakan stroke dari AppColors
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                restaurantName ??
                                                    'Nama Restoran',
                                                style: TextStyle(
                                                  color: AppColors.black,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(
                                                    IconsaxPlusBold.location,
                                                    color: AppColors.red,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    restaurantAddress ??
                                                        'Alamat Restoran',
                                                    style: const TextStyle(
                                                      color: AppColors.gray3,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: height * 0.02),
                                      // Transaksi hari ini dan Penjualan kotor hari ini
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Transaksi hari ini',
                                                  style: TextStyle(
                                                    color: AppColors.gray3,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                SizedBox(height: height * 0.01),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '$totalOrders',
                                                      style: const TextStyle(
                                                        color: AppColors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Icon(
                                                      transactionPercentage >= 0
                                                          ? Icons
                                                              .arrow_upward_sharp
                                                          : Icons
                                                              .arrow_downward_sharp,
                                                      color:
                                                          transactionPercentage >=
                                                                  0
                                                              ? AppColors.green
                                                              : AppColors.red,
                                                      size: 16,
                                                    ),

                                                    Text(
                                                      '${transactionPercentage.abs()}%', // DUMMY
                                                      style: TextStyle(
                                                        color: AppColors.green,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Penjualan kotor hari ini',
                                                  style: TextStyle(
                                                    color: AppColors.gray3,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                SizedBox(height: height * 0.01),
                                                Text(
                                                  totalRevenue.currencyFormatRp,
                                                  style: const TextStyle(
                                                    color: AppColors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.01),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  bottom: 20.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Pesanan tertunda hari ini',
                                            style: TextStyle(
                                              color: AppColors.gray3,
                                              fontSize: 13,
                                            ),
                                          ),
                                          SizedBox(height: height * 0.01),
                                          Row(
                                            children: [
                                              Text(
                                                '$pendingOrders',
                                                style: const TextStyle(
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Icon(
                                                pendingPercentage >= 0
                                                    ? Icons.arrow_upward_sharp
                                                    : Icons
                                                        .arrow_downward_sharp,
                                                color:
                                                    pendingPercentage >= 0
                                                        ? AppColors.green
                                                        : AppColors.red,
                                                size: 16,
                                              ),

                                              Text(
                                                '${pendingPercentage.abs()}%', // DUMMY
                                                style: TextStyle(
                                                  color: AppColors.green,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Pengiriman hari ini',
                                            style: TextStyle(
                                              color: AppColors.gray3,
                                              fontSize: 13,
                                            ),
                                          ),
                                          SizedBox(height: height * 0.01),
                                          Row(
                                            children: [
                                              Text(
                                                '$todayDeliveries',
                                                style: const TextStyle(
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Icon(
                                                todayDeliveriesPercentage >= 0
                                                    ? Icons.arrow_upward_sharp
                                                    : Icons
                                                        .arrow_downward_sharp,
                                                color:
                                                    todayDeliveriesPercentage >=
                                                            0
                                                        ? AppColors.green
                                                        : AppColors.red,
                                                size: 16,
                                              ),

                                              Text(
                                                '${todayDeliveriesPercentage.abs()}%', // DUMMY
                                                style: TextStyle(
                                                  color: AppColors.green,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.05,
                                    ), // Menggunakan width dari MediaQuery
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      orElse:
                          () => HomeCardLoading(
                            context,
                            width: width,
                            height: height,
                          ),
                    );
                  },
                ),
                SizedBox(height: height * 0.02),
                const Text(
                  'Aksi Cepat',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: height * 0.01),
                quick_menu(context),
                SizedBox(height: height * 0.03),
                // --- Menu Terpopuler Section ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Menu Terpopuler',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Melihat semua menu...'),
                          ),
                        );
                      },
                      child: const Text(
                        'Lihat Semua',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                BlocBuilder<GetPopularMenuBloc, GetPopularMenuState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      loading:
                          () => const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                            ),
                          ),
                      error:
                          (message) => Center(
                            child: Text(
                              'Error memuat menu: $message',
                              style: const TextStyle(color: AppColors.red),
                            ),
                          ),
                      loaded: (popularMenu) {
                        if (popularMenu.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 30.0),
                              child: Text(
                                'Belum ada menu terpopuler saat ini.',
                                style: TextStyle(
                                  color: AppColors.gray3,
                                  fontSize: 14,
                                ), // Menggunakan gray3
                              ),
                            ),
                          );
                        } else {
                          return SizedBox(
                            height: 220,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: popularMenu.length,
                              itemBuilder: (context, index) {
                                final item = popularMenu[index];
                                return _buildPopularMenuItemCard(context, item);
                              },
                            ),
                          );
                        }
                      },
                      orElse: () => const SizedBox.shrink(),
                    );
                  },
                ),
                SizedBox(height: height * 0.03),
                // --- Aksi Cepat Section ---
                SizedBox(height: height * 0.03),
                // --- Footer Info ---
                const Center(
                  child: Text(
                    'Data diperbarui secara real-time.',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: AppColors.gray3, // Menggunakan gray3
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget quick_menu(BuildContext context) {
    final List<Widget> quickActionButtons = [
      _buildQuickActionButton(
        context,
        icon: IconsaxPlusBold.shopping_cart,
        label: 'Pesanan',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Membuka halaman buat pesanan...')),
          );
        },
      ),
      _buildQuickActionButton(
        context,
        icon: IconsaxPlusBold.menu,
        label: 'Menu',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Membuka halaman kelola menu...')),
          );
        },
      ),
      _buildQuickActionButton(
        context,
        icon: IconsaxPlusBold.message_question,
        label: 'Bantuan',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Membuka pusat bantuan...')),
          );
        },
      ),
      _buildQuickActionButton(
        context,
        icon: IconsaxPlusBold.info_circle,
        label: 'Tentang',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Membuka halaman Tentang...')),
          );
        },
      ),
      _buildQuickActionButton(
        context,
        icon: IconsaxPlusBold.setting_2, // Contoh tombol kelima
        label: 'Pengaturan',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Membuka halaman Pengaturan...')),
          );
        },
      ),
      _buildQuickActionButton(
        context,
        icon: IconsaxPlusBold.user, // Contoh tombol keenam
        label: 'Profil',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Membuka halaman Profil...')),
          );
        },
      ),
    ];

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Expanded(
        child: Wrap(
          alignment: WrapAlignment.start, // Meratakan item secara horizontal
          spacing: 8.0, // Jarak horizontal antar item
          runSpacing: 16.0, // Jarak vertikal antar baris
          children:
              quickActionButtons
                  .map(
                    (button) => SizedBox(
                      width: MediaQuery.of(context).size.width / 4 - 14,
                      child: button,
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }

  Widget _buildPopularMenuItemCard(BuildContext context, Datum item) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: AppColors.white, // Latar belakang kartu putih
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.stroke,
          width: 1,
        ), // Menggunakan stroke
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Melihat detail menu: ${item.name}')),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(
                   Radius.circular(16),
                ),
                child: CachedNetworkImage(
                  imageUrl:
                      '${Variables.baseUrl}/uploads/products/${item.image}',
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        height: 120,
                        color:
                            AppColors.gray5, // Menggunakan gray5 (lebih terang)
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                  errorWidget: (context, url, error) {
                    log('Error loading image: $error');
                    return Container(
                      height: 120,
                      color: AppColors.gray2, // Menggunakan gray2
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.gray3, // Menggunakan gray3
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name ?? "Nama Menu",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.sales ?? "0"} terjual',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.gray3,
                      ), // Menggunakan gray3
                    ),
                  ],
                ),
              ),
            ],
          ),
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
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white, // Latar belakang putih
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.stroke,
                width: 1,
              ), // Menggunakan stroke
            ),
            child: Icon(
              icon,
              size: 30,
              color: AppColors.primary,
            ), // Menggunakan primary
          ),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
