import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/dashboard_provider.dart';
import 'error_card.dart';

class DashboardError extends StatelessWidget {
  const DashboardError({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<DashboardProvider>();

    return SafeArea(
      child: ErrorCard(
        title: "Something went wrong",
        message:
            "We couldn't load your dashboard.\nPlease check your connection and try again.",
        onRetry: provider.loadDashboard,
      ),
    );
  }
}