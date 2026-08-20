import 'package:flutter/material.dart';

class VisitorActionButton extends StatelessWidget {
  const VisitorActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 40,
        child: OutlinedButton.icon(
          onPressed: onTap,
          icon: Icon(
            icon,
            size: 18,
            color: color,
          ),
          label: Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: color),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}