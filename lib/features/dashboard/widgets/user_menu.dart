import 'package:flutter/material.dart';

import '../../profile/screens/profile_screen.dart';

class UserMenu extends StatelessWidget {
  const UserMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          ),
        );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Color(0xFFF5A623),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Text(
          'U',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}