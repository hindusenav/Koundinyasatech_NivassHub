import 'package:flutter/material.dart';

class AdvertisementButton extends StatelessWidget {
  const AdvertisementButton({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.open_in_new),
      label: const Text("Learn More"),
      style: FilledButton.styleFrom(
        minimumSize: const Size(140, 42),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}