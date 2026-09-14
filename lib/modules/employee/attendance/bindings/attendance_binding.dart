import 'package:get/get.dart';

import '../../../../core/services/location_service.dart';
import '../../../../data/repositories/attendance_repository.dart';
import '../../../../data/repositories/site_repository.dart';
import '../controller/attendance_controller.dart';

class AttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendanceController>(
          () => AttendanceController(
        attendanceRepository: Get.find<AttendanceRepository>(),
        siteRepository: Get.find<SiteRepository>(),
        locationService: Get.find<LocationService>(),
      ),
    );
  }
}