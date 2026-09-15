import 'package:get/get.dart';

import '../../../../data/repositories/leave_repository.dart';
import '../controller/leave_approval_controller.dart';

class LeaveApprovalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeaveApprovalController>(
          () => LeaveApprovalController(
        Get.find<LeaveRepository>(),
      ),
    );
  }
}