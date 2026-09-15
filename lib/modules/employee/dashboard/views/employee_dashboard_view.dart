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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed(AppRoutes.attendance);
                },
              icon: const Icon(Icons.fingerprint),
              label: const Text('Attendance'),
            ),

            const SizedBox(height: 12,),

            ElevatedButton.icon(
              onPressed: () {
                Get.toNamed(AppRoutes.profile);
              },
              icon: const Icon(Icons.person),
              label: const Text('Profile'),
            ),

            const SizedBox(height: 12,),

            ElevatedButton.icon(
              onPressed: () {
                Get.toNamed(AppRoutes.leave);
              },
              icon: const Icon(Icons.event_available),
              label: const Text('Leave'),
            ),
          ],
        ),
      ),
    );
  }
}