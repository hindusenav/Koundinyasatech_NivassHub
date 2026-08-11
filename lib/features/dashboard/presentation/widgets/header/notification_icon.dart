import 'package:flutter/material.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({
    super.key,
    this.count = 3,
    this.onTap,
  });

  final int count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // =============================================================
          // CUSTOM NOTIFICATION IMAGE
          // =============================================================
          Image.asset(
            'assets/icons/notification.png',
            width: 20,
            height: 20,
            fit: BoxFit.contain,
          ),

          // =============================================================
          // NOTIFICATION COUNT
          // =============================================================
          if (count > 0)
            Positioned(
              right: -4,
              top: -5,
              child: Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
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