import 'package:get/get.dart';

import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;

  AuthController({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  final isLoading = false.obs;
  final obscurePassword = true.obs;

  final email = ''.obs;
  final password = ''.obs;

  UserModel? currentUser;

  Future<void> login() async {
    if (email.value.trim().isEmpty || password.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter email and password.',
      );
      return;
    }

    try {
      isLoading.value = true;

      final user = await _authRepository.login(
        email.value,
        password.value,
      );

      currentUser = user;

      if (user.role == 'employee') {
        Get.offAllNamed('/employee');
      } else if (user.role == 'approver') {
        Get.offAllNamed('/approver');
      } else {
        Get.snackbar(
          'Access Denied',
          'Invalid user role.',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> logout() async {
    await _authRepository.logout();
    currentUser = null;
    Get.offAllNamed('/login');
  }
}