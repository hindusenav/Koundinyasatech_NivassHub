import 'package:flutter/material.dart';

import 'section_empty.dart';

class DashboardEmpty extends StatelessWidget {
  const DashboardEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: SectionEmpty(
            icon: Icons.dashboard_outlined,
            title: 'Dashboard is Empty',
            message:
                'No dashboard information is available at the moment.',
          ),
        ),
      ),
    );
  }
}