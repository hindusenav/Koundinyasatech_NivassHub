import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../provider/dashboard_provider.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    final user = provider.home?.data.user;
    final addresses = provider.addresses;

    final flatLabel = addresses.isNotEmpty
        ? addresses.firstWhere(
            (e) => e.isDefault,
            orElse: () => addresses.first,
          ).flatNumber
        : (user?.flatNumber ?? '');

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey.shade200,
            backgroundImage:
                (user != null && user.profileImage.isNotEmpty)
                    ? CachedNetworkImageProvider(user.profileImage)
                    : null,
            child: (user == null || user.profileImage.isEmpty)
                ? const Icon(Icons.person, color: Colors.grey)
                : null,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello! ${"User name"} 👋',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff222222),
                  ),
                ),

                const SizedBox(height: 3),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      flatLabel,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xffECECEC),
              ),
            ),
            child: const Icon(Icons.search),
          ),

          const SizedBox(width: 10),

          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xffECECEC),
              ),
            ),
            child: const Icon(Icons.chat_bubble_outline),
          ),
        ],
      ),
    );
  }
}