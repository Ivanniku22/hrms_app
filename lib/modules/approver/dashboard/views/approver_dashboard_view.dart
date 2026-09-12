import 'package:flutter/material.dart';

class ApproverDashboardView extends StatelessWidget {
  const ApproverDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approver Dashboard'),
      ),
      body: const Center(
        child: Text(
          'Welcome, Approver!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}