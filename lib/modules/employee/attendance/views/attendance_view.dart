import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../controller/attendance_controller.dart';

class AttendanceView extends GetView<AttendanceController> {
  const AttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Attendance Verification',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Icon(
                            controller.isLocationVerified.value
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: controller.isLocationVerified.value
                                ? Colors.green
                                : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          const Text('Location verified'),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Icon(
                            controller.isSelfieVerified.value
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: controller.isSelfieVerified.value
                                ? Colors.green
                                : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          const Text('Selfie verified'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Check Location
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed:
                      controller.hasCheckedInToday.value ||
                          controller.isLoading.value
                      ? null
                      : controller.checkLocation,
                  icon: const Icon(Icons.location_on),
                  label: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Check Location'),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Take Selfie
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.hasCheckedInToday.value
                      ? null
                      : () {
                          Get.toNamed(AppRoutes.selfie);
                        },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Take Selfie'),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Check In
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed:
                      !controller.hasCheckedInToday.value &&
                          controller.isLocationVerified.value &&
                          controller.isSelfieVerified.value
                      ? controller.checkIn
                      : null,
                  icon: const Icon(Icons.login),
                  label: Text(
                    controller.hasCheckedInToday.value
                        ? 'Checked In'
                        : 'Check In',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Check Out
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed:
                      controller.hasCheckedInToday.value &&
                          !controller.hasCheckedOutToday.value
                      ? controller.checkOut
                      : null,
                  icon: const Icon(Icons.logout),
                  label: Text(
                    controller.hasCheckedOutToday.value
                        ? 'Checked Out'
                        : 'Check Out',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
