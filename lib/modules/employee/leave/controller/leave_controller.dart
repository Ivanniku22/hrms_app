import 'dart:async';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../../data/models/leave_model.dart';
import '../../../../data/repositories/leave_repository.dart';
import '../../../auth/controller/auth_controller.dart';

class LeaveController extends GetxController {
  final LeaveRepository _leaveRepository;
  final AuthController _authController;

  LeaveController(
      this._leaveRepository,
      this._authController,
      );


  final isLoading = false.obs;

  final leaveType = ''.obs;
  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();
  final reason = ''.obs;

  final leaveRequests = <LeaveModel>[].obs;

  StreamSubscription<List<LeaveModel>>? _leaveSubscription;

  @override
  void onInit() {
    super.onInit();
    loadLeaveRequests();
  }

  void loadLeaveRequests() {
    final user = _authController.currentUser;

    if (user == null) {
      return;
    }

    _leaveSubscription?.cancel();

    _leaveSubscription = _leaveRepository
        .getUserLeaves(user.uid)
        .listen((leaves) {
      leaveRequests.assignAll(leaves);
    });
  }

  Future<void> applyLeave() async {
    final user = _authController.currentUser;

    if (user == null) {
      return;
    }

    if (leaveType.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a leave type.',
      );
      return;
    }

    if (startDate.value == null || endDate.value == null) {
      Get.snackbar(
        'Error',
        'Please select the leave dates.',
      );
      return;
    }

    if (reason.value.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a reason.',
      );
      return;
    }

    if (endDate.value!.isBefore(startDate.value!)) {
      Get.snackbar(
        'Error',
        'End date cannot be before start date.',
      );
      return;
    }

    try {
      isLoading.value = true;

      final leave = LeaveModel(
        id: const Uuid().v4(),
        userId: user.uid,
        leaveType: leaveType.value,
        startDate: startDate.value!.toIso8601String(),
        endDate: endDate.value!.toIso8601String(),
        reason: reason.value.trim(),
        status: 'pending',
      );

      await _leaveRepository.applyLeave(leave);

      leaveType.value = '';
      startDate.value = null;
      endDate.value = null;
      reason.value = '';

      Get.snackbar(
        'Success',
        'Leave request submitted.',
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to submit leave request.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _leaveSubscription?.cancel();
    super.onClose();
  }
}