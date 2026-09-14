import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../auth/controller/auth_controller.dart';

class EmployeeDashboardView extends StatelessWidget {
  const EmployeeDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Dashboard'),
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
              Get.toNamed(AppRoutes.attendance);
            },
          icon: const Icon(Icons.fingerprint),
          label: const Text('Attendance'),
        ),
      ),
    );
  }
}