import 'package:get/get.dart';

import '../../../../core/services/location_service.dart';
import '../../../../data/repositories/attendance_repository.dart';
import '../../../../data/repositories/site_repository.dart';

class AttendanceController extends GetxController {
  final AttendanceRepository _attendanceRepository;
  final SiteRepository _siteRepository;
  final LocationService _locationService;

  AttendanceController({
    required AttendanceRepository attendanceRepository,
    required SiteRepository siteRepository,
    required LocationService locationService,
  })  : _attendanceRepository = attendanceRepository,
        _siteRepository = siteRepository,
        _locationService = locationService;

  final isLoading = false.obs;
  final isCheckingIn = false.obs;

// We'll add attendance logic here next.
}