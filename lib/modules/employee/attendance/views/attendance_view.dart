import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../controller/attendance_controller.dart';

class AttendanceView extends GetView<AttendanceController> {
  const AttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Attendance',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(
          () => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Today's status
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: controller.hasCheckedOutToday.value
                        ? const Color(0xFFECFDF5)
                        : controller.hasCheckedInToday.value
                        ? const Color(0xFFEFF6FF)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: controller.hasCheckedOutToday.value
                          ? const Color(0xFFA7F3D0)
                          : controller.hasCheckedInToday.value
                          ? const Color(0xFFBFDBFE)
                          : const Color(0xFFE5E7EB),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: controller.hasCheckedOutToday.value
                              ? const Color(0xFFD1FAE5)
                              : controller.hasCheckedInToday.value
                              ? const Color(0xFFDBEAFE)
                              : const Color(0xFFF3F4F6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          controller.hasCheckedOutToday.value
                              ? Icons.task_alt_rounded
                              : controller.hasCheckedInToday.value
                              ? Icons.access_time_rounded
                              : Icons.fingerprint_rounded,
                          color: controller.hasCheckedOutToday.value
                              ? const Color(0xFF059669)
                              : controller.hasCheckedInToday.value
                              ? const Color(0xFF2563EB)
                              : const Color(0xFF6B7280),
                          size: 27,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.hasCheckedOutToday.value
                                  ? 'Attendance Completed'
                                  : controller.hasCheckedInToday.value
                                  ? 'You are Checked In'
                                  : 'Mark Your Attendance',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              controller.hasCheckedOutToday.value
                                  ? 'Your attendance for today is complete.'
                                  : controller.hasCheckedInToday.value
                                  ? 'You can check out when your workday is complete.'
                                  : 'Complete verification before checking in.',
                              style: const TextStyle(
                                fontSize: 13,
                                height: 1.4,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  'Verification',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Complete both checks before checking in.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                ),

                const SizedBox(height: 16),

                // Location verification
                _VerificationCard(
                  icon: Icons.location_on_rounded,
                  title: 'Location',
                  description: controller.isLocationVerified.value
                      ? 'Your location is within the assigned site.'
                      : 'Verify that you are inside your assigned site.',
                  verified: controller.isLocationVerified.value,
                ),

                const SizedBox(height: 12),

                // Selfie verification
                _VerificationCard(
                  icon: Icons.face_retouching_natural_rounded,
                  title: 'Selfie',
                  description: controller.isSelfieVerified.value
                      ? 'Your selfie has been verified successfully.'
                      : 'Take a selfie with exactly one face visible.',
                  verified: controller.isSelfieVerified.value,
                ),

                const SizedBox(height: 20),

                // Check Location
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed:
                        controller.hasCheckedInToday.value ||
                            controller.isLoading.value
                        ? null
                        : controller.checkLocation,
                    icon: controller.isLoading.value
                        ? const SizedBox(
                            height: 19,
                            width: 19,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.location_on_rounded),
                    label: Text(
                      controller.isLocationVerified.value
                          ? 'Location Verified'
                          : 'Verify Location',
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2563EB),
                      side: const BorderSide(color: Color(0xFF2563EB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Take Selfie
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: controller.hasCheckedInToday.value
                        ? null
                        : () {
                            Get.toNamed(AppRoutes.selfie);
                          },
                    icon: const Icon(Icons.camera_alt_rounded),
                    label: Text(
                      controller.isSelfieVerified.value
                          ? 'Selfie Verified'
                          : 'Take Selfie',
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2563EB),
                      side: const BorderSide(color: Color(0xFF2563EB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Attendance Actions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),

                const SizedBox(height: 14),

                // Check In
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed:
                        !controller.hasCheckedInToday.value &&
                            controller.isLocationVerified.value &&
                            controller.isSelfieVerified.value
                        ? controller.checkIn
                        : null,
                    icon: const Icon(Icons.login_rounded),
                    label: Text(
                      controller.hasCheckedInToday.value
                          ? 'Checked In'
                          : 'Check In',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFFE5E7EB),
                      disabledForegroundColor: const Color(0xFF9CA3AF),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Check Out
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed:
                        controller.hasCheckedInToday.value &&
                            !controller.hasCheckedOutToday.value
                        ? controller.checkOut
                        : null,
                    icon: const Icon(Icons.logout_rounded),
                    label: Text(
                      controller.hasCheckedOutToday.value
                          ? 'Checked Out'
                          : 'Check Out',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF111827),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFFE5E7EB),
                      disabledForegroundColor: const Color(0xFF9CA3AF),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // History
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton.icon(
                    onPressed: () {
                      Get.toNamed(AppRoutes.attendanceHistory);
                    },
                    icon: const Icon(Icons.history_rounded),
                    label: const Text('View Attendance History'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF2563EB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VerificationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool verified;

  const _VerificationCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.verified,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: verified ? const Color(0xFFA7F3D0) : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: verified
                  ? const Color(0xFFECFDF5)
                  : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: verified
                  ? const Color(0xFF059669)
                  : const Color(0xFF6B7280),
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.35,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            verified
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: verified ? const Color(0xFF059669) : const Color(0xFF9CA3AF),
            size: 23,
          ),
        ],
      ),
    );
  }
}
