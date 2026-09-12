import 'package:get/get.dart';

import '../../../data/repositories/auth_repository.dart';
import '../controller/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(
          () => AuthRepository(),
    );

    Get.lazyPut<AuthController>(
          () => AuthController(
        authRepository: Get.find<AuthRepository>(),
      ),
    );
  }
}