import 'package:flutter/material.dart';
import 'package:food_delivery_resto_app/core/components/components.dart';
import 'package:food_delivery_resto_app/core/constants/colors.dart';
import 'package:food_delivery_resto_app/core/core.dart';
import 'package:food_delivery_resto_app/core/extensions/build_context_ext.dart';
import 'package:food_delivery_resto_app/data/models/response/order_response_modeld.dart';
import 'package:food_delivery_resto_app/presentation/menu/pages/order_detail_page.dart';

class OrderCard extends StatefulWidget {
  final Order order; // Pastikan Anda memiliki model Order
  OrderCard({super.key, required this.order});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
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
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order ID: #${widget.order.id ?? '-'}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: AppColors.black, // Warna teks lebih netral
                    ),
                  ),
                  // Status kapsul yang lebih jelas
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        widget.order.status,
                      ).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.order.status == "ready_for_delivery"
                          ? "READY FOR DELIVERY"
                          : widget.order.status == "accepted_by_driver"
                          ? "ACCEPTED BY DRIVER"
                          : widget.order.status == "on_the_way"
                          ? "ON THE WAY"
                          : widget.order.status?.toUpperCase() ?? 'N/A',
                      style: TextStyle(
                        color: _getStatusColor(widget.order.status),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.015),
              DottedDivider(color: AppColors.gray4, height: 1.2),
              SizedBox(height: height * 0.01),
              Text(
                'Items:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: height * 0.01),
              ...?widget.order.orderItems?.map((item) {
                return Padding(
                  padding: EdgeInsets.only(left: 8.0, bottom: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item.quantity ?? 1}x',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: height * 0.01),
                      Expanded(
                        child: Text(
                          item.product?.name ?? 'Unknown Product',
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ),
                      Text(
                        item.price!.currencyFormatRp,
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                );
              }).toList(),
              if (widget.order.orderItems == null ||
                  widget.order.orderItems!.isEmpty)
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Tidak ada item dalam pesanan ini.',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ),

              SizedBox(height: height * 0.015),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Biaya Pengiriman:',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    widget.order.shippingCost!.currencyFormatRp,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Pembayaran:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  Text(
                    widget
                        .order
                        .totalBill!
                        .currencyFormatRp, // Format harga dengan mata uang
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: AppColors.primary, // Tetap gunakan warna primer
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'Tanggal: ${widget.order.createdAt?.toFormattedDateTime() ?? '-'}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
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
