import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/attendance_controller.dart';

class AttendanceHistoryView extends GetView<AttendanceController> {
  const AttendanceHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance History')),
      body: Obx(
            () {
          final records = controller.filteredAttendanceHistory;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Text(
                      'Month:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    DropdownButton<int>(
                      value: controller.selectedMonth.value,
                      items: List.generate(
                        12,
                            (index) {
                          final month = index + 1;

                          return DropdownMenuItem<int>(
                            value: month,
                            child: Text(
                              _monthName(month),
                            ),
                          );
                        },
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          controller.selectedMonth.value = value;
                        }
                      },
                    ),
                    const Spacer(),
                    Text(
                      '${controller.selectedYear.value}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: records.isEmpty
                    ? const Center(
                  child: Text(
                    'No attendance records found for this month.',
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final attendance = records[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              attendance.date,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Check In: '
                                  '${attendance.checkInTime ?? 'N/A'}',
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Check Out: '
                                  '${attendance.checkOutTime ?? 'Not checked out'}',
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Status: ${attendance.status}',
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Site: '
                                  '${attendance.siteName ?? 'N/A'}',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
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