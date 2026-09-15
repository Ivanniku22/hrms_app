import 'package:get/get.dart';

import '../../../../data/repositories/profile_repository.dart';
import '../../../auth/controller/auth_controller.dart';
import '../controller/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
          () => ProfileController(
        Get.find<ProfileRepository>(),
        Get.find<AuthController>(),
      ),
    );
  }
}