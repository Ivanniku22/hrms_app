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

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return const Color(0xFF059669);
      case 'rejected':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFFEA580C);
    }
  }

  Color _statusBackground(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return const Color(0xFFECFDF5);
      case 'rejected':
        return const Color(0xFFFEF2F2);
      default:
        return const Color(0xFFFFF7ED);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Leave',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
          ),
        ),
      ),
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Apply leave header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.event_available_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Apply for Leave',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Submit a leave request for approval.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Leave type
              const Text(
                'Leave Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                initialValue: controller.leaveType.value.isEmpty
                    ? null
                    : controller.leaveType.value,
                decoration: InputDecoration(
                  labelText: 'Leave Type',
                  prefixIcon: const Icon(
                    Icons.category_outlined,
                    color: Color(0xFF2563EB),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFF2563EB),
                      width: 1.5,
                    ),
                  ),
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

              const SizedBox(height: 14),

              // Dates
              Row(
                children: [
                  Expanded(
                    child: _DateButton(
                      icon: Icons.calendar_today_outlined,
                      label: 'Start Date',
                      value: _formatDate(controller.startDate.value),
                      onTap: () => _selectStartDate(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DateButton(
                      icon: Icons.event_outlined,
                      label: 'End Date',
                      value: _formatDate(controller.endDate.value),
                      onTap: () => _selectEndDate(context),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Reason
              TextField(
                controller: _reasonController,
                onChanged: (value) {
                  controller.reason.value = value;
                },
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Reason',
                  alignLabelWithHint: true,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 60),
                    child: Icon(Icons.notes_outlined, color: Color(0xFF2563EB)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFF2563EB),
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          await controller.applyLeave();

                          if (!controller.isLoading.value) {
                            _reasonController.clear();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFF93C5FD),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 21,
                          width: 21,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Apply Leave',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 32),

              // Requests section
              const Text(
                'My Leave Requests',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Track the status of your submitted requests.',
                style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),

              const SizedBox(height: 16),

              if (controller.leaveRequests.isEmpty)
                _EmptyLeaveState()
              else
                ...controller.leaveRequests.map((leave) {
                  final statusColor = _statusColor(leave.status);
                  final statusBackground = _statusBackground(leave.status);

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
                        Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.event_note_rounded,
                                color: Color(0xFF2563EB),
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                leave.leaveType,
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
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: statusBackground,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                leave.status.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: statusColor,
                                ),
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
                              Icons.date_range_outlined,
                              size: 18,
                              color: Color(0xFF6B7280),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${_formatDate(DateTime.tryParse(leave.startDate))}'
                                ' - '
                                '${_formatDate(DateTime.tryParse(leave.endDate))}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF374151),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.notes_outlined,
                              size: 18,
                              color: Color(0xFF6B7280),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                leave.reason,
                                style: const TextStyle(
                                  fontSize: 13,
                                  height: 1.4,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DateButton({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value != 'Select date';

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 18, color: const Color(0xFF2563EB)),
                  const SizedBox(width: 7),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? const Color(0xFF374151)
                      : const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyLeaveState extends StatelessWidget {
  const _EmptyLeaveState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: const Column(
        children: [
          Icon(Icons.event_busy_rounded, size: 38, color: Color(0xFF9CA3AF)),
          SizedBox(height: 12),
          Text(
            'No Leave Requests',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF374151),
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Your submitted leave requests will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }
}
