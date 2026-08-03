import 'package:flutter/material.dart';

class DashboardLoadingWidget extends StatelessWidget {
  const DashboardLoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}