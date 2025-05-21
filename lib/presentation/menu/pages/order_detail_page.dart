import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      context
          .read<GetOrderDetailBloc>()
          .add(GetOrderDetailEvent.getOrderDetail(id: widget.orderId!));
    }
  }

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
      body: BlocBuilder<GetOrderDetailBloc, GetOrderDetailState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Failed to load order details: $message\nPlease try again.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ),
            loaded: (order) {
              if (order == null) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(IconsaxPlusLinear.warning_2, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Order not found or data is empty.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20.0), // Padding lebih besar untuk ruang putih
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Bagian Informasi Ringkasan Pesanan ---
                    _buildSectionTitle('Order Summary'),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      children: [
                        _buildSummaryHeader(order.id, order.status),
                        const Divider(height: 24, thickness: 0.8), // Pemisah halus
                        _buildDetailRow(
                            IconsaxPlusLinear.calendar, 'Order Date',
                            order.createdAt?.toLocal().toString().split(' ')[0] ?? '-'),
                        _buildDetailRow(
                            IconsaxPlusLinear.wallet_1, 'Payment Method',
                            order.paymentMethod ?? 'Not specified'),
                        _buildDetailRow(
                            IconsaxPlusLinear.user, 'User ID', order.userId.toString()),
                        _buildDetailRow(
                            IconsaxPlusLinear.shop, 'Restaurant ID', order.restaurantId.toString()),
                        _buildDetailRow(IconsaxPlusLinear.map_1, 'Shipping Address',
                            order.shippingAddress ?? 'Not provided',
                            isAddress: true),
                      ],
                    ),

                    const SizedBox(height: 28), // Spasi antar bagian

                    // --- Bagian Item Pesanan ---
                    _buildSectionTitle('Items in Order'),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      children: [
                        if (order.orderItems != null && order.orderItems!.isNotEmpty)
                          ...order.orderItems!.map((item) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0), // Spasi antar item
                              child: _buildOrderItemRow(item),
                            );
                          }).toList()
                        else
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'No items found for this order.',
                                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
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
                        _buildPriceRow('Subtotal', order.totalPrice ?? 0),
                        const SizedBox(height: 10),
                        _buildPriceRow('Shipping Cost', order.shippingCost ?? 0),
                        const Divider(height: 24, thickness: 1.2), // Pemisah lebih tebal
                        _buildPriceRow(
                          'Total Payment',
                          order.totalBill ?? 0,
                          isTotal: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20), // Spasi di bagian bawah
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.black, // Atau Colors.black87
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
        padding: const EdgeInsets.all(20.0), // Padding yang konsisten di dalam kartu
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
            status?.toUpperCase() ?? 'N/A',
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

  Widget _buildDetailRow(IconData icon, String label, String value,
      {bool isAddress = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0), // Spasi vertikal antar baris
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary.withOpacity(0.8)), // Ikon lebih kecil & sedikit transparan
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
                    fontStyle: isAddress ? FontStyle.italic : FontStyle.normal, // Teks alamat italic
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
                        color: Colors.black87),
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
            child: Divider(thickness: 0.5, height: 0, indent: 40), // Divider antar item
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
      case 'canceled':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }
}