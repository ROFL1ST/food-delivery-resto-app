import 'dart:developer';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_resto_app/core/core.dart';
import 'package:food_delivery_resto_app/core/extensions/build_context_ext.dart';
import 'package:food_delivery_resto_app/presentation/menu/bloc/update_order_status/update_oder_status_bloc.dart';
import 'package:food_delivery_resto_app/presentation/menu/widgets/order_detail_loading.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:food_delivery_resto_app/core/constants/colors.dart'; // Asumsi AppColors ada di sini
import 'package:food_delivery_resto_app/data/models/response/order_response_modeld.dart'; // Model Order Anda
import 'package:food_delivery_resto_app/presentation/menu/bloc/get_order_detail/get_order_detail_bloc.dart'; // Bloc GetOrderDetailBloc Anda

class OrderDetailPage extends StatefulWidget {
  final int? orderId;
  const OrderDetailPage({super.key, required this.orderId});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  void initState() {
    super.initState();
    // Panggil Bloc untuk mengambil detail pesanan saat halaman dimuat
    if (widget.orderId != null) {
      context.read<GetOrderDetailBloc>().add(
        GetOrderDetailEvent.getOrderDetail(id: widget.orderId!),
      );
    }
  }

  static const List<String> _statusProgression = [
    'pending',
    'processing',
    'prepared',
    'ready_for_delivery',
    'on_the_way',
    'accepted_by_driver',
    // 'canceled' is typically a terminal state, not part of a progression
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(IconsaxPlusLinear.arrow_left_1, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Order Detail",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: CustomRefreshIndicator(
        onRefresh: () async {
          // Implement your refresh logic here
          log('Refresh triggered');
          // You might want to re-fetch the order details here
          if (widget.orderId != null) {
            context.read<GetOrderDetailBloc>().add(
              GetOrderDetailEvent.getOrderDetail(id: widget.orderId!),
            );
          }
        },
        builder: (context, child, controller) {
          final double progressValue = controller.value.clamp(0.0, 1.0);
          return Stack(
            children: <Widget>[
              // Content that scrolls
              // The child here is the CustomScrollView. It is already a sliver-based widget.
              // So, we apply the translation directly to it.
              Transform.translate(
                offset: Offset(
                  0.0,
                  controller.value * 80, // Moves the content down with pull
                ),
                child: child, // This is your CustomScrollView
              ),
              // Refresh indicator overlaid on top
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 80, // Height of the indicator area
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
            ],
          );
        },
        child: CustomScrollView(
          slivers: [
            BlocBuilder<GetOrderDetailBloc, GetOrderDetailState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse:
                      () => const SliverFillRemaining(
                        child: OrderDetailLoading(),
                      ),
                  loading:
                      () => const SliverFillRemaining(
                        child: OrderDetailLoading(),
                      ),

                  error:
                      (message) => SliverFillRemaining(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              'Failed to load order details: $message\nPlease try again.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                  loaded: (order) {
                    if (order == null) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                IconsaxPlusLinear.warning_2,
                                size: 80,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Order not found or data is empty.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // --- Bagian Informasi Ringkasan Pesanan ---
                            _buildSectionTitle('Order Summary'),
                            const SizedBox(height: 12),
                            _buildInfoCard(
                              children: [
                                _buildSummaryHeader(order.id, order.status),
                                const Divider(
                                  height: 24,
                                  thickness: 0.8,
                                ), // Pemisah halus
                                _buildDetailRow(
                                  IconsaxPlusLinear.calendar,
                                  'Order Date',
                                  order.createdAt?.toFormattedDateTime() ?? '-',
                                ),
                                _buildDetailRow(
                                  IconsaxPlusLinear.wallet_1,
                                  'Payment Method',
                                  order.paymentMethod ?? 'Not specified',
                                ),
                                _buildDetailRow(
                                  IconsaxPlusLinear.user,
                                  'User Name',
                                  order.userName.toString(),
                                ),
                                _buildDetailRow(
                                  IconsaxPlusLinear.shop,
                                  'Restaurant Name',
                                  order.restaurantName.toString(),
                                ),
                                _buildDetailRow(
                                  IconsaxPlusLinear.map_1,
                                  'Shipping Address',
                                  order.shippingAddress ?? 'Not provided',
                                  isAddress: true,
                                ),
                              ],
                            ),

                            const SizedBox(height: 28), // Spasi antar bagian
                            // --- Bagian Item Pesanan ---
                            _buildSectionTitle('Items in Order'),
                            const SizedBox(height: 12),
                            _buildInfoCard(
                              children: [
                                if (order.orderItems != null &&
                                    order.orderItems!.isNotEmpty)
                                  ...order.orderItems!.map((item) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ), // Spasi antar item
                                      child: _buildOrderItemRow(item),
                                    );
                                  }).toList()
                                else
                                  const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Text(
                                        'No items found for this order.',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            const SizedBox(height: 28), // Spasi antar bagian
                            // --- Bagian Ringkasan Pembayaran ---
                            _buildSectionTitle('Payment Details'),
                            const SizedBox(height: 12),
                            _buildInfoCard(
                              children: [
                                _buildPriceRow(
                                  'Subtotal',
                                  order.totalPrice ?? 0,
                                ),
                                const SizedBox(height: 10),
                                _buildPriceRow(
                                  'Shipping Cost',
                                  order.shippingCost ?? 0,
                                ),
                                const Divider(
                                  height: 24,
                                  thickness: 1.2,
                                ), // Pemisah lebih tebal
                                _buildPriceRow(
                                  'Total Payment',
                                  order.totalBill ?? 0,
                                  isTotal: true,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // --- Status Update Buttons ---
                            _buildNextStatusButton(order.status),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildNextStatusButton(String? currentStatus) {
    final String normalizedStatus = currentStatus?.toLowerCase() ?? 'pending';
    final int currentIndex = _statusProgression.indexOf(normalizedStatus);

    // Determine the next status in the progression
    String? nextStatus;
    if (currentIndex != -1 && currentIndex < _statusProgression.length - 1) {
      nextStatus = _statusProgression[currentIndex + 1];
    }

    // Handle terminal states or no next status
    if (nextStatus == null ||
        normalizedStatus == 'ready_for_delivery' ||
        normalizedStatus == 'canceled' ||
        normalizedStatus == 'completed' ||
        normalizedStatus == 'on_the_way') {
      return const SizedBox.shrink(); // No button if no next status
    }

    String buttonText;
    Color buttonColor;
    switch (nextStatus) {
      case 'processing':
        buttonText = 'Set to Processing';
        buttonColor = Colors.blue.shade700;
        break;
      case 'prepared':
        buttonText = 'Mark as Prepared';
        buttonColor = Colors.teal.shade700;
        break;
      case 'completed':
        buttonText = 'Mark as Completed';
        buttonColor = Colors.green.shade700;
        break;
      case 'ready_for_delivery':
        buttonText = 'Mark Ready for Delivery';
        buttonColor = Colors.purple.shade700;
        break;
      default:
        buttonText = 'Update Status';
        buttonColor = AppColors.primary;
    }

    return BlocConsumer<UpdateOderStatusBloc, UpdateOderStatusState>(
      listener: (context, state) {
        state.maybeWhen(
          loading: () {
            return const Center(child: CircularProgressIndicator());
          },
          orElse: () {},
          success: () {
            context.showDialogSuccess('Berhasil', 'Menu berhasil diubah');
            context.read<GetOrderDetailBloc>().add(
              GetOrderDetailEvent.getOrderDetail(id: widget.orderId!),
            );
          },
          error: (message) {
            context.showDialogError('Gagal', message);
          },
        );
      },
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () {
            return SizedBox(
              width: double.infinity,
              // Center the single button
              child: ElevatedButton(
                onPressed: () {
                  context.read<UpdateOderStatusBloc>().add(
                    UpdateOderStatusEvent.updateOrderStatus(
                      id: widget.orderId!,
                      status: nextStatus!,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
          loading: () {
            return SizedBox(
              width: double.infinity,
              // Center the single button
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade400,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
                child: Text(
                  "Loading...",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0), // Added padding
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.black, // Atau Colors.black87
        ),
      ),
    );
  }

  Widget _buildInfoCard({required List<Widget> children}) {
    return Card(
      elevation: 3, // Sedikit lebih rendah untuk tampilan minimalis
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Sudut lebih besar
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(
          20.0,
        ), // Padding yang konsisten di dalam kartu
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildSummaryHeader(int? orderId, String? status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Order ID: #${orderId ?? '-'}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.black,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: _getStatusColor(status).withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status == "ready_for_delivery"
                ? "READY FOR DELIVERY"
                : status == "accepted_by_driver"
                ? "ACCEPTED BY DRIVER"
                : status == "on_the_way"
                ? "ON THE WAY"
                : status?.toUpperCase() ?? 'N/A',
            style: TextStyle(
              color: _getStatusColor(status),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value, {
    bool isAddress = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
      ), // Spasi vertikal antar baris
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: AppColors.primary.withOpacity(0.8),
          ), // Ikon lebih kecil & sedikit transparan
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontStyle:
                        isAddress
                            ? FontStyle.italic
                            : FontStyle.normal, // Teks alamat italic
                  ),
                  maxLines: isAddress ? 2 : 1, // Max 2 baris untuk alamat
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemRow(OrderItem item) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${item.quantity ?? 1}x',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product?.name ?? 'Unknown Product',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Rp ${item.price ?? 0} / item',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Text(
              'Rp ${(item.quantity ?? 0) * (item.price ?? 0)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
        // Divider hanya jika bukan item terakhir
        if (context.read<GetOrderDetailBloc>().state.maybeWhen(
          loaded: (order) => order?.orderItems?.last != item,
          orElse: () => false,
        ))
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Divider(
              thickness: 0.5,
              height: 0,
              indent: 40,
            ), // Divider antar item
          ),
      ],
    );
  }

  Widget _buildPriceRow(String label, int amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 17 : 15,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? AppColors.black : Colors.black87,
          ),
        ),
        Text(
          'Rp $amount',
          style: TextStyle(
            fontSize: isTotal ? 17 : 15,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? AppColors.primary : Colors.black87,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange.shade700;
      case 'processing':
        return Colors.blue.shade700;
      case 'completed':
        return Colors.green.shade700;
      case 'prepared':
        return Colors.teal.shade700;
      case 'ready_for_delivery':
        return Colors.purple.shade700;
      case 'accepted_by_driver':
        return Colors.amber.shade700;
      case 'on_the_way':
        return Colors.blue.shade700;
      case 'canceled':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }
}
