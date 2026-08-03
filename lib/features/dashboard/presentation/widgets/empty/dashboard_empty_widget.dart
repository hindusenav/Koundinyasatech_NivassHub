import 'package:flutter/material.dart';

class DashboardEmptyWidget extends StatelessWidget {
  const DashboardEmptyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: const [
        SizedBox(height: 200),

        Icon(
          Icons.inbox_outlined,
          size: 70,
          color: Colors.grey,
        ),

        SizedBox(height: 20),

        Center(
          child: Text(
            'No Dashboard Data Available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}