// import 'package:flutter/material.dart';

// class NotificationIcon extends StatelessWidget {
//   const NotificationIcon({
//     super.key,
//     this.count = 3,
//     this.onTap,
//   });

//   final int count;
//   final VoidCallback? onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         IconButton(
//           onPressed: onTap,
//           icon: const Icon(
//             Icons.notifications_outlined,
//             size: 28,
//           ),
//         ),
//         if (count > 0)
//           Positioned(
//             right: 8,
//             top: 8,
//             child: Container(
//               height: 18,
//               width: 18,
//               decoration: const BoxDecoration(
//                 color: Colors.red,
//                 shape: BoxShape.circle,
//               ),
//               alignment: Alignment.center,
//               child: Text(
//                 '$count',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 10,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }// notification_icon.dart
import 'package:flutter/material.dart';

class ProfileNotificationIcon extends StatelessWidget {
  final String userName;
  final String? profileImagePath;
  final VoidCallback? onTap;

  const ProfileNotificationIcon({
    super.key,
    required this.userName,
    this.profileImagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Fallback: Get the first uppercase letter of the name (defaults to 'U' if empty)
    final String initial = (userName.isNotEmpty) 
        ? userName.trim()[0].toUpperCase() 
        : 'U';

    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 18,
        backgroundColor: const Color(0xFFF3A938), // Orange accent color
        backgroundImage: (profileImagePath != null && profileImagePath!.isNotEmpty)
            ? NetworkImage(profileImagePath!)
            : null,
        child: (profileImagePath == null || profileImagePath!.isEmpty)
            ? Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              )
            : null,
      ),
    );
  }
}