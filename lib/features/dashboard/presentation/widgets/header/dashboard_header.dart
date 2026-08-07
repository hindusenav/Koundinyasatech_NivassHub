import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../app/app_routes.dart';
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
        ? addresses
            .firstWhere(
              (e) => e.isDefault,
              orElse: () => addresses.first,
            )
            .flatNumber
        : (user?.flatNumber ?? '');

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.grey200,
            backgroundImage: (user != null && user.profileImage.isNotEmpty)
                ? CachedNetworkImageProvider(user.profileImage)
                : null,
            onBackgroundImageError:
                (user != null && user.profileImage.isNotEmpty)
                    ? (_, _) {}
                    : null,
            child: (user == null || user.profileImage.isEmpty)
                ? const Icon(Icons.person_outline, color: AppColors.grey500)
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello! ${user?.name ?? 'there'} \u{1F44B}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Switch flat coming soon.'),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        flatLabel,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.search),
            icon: const Icon(Icons.search, color: Colors.black87),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Messages coming soon.')),
              );
            },
            icon: const Icon(
              Icons.chat_bubble_outline,
              color: Colors.black87,
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.tertiary,
              child: Text(
                (user?.name.isNotEmpty ?? false)
                    ? user!.name[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
