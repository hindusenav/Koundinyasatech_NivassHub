import 'package:flutter/material.dart';

class DashboardErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const DashboardErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 150),

        const Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 70,
        ),

        const SizedBox(height: 20),

        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              message,
              textAlign: TextAlign.center,
            ),
          ),
        ),

        const SizedBox(height: 24),

        Center(
          child: ElevatedButton(
            onPressed: onRetry,
            child: const Text("Retry"),
          ),
        ),
      ],
    );
  }
}