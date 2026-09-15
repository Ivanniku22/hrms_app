import 'dart:async';

import 'package:get/get.dart';

import '../../../../data/models/leave_model.dart';
import '../../../../data/repositories/leave_repository.dart';

class LeaveApprovalController extends GetxController {
  final LeaveRepository _leaveRepository;

  LeaveApprovalController(this._leaveRepository);

  final pendingLeaves = <LeaveModel>[].obs;
  final isLoading = true.obs;

  StreamSubscription<List<LeaveModel>>? _leaveSubscription;

  @override
  void onInit() {
    super.onInit();

    _leaveSubscription = _leaveRepository
        .getPendingLeaves()
        .listen((leaves) {
      pendingLeaves.assignAll(leaves);
      isLoading.value = false;
    });
  }

  Future<void> updateLeaveStatus(
      String leaveId,
      String status,
      ) async {
    try {
      await _leaveRepository.updateLeaveStatus(
        leaveId,
        status,
      );

      Get.snackbar(
        'Success',
        status == 'approved'
            ? 'Leave approved.'
            : 'Leave rejected.',
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to update leave request.',
      );
    }
  }

  @override
  void onClose() {
    _leaveSubscription?.cancel();
    super.onClose();
  }
}