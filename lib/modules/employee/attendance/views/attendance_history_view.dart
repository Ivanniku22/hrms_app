import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/attendance_controller.dart';

class AttendanceHistoryView extends GetView<AttendanceController> {
  const AttendanceHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Attendance History',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
          ),
        ),
      ),
      body: Obx(() {
        final records = controller.filteredAttendanceHistory;

        return Column(
          children: [
            // Filter section
            Container(
              margin: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.calendar_month_rounded,
                      color: Color(0xFF2563EB),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Month',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(width: 8),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: controller.selectedMonth.value,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Color(0xFF6B7280),
                      ),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                      items: List.generate(12, (index) {
                        final month = index + 1;

                        return DropdownMenuItem<int>(
                          value: month,
                          child: Text(_monthName(month)),
                        );
                      }),
                      onChanged: (value) {
                        if (value != null) {
                          controller.selectedMonth.value = value;
                        }
                      },
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${controller.selectedYear.value}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Records
            Expanded(
              child: records.isEmpty
                  ? _EmptyState(
                      month: _monthName(controller.selectedMonth.value),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                      itemCount: records.length,
                      itemBuilder: (context, index) {
                        final attendance = records[index];

                        return _AttendanceCard(attendance: attendance);
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  final dynamic attendance;

  const _AttendanceCard({required this.attendance});

  String _formatDate(String date) {
    final parsedDate = DateTime.tryParse(date);

    if (parsedDate == null) {
      return date;
    }

    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return '${weekdays[parsedDate.weekday - 1]}, '
        '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
  }

  String _formatTime(String? value) {
    if (value == null) {
      return 'Not recorded';
    }

    final dateTime = DateTime.tryParse(value);

    if (dateTime == null) {
      return value;
    }

    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;

    return '$displayHour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final isCheckedOut = attendance.checkOutTime != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date + status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  _formatDate(attendance.date),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isCheckedOut
                      ? const Color(0xFFECFDF5)
                      : const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isCheckedOut ? 'Completed' : 'Open',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isCheckedOut
                        ? const Color(0xFF059669)
                        : const Color(0xFFEA580C),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Check in / check out
          Row(
            children: [
              Expanded(
                child: _TimeInfo(
                  icon: Icons.login_rounded,
                  label: 'Check In',
                  value: _formatTime(attendance.checkInTime),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _TimeInfo(
                  icon: Icons.logout_rounded,
                  label: 'Check Out',
                  value: _formatTime(attendance.checkOutTime),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Divider(height: 1, color: Color(0xFFE5E7EB)),

          const SizedBox(height: 14),

          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 18,
                color: Color(0xFF6B7280),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  attendance.siteName ?? 'Site not available',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4B5563),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                attendance.status.toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2563EB),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _TimeInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 19, color: const Color(0xFF2563EB)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String month;

  const _EmptyState({required this.month});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.event_busy_rounded,
                size: 34,
                color: Color(0xFF2563EB),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'No Attendance Records',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 7),
            Text(
              'There are no attendance records for $month.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }
}

String _monthName(int month) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  return months[month - 1];
}
