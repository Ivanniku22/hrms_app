import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../auth/controller/auth_controller.dart';

class ApproverDashboardView extends StatelessWidget {
  const ApproverDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Approver Dashboard'),
        actions: [
          IconButton(
            onPressed: authController.logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            Get.toNamed('/approver/leave-approval');
          },
          icon: const Icon(Icons.approval),
          label: const Text('Leave Approvals'),
        ),
      ),
    );
  }
}