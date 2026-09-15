import 'dart:async';

import 'package:get/get.dart';

import '../../../../data/models/leave_model.dart';
import '../../../../data/repositories/leave_repository.dart';

class LeaveApprovalController extends GetxController {
  final LeaveRepository _leaveRepository;

  LeaveApprovalController(this._leaveRepository);

  final pendingLeaves = <LeaveModel>[].obs;

  StreamSubscription<List<LeaveModel>>? _leaveSubscription;

  @override
  void onInit() {
    super.onInit();

    _leaveSubscription = _leaveRepository
        .getPendingLeaves()
        .listen((leaves) {
      pendingLeaves.assignAll(leaves);
    });
  }

  @override
  void onClose() {
    _leaveSubscription?.cancel();
    super.onClose();
  }
}