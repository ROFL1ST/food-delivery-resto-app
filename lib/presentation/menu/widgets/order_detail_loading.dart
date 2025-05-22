import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class OrderDetailLoading extends StatelessWidget {
  const OrderDetailLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title Skeleton
            _buildSkeletonLine(width: 150, height: 24),
            const SizedBox(height: 12),
            // Info Card Skeleton
            _buildCardSkeleton(
              children: [
                _buildSkeletonLine(width: double.infinity, height: 20),
                const SizedBox(height: 10),
                _buildSkeletonLine(width: double.infinity, height: 20),
                const SizedBox(height: 10),
                _buildSkeletonLine(width: double.infinity, height: 20),
                const SizedBox(height: 10),
                _buildSkeletonLine(width: double.infinity, height: 20),
              ],
            ),
            const SizedBox(height: 28),

            // Items in Order Section Skeleton
            _buildSkeletonLine(width: 180, height: 24),
            const SizedBox(height: 12),
            _buildCardSkeleton(
              children: [
                _buildOrderItemSkeleton(),
                const SizedBox(height: 8),
                _buildOrderItemSkeleton(),
                const SizedBox(height: 8),
                _buildOrderItemSkeleton(),
              ],
            ),
            const SizedBox(height: 28),

            // Payment Details Section Skeleton
            _buildSkeletonLine(width: 160, height: 24),
            const SizedBox(height: 12),
            _buildCardSkeleton(
              children: [
                _buildSkeletonLine(width: double.infinity, height: 20),
                const SizedBox(height: 10),
                _buildSkeletonLine(width: double.infinity, height: 20),
                const SizedBox(height: 10),
                _buildSkeletonLine(width: double.infinity, height: 20),
              ],
            ),
            const SizedBox(height: 20),

            // Action Button Skeleton
            Center(
              child: _buildSkeletonLine(
                width: double.infinity,
                height: 50,
                borderRadius: 10,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLine({
    required double width,
    required double height,
    double borderRadius = 4.0,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white, // This color will be shimmered
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  Widget _buildCardSkeleton({required List<Widget> children}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildOrderItemSkeleton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSkeletonLine(width: 30, height: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSkeletonLine(width: double.infinity, height: 18),
              const SizedBox(height: 4),
              _buildSkeletonLine(width: 100, height: 15),
            ],
          ),
        ),
        _buildSkeletonLine(width: 60, height: 18),
      ],
    );
  }
}
