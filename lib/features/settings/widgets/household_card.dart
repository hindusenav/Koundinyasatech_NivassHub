import 'package:flutter/material.dart';

class HouseholdCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? rating;
  final VoidCallback? onAdd;

  const HouseholdCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.rating,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF0061C3);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: primaryBlue, size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (rating != null) ...[
                      const SizedBox(width: 2),
                      const Icon(Icons.star, color: Colors.amber, size: 12),
                      Text(
                        rating!,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]
                  ],
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (onAdd != null) ...[
            const SizedBox(width: 4),
            InkWell(
              onTap: onAdd,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  border: Border.all(color: primaryBlue.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '+ Add',
                  style: TextStyle(
                    color: primaryBlue,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}