import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/leave_controller.dart';

class LeaveView extends GetView<LeaveController> {
  LeaveView({super.key});

  final TextEditingController _reasonController = TextEditingController();

  Future<void> _selectStartDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: controller.startDate.value ?? DateTime.now(),
    );

    if (date != null) {
      controller.startDate.value = date;

      if (controller.endDate.value != null &&
          controller.endDate.value!.isBefore(date)) {
        controller.endDate.value = null;
      }
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final startDate = controller.startDate.value;

    if (startDate == null) {
      Get.snackbar('Select Start Date', 'Please select the start date first.');
      return;
    }

    final date = await showDatePicker(
      context: context,
      firstDate: startDate,
      lastDate: DateTime(2030),
      initialDate: controller.endDate.value ?? startDate,
    );

    if (date != null) {
      controller.endDate.value = date;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Select date';
    }

    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leave')),
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Apply for Leave',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: controller.leaveType.value.isEmpty
                    ? null
                    : controller.leaveType.value,
                decoration: const InputDecoration(
                  labelText: 'Leave Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Casual Leave',
                    child: Text('Casual Leave'),
                  ),
                  DropdownMenuItem(
                    value: 'Sick Leave',
                    child: Text('Sick Leave'),
                  ),
                  DropdownMenuItem(
                    value: 'Earned Leave',
                    child: Text('Earned Leave'),
                  ),
                ],
                onChanged: (value) {
                  controller.leaveType.value = value ?? '';
                },
              ),

              const SizedBox(height: 16),

              OutlinedButton(
                onPressed: () => _selectStartDate(context),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Start Date: ${_formatDate(controller.startDate.value)}',
                  ),
                ),
              ),

              const SizedBox(height: 12),

              OutlinedButton(
                onPressed: () => _selectEndDate(context),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'End Date: ${_formatDate(controller.endDate.value)}',
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _reasonController,
                onChanged: (value) {
                  controller.reason.value = value;
                },
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Reason',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          await controller.applyLeave();

                          if (!controller.isLoading.value) {
                            _reasonController.clear();
                          }
                        },
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Apply Leave'),
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'My Leave Requests',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              if (controller.leaveRequests.isEmpty)
                const Text('No leave requests found.')
              else
                ...controller.leaveRequests.map(
                  (leave) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(leave.leaveType),
                      subtitle: Text(
                        '${_formatDate(DateTime.tryParse(leave.startDate))}'
                        ' - '
                        '${_formatDate(DateTime.tryParse(leave.endDate))}\n'
                        '${leave.reason}',
                      ),
                      trailing: Text(leave.status.toUpperCase()),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
