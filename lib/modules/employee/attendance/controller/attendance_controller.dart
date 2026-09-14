import 'package:get/get.dart';

import '../../../../core/services/location_service.dart';
import '../../../../data/repositories/attendance_repository.dart';
import '../../../../data/repositories/site_repository.dart';
import '../../../auth/controller/auth_controller.dart';

class AttendanceController extends GetxController {
  final AttendanceRepository _attendanceRepository;
  final SiteRepository _siteRepository;
  final LocationService _locationService;
  final AuthController _authController;

  AttendanceController({
    required AttendanceRepository attendanceRepository,
    required SiteRepository siteRepository,
    required LocationService locationService,
    required AuthController authController,
  })
      : _attendanceRepository = attendanceRepository,
        _siteRepository = siteRepository,
        _locationService = locationService,
        _authController = authController;

  final isLoading = false.obs;
  final isCheckingIn = false.obs;

  Future<void> checkLocation() async {
    try {
      isLoading.value = true;

      final user = _authController.currentUser;

      if (user == null) {
        Get.snackbar(
          'Error',
          'User session not found.',
        );
        return;
      }

      final siteId = user.siteId;

      if (siteId == null || siteId.isEmpty) {
        Get.snackbar(
          'Error',
          'No site is assigned to this employee.',
        );
        return;
      }

      final site = await _siteRepository.getSiteById(siteId);

      final position = await _locationService.getCurrentLocation();

      final isWithinSite = _locationService.isWithinRadius(
        userLatitude: position.latitude,
        userLongitude: position.longitude,
        siteLatitude: site.latitude,
        siteLongitude: site.longitude,
        radius: site.radius,
      );

      if (!isWithinSite) {
        Get.snackbar(
          'Outside Site',
          'You are outside the allowed attendance location.',
        );
        return;
      }

      Get.snackbar(
        'Location Verified',
        'You are within the ${site.name} attendance area.',
      );
    } catch (e) {
      print('LOCATION ERROR: $e');

      Get.snackbar(
        'Location Error',
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isLoading.value = false;
    }
  }


}