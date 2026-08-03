import 'package:flutter/material.dart';

import 'shimmer_box.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({
    super.key,
    this.height = 140,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const ShimmerBox(
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }
}