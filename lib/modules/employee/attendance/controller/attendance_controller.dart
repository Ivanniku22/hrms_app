import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/services/camera_service.dart';
import '../../../../core/services/location_service.dart';
import '../../../../data/models/attendance_model.dart';
import '../../../../data/repositories/attendance_repository.dart';
import '../../../../data/repositories/site_repository.dart';
import '../../../auth/controller/auth_controller.dart';
import 'package:flutter/foundation.dart';


class AttendanceController extends GetxController {
  final AttendanceRepository _attendanceRepository;
  final SiteRepository _siteRepository;
  final LocationService _locationService;
  final CameraService _cameraService;
  final AuthController _authController;

  final cameraController = Rxn<CameraController>();
  final capturedSelfie = Rxn<XFile>();
  final attendanceHistory = <AttendanceModel>[].obs;
  final selectedMonth = DateTime.now().month.obs;
  final selectedYear = DateTime.now().year.obs;

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

  @override
  void onInit() {
    super.onInit();
    loadTodayAttendance();
    loadAttendanceHistory();
  }

  final isLoading = false.obs;
  final isCheckingIn = false.obs;

  final hasCheckedInToday = false.obs;
  final hasCheckedOutToday = false.obs;

  final isLocationVerified = false.obs;
  final isSelfieVerified = false.obs;

  final verifiedLatitude = RxnDouble();
  final verifiedLongitude = RxnDouble();
  final verifiedSiteId = RxnString();
  final verifiedSiteName = RxnString();

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

      verifiedLatitude.value = position.latitude;
      verifiedLongitude.value = position.longitude;
      verifiedSiteId.value = site.id;
      verifiedSiteName.value = site.name;

      isLocationVerified.value = true;
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

      isSelfieVerified.value = true;

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

  Future<void> checkIn() async {
    if (!isLocationVerified.value || !isSelfieVerified.value) {
      Get.snackbar(
        'Verification Required',
        'Please complete location and selfie verification first.',
      );
      return;
    }

    final user = _authController.currentUser;

    if (user == null) {
      Get.snackbar(
        'Error',
        'User session not found.',
      );
      return;
    }

    final selfie = capturedSelfie.value;

    if (selfie == null) {
      Get.snackbar(
        'Selfie Required',
        'Please capture and verify your selfie first.',
      );
      return;
    }

    final today = DateTime.now().toIso8601String().split('T').first;

    try {
      isLoading.value = true;

      final existingAttendance =
      await _attendanceRepository.getAttendanceByDate(
        user.uid,
        today,
      );

      if (existingAttendance != null) {
        Get.snackbar(
          'Already Checked In',
          'You have already checked in today.',
        );
        return;
      }

      final now = DateTime.now();

      final attendance = AttendanceModel(
        id: const Uuid().v4(),
        userId: user.uid,
        date: today,
        checkInTime: now.toIso8601String(),
        checkOutTime: null,
        status: 'present',
        siteId: verifiedSiteId.value,
        siteName: verifiedSiteName.value,
        latitude: verifiedLatitude.value,
        longitude: verifiedLongitude.value,
        selfiePath: selfie.path,
        synced: false,
      );

      await _attendanceRepository.saveAttendance(attendance);

      Get.snackbar(
        'Check In Successful',
        'Your attendance has been registered.',
      );
    } catch (e) {
      Get.snackbar(
        'Check In Failed',
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkOut() async {
    final user = _authController.currentUser;

    if (user == null) {
      Get.snackbar(
        'Error',
        'User session not found.',
      );
      return;
    }

    try {
      isLoading.value = true;

      final today = DateTime.now().toIso8601String().split('T').first;

      final attendance =
      await _attendanceRepository.getAttendanceByDate(
        user.uid,
        today,
      );

      if (attendance == null) {
        Get.snackbar(
          'Check Out Failed',
          'No check-in record found for today.',
        );
        return;
      }

      if (attendance.checkOutTime != null) {
        Get.snackbar(
          'Already Checked Out',
          'You have already checked out today.',
        );
        return;
      }

      final checkOutTime = DateTime.now().toIso8601String();

      await _attendanceRepository.updateCheckOutTime(
        attendance.id,
        checkOutTime,
      );

      Get.snackbar(
        'Check Out Successful',
        'Your attendance has been completed.',
      );
    } catch (e) {
      Get.snackbar(
        'Check Out Failed',
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadTodayAttendance() async {
    final user = _authController.currentUser;

    if (user == null) {
      return;
    }

    final today = DateTime.now().toIso8601String().split('T').first;

    final attendance =
    await _attendanceRepository.getAttendanceByDate(
      user.uid,
      today,
    );

    if (attendance == null) {
      hasCheckedInToday.value = false;
      hasCheckedOutToday.value = false;
      return;
    }

    hasCheckedInToday.value = true;
    hasCheckedOutToday.value = attendance.checkOutTime != null;

    isLocationVerified.value = true;
    isSelfieVerified.value = true;

    verifiedLatitude.value = attendance.latitude;
    verifiedLongitude.value = attendance.longitude;
    verifiedSiteId.value = attendance.siteId;
    verifiedSiteName.value = attendance.siteName;
  }

  Future<void> loadAttendanceHistory() async {
    final user = _authController.currentUser;

    if (user == null) {
      return;
    }

    try {
      isLoading.value = true;

      final records =
      await _attendanceRepository.getAttendanceByUser(user.uid);

      attendanceHistory.assignAll(records);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to load attendance history.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<AttendanceModel> get filteredAttendanceHistory {
    return attendanceHistory.where((attendance) {
      final date = DateTime.tryParse(attendance.date);

      if (date == null) {
        return false;
      }

      return date.month == selectedMonth.value &&
          date.year == selectedYear.value;
    }).toList();
  }
}