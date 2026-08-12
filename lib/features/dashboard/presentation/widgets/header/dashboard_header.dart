// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../../../app/app_routes.dart';
// import '../../../../../core/theme/app_colors.dart';
// import '../../provider/dashboard_provider.dart';

// class DashboardHeader extends StatelessWidget {
//   const DashboardHeader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<DashboardProvider>();

//     final user = provider.home?.data.user;

//     final addresses = provider.addresses;

//     final flatLabel = addresses.isNotEmpty
//         ? addresses
//             .firstWhere(
//               (e) => e.isDefault,
//               orElse: () => addresses.first,
//             )
//             .flatNumber
//         : (user?.flatNumber ?? '');

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // -------------------------------------------------------------
//           // Profile image
//           // -------------------------------------------------------------
//           CircleAvatar(
//             radius: 20,
//             backgroundColor: AppColors.grey200,
//             backgroundImage:
//                 (user != null && user.profileImage.isNotEmpty)
//                     ? CachedNetworkImageProvider(user.profileImage)
//                     : null,
//             onBackgroundImageError:
//                 (user != null && user.profileImage.isNotEmpty)
//                     ? (_, _) {}
//                     : null,
//             child: (user == null || user.profileImage.isEmpty)
//                 ? const Icon(
//                     Icons.person_outline,
//                     color: AppColors.grey500,
//                   )
//                 : null,
//           ),

//           const SizedBox(width: 10),

//           // -------------------------------------------------------------
//           // User name + flat number
//           // -------------------------------------------------------------
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Hello! ${user?.name ?? 'there'} \u{1F44B}',
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),

//                 const SizedBox(height: 3),

//                 InkWell(
//                   borderRadius: BorderRadius.circular(8),
//                   onTap: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Switch flat coming soon.'),
//                       ),
//                     );
//                   },
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         flatLabel,
//                         style: const TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       const Icon(
//                         Icons.keyboard_arrow_down_rounded,
//                         size: 18,
//                         color: Colors.grey,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // -------------------------------------------------------------
//           // Search
//           // -------------------------------------------------------------
//           IconButton(
//             onPressed: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Search coming soon.'),
//                 ),
//               );
//             },
//             icon: const Icon(
//               Icons.search,
//               color: Colors.black87,
//             ),
//           ),

//           // -------------------------------------------------------------
//           // Messages
//           // -------------------------------------------------------------
//           IconButton(
//             onPressed: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Messages coming soon.'),
//                 ),
//               );
//             },
//             icon: const Icon(
//               Icons.chat_bubble_outline,
//               color: Colors.black87,
//             ),
//           ),

//           // -------------------------------------------------------------
//           // USER PROFILE BUTTON
//           // Tap U -> ProfileScreen
//           // -------------------------------------------------------------
//           GestureDetector(
//             onTap: () {
//               Navigator.pushNamed(
//                 context,
//                 AppRoutes.profile,
//               );
//             },
//             child: CircleAvatar(
//               radius: 18,
//               backgroundColor: AppColors.tertiary,
//               child: Text(
//                 (user?.name.isNotEmpty ?? false)
//                     ? user!.name[0].toUpperCase()
//                     : '?',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }// dashboard_header.dart
import 'package:flutter/material.dart';
import 'notification_icon.dart'; // Make sure to import your notification icon widget

class DashboardHeader extends StatelessWidget {
  final String userName;
  final String flatNumber;
  final String? profileImagePath;
  final VoidCallback? onProfileTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onMessageTap;

  const DashboardHeader({
    super.key,
    this.userName = 'Sireesha',    // Default fallback name
    this.flatNumber = 'B-402',     // Default fallback flat number
    this.profileImagePath,
    this.onProfileTap,
    this.onSearchTap,
    this.onMessageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          // Left Profile Avatar
          GestureDetector(
            onTap: onProfileTap,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: (profileImagePath != null && profileImagePath!.isNotEmpty)
                  ? NetworkImage(profileImagePath!)
                  : null,
              child: (profileImagePath == null || profileImagePath!.isEmpty)
                  ? Icon(Icons.person, color: Colors.grey.shade600, size: 20)
                  : null,
            ),
          ),
          const SizedBox(width: 12),

          // Dynamic Name & Flat Number
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Hello! $userName 👋', // Updates with the actual user name
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2A38),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      flatNumber,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Search Button
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: onSearchTap,
          ),

          // Message Button
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.black87),
            onPressed: onMessageTap,
          ),

          // Right Dynamic Profile/Notification Logo Widget
          ProfileNotificationIcon(
            userName: userName,
            profileImagePath: profileImagePath,
            onTap: onProfileTap,
          ),
        ],
      ),
    );
  }
}