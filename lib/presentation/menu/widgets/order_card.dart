import 'package:flutter/material.dart';
import 'package:food_delivery_resto_app/core/constants/colors.dart';
import 'package:food_delivery_resto_app/core/extensions/build_context_ext.dart';
import 'package:food_delivery_resto_app/data/models/response/order_response_modeld.dart';
import 'package:food_delivery_resto_app/presentation/menu/pages/order_detail_page.dart';

class OrderCard extends StatefulWidget {
  final Order order; // Pastikan Anda memiliki model Order
  const OrderCard({super.key, required this.order});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      // Kembali menggunakan Card
      elevation: 1, // Sedikit bayangan
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Sudut lebih halus
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Aksi saat card ditekan
          context.push(OrderDetailPage(orderId: widget.order.id));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order ID: #${widget.order.id ?? '-'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: AppColors.black, // Warna teks lebih netral
                    ),
                  ),
                  // Status kapsul yang lebih jelas
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        widget.order.status,
                      ).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.order.status?.toUpperCase() ?? 'N/A',
                      style: TextStyle(
                        color: _getStatusColor(widget.order.status),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(
                height: 20,
                thickness: 0.8,
                color: Colors.grey,
              ), // Garis pemisah yang lebih tipis
              // Daftar Item Pesanan
              const Text(
                'Items:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              ...?widget.order.orderItems?.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item.quantity ?? 1}x',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${item.product?.name ?? 'Unknown Product'}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      Text(
                        'Rp ${item.price ?? 0}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              if (widget.order.orderItems == null ||
                  widget.order.orderItems!.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Tidak ada item dalam pesanan ini.',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Biaya Pengiriman:',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    'Rp ${widget.order.shippingCost ?? 0}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Pembayaran:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  Text(
                    'Rp ${widget.order.totalBill ?? 0}', // Format harga dengan mata uang
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: AppColors.primary, // Tetap gunakan warna primer
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'Tanggal: ${widget.order.createdAt?.toLocal().toString().split(' ')[0] ?? '-'}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
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
