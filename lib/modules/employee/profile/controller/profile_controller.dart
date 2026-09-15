import 'package:get/get.dart';

import '../../../../data/models/user_model.dart';
import '../../../../data/repositories/profile_repository.dart';
import '../../../auth/controller/auth_controller.dart';

class ProfileController extends GetxController {
  final ProfileRepository _profileRepository;
  final AuthController _authController;

  ProfileController(
      this._profileRepository,
      this._authController,
      );

  final isLoading = false.obs;
  final user = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final currentUser = _authController.currentUser;

    if (currentUser == null) {
      return;
    }

    try {
      isLoading.value = true;

      final profile = await _profileRepository.getUserProfile(
        currentUser.uid,
      );

      user.value = profile;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to load profile.',
      );
    } finally {
      isLoading.value = false;
    }
  }
}