import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/attendance_controller.dart';

class AttendanceView extends GetView<AttendanceController> {
  const AttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
      ),
      body: Center(
        child: Obx(
              () => ElevatedButton.icon(
            onPressed: controller.isLoading.value
                ? null
                : controller.checkLocation,
            icon: const Icon(Icons.location_on),
            label: controller.isLoading.value
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
                : const Text('Check Location'),
          ),
        ),
      ),
    );
  }
}