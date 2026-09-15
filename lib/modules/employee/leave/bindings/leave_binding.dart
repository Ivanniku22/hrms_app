import 'package:get/get.dart';

import '../../../../data/repositories/leave_repository.dart';
import '../../../auth/controller/auth_controller.dart';
import '../controller/leave_controller.dart';

class LeaveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeaveController>(
          () => LeaveController(
        Get.find<LeaveRepository>(),
        Get.find<AuthController>(),
      ),
    );
  }
}