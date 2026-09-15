import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/leave_approval_controller.dart';

class LeaveApprovalView extends GetView<LeaveApprovalController> {
  const LeaveApprovalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Approvals'),
      ),
      body: Obx(
            () {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.pendingLeaves.isEmpty) {
                return const Center(
                  child: Text('No pending leave requests.'),
                );
              }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.pendingLeaves.length,
            itemBuilder: (context, index) {
              final leave = controller.pendingLeaves[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(leave.leaveType),
                  subtitle: Text(
                    'Employee: ${leave.userId}\n'
                        'From: ${_formatDate(leave.startDate)}\n'
                        'To: ${_formatDate(leave.endDate)}\n'
                        'Reason: ${leave.reason}',
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          controller.updateLeaveStatus(
                            leave.id,
                            'approved',
                          );
                        },
                        icon: const Icon(Icons.check),
                        tooltip: 'Approve',
                      ),
                      IconButton(
                        onPressed: () {
                          controller.updateLeaveStatus(
                            leave.id,
                            'rejected',
                          );
                        },
                        icon: const Icon(Icons.close),
                        tooltip: 'Reject',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(String date) {
    final parsedDate = DateTime.tryParse(date);

    if (parsedDate == null) {
      return date;
    }

    return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
  }
}