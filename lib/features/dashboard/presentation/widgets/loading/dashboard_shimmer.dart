import 'package:flutter/material.dart';

import 'shimmer_box.dart';
import 'shimmer_card.dart';

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// Header
            const Row(
              children: [
                ShimmerBox(
                  height: 55,
                  width: 55,
                  radius: 30,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ShimmerBox(
                    height: 18,
                    width: double.infinity,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// Welcome Card
            const ShimmerCard(
              height: 120,
            ),

            /// Banner
            const ShimmerCard(
              height: 180,
            ),

            /// Maintenance
            const ShimmerCard(
              height: 90,
            ),

            const SizedBox(height: 10),

            /// Quick Actions
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 8,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: .85,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (_, __) {
                return const ShimmerBox(
                  height: 90,
                  width: 90,
                );
              },
            ),

            const SizedBox(height: 28),

            const ShimmerCard(height: 170),
            const ShimmerCard(height: 170),
            const ShimmerCard(height: 200),
            const ShimmerCard(height: 120),
          ],
        ),
      ),
    );
  }
}