import 'package:camera/camera.dart';
import 'package:get/get.dart';
import '../../../../core/services/camera_service.dart';
import '../../../../core/services/location_service.dart';
import '../../../../data/repositories/attendance_repository.dart';
import '../../../../data/repositories/site_repository.dart';
import '../../../auth/controller/auth_controller.dart';

class AttendanceController extends GetxController {
  final AttendanceRepository _attendanceRepository;
  final SiteRepository _siteRepository;
  final LocationService _locationService;
  final CameraService _cameraService;
  final AuthController _authController;

  final cameraController = Rxn<CameraController>();
  final capturedSelfie = Rxn<XFile>();

  AttendanceController({
    required AttendanceRepository attendanceRepository,
    required SiteRepository siteRepository,
    required LocationService locationService,
    required CameraService cameraService,
    required AuthController authController,
  }) : _attendanceRepository = attendanceRepository,
        _siteRepository = siteRepository,
        _locationService = locationService,
        _cameraService = cameraService,
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

  Future<void> initializeCamera() async {
    await _cameraService.initialize();

    cameraController.value = _cameraService.controller;
  }

  Future<void> captureSelfie() async {
    final controller = cameraController.value;

    if (controller == null || !controller.value.isInitialized) {
      Get.snackbar(
        'Camera Error',
        'Camera is not ready.',
      );
      return;
    }

    try {
      capturedSelfie.value = await controller.takePicture();

      Get.snackbar(
        'Selfie Captured',
        'Selfie captured successfully.',
      );
    } catch (e) {
      Get.snackbar(
        'Camera Error',
        'Unable to capture selfie.',
      );
    }
  }

  Future<bool> validateSelfie() async {
    final selfie = capturedSelfie.value;

    if (selfie == null) {
      Get.snackbar(
        'Selfie Required',
        'Please take a selfie first.',
      );
      return false;
    }

    try {
      isLoading.value = true;

      final faceCount = await _cameraService.detectFaces(
        selfie.path,
      );

      if (faceCount == 0) {
        Get.snackbar(
          'No Face Detected',
          'Please take a selfie with your face clearly visible.',
        );
        return false;
      }

      if (faceCount > 1) {
        Get.snackbar(
          'Multiple Faces',
          'Only one person should be visible in the selfie.',
        );
        return false;
      }

      Get.snackbar(
        'Selfie Verified',
        'Exactly one face was detected.',
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Face Detection Error',
        'Unable to verify the selfie.',
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }


  void retakeSelfie() {
    capturedSelfie.value = null;
  }


  void clearCapturedSelfie() {
    capturedSelfie.value = null;
  }

  Future<void> disposeCamera() async {
    await _cameraService.dispose();
    cameraController.value = null;
  }
}