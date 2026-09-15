import 'package:get/get.dart';

import '../../core/services/camera_service.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/services/database_service.dart';
import '../../core/services/firebase_service.dart';
import '../../core/services/location_service.dart';
import '../../core/services/sync_service.dart';
import '../../data/repositories/attendance_repository.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/leave_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/repositories/site_repository.dart';
import '../../modules/auth/controller/auth_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<FirebaseService>(
      FirebaseService(),
      permanent: true,
    );

    Get.put<LeaveRepository>(
      LeaveRepository(
        Get.find<FirebaseService>().firestore,
      ),
    );

    Get.put<ProfileRepository>(
      ProfileRepository(
        Get.find<FirebaseService>().firestore,
      ),
    );

    Get.put<DatabaseService>(
      DatabaseService(),
      permanent: true,
    );

    Get.put<AttendanceRepository>(
      AttendanceRepository(
        Get.find<DatabaseService>(),
      ),
    );

    Get.put<ConnectivityService>(
      ConnectivityService(),
    );

    Get.put<SyncService>(
      SyncService(
        Get.find<DatabaseService>(),
        Get.find<FirebaseService>(),
        Get.find<ConnectivityService>(),
      ),
    );

    Get.find<SyncService>().startListening();


    Get.put<LocationService>(
      LocationService(),
      permanent: true,
    );

    Get.put<CameraService>(
      CameraService(),
      permanent: true,
    );

    Get.put<AuthRepository>(
      AuthRepository(
        firebaseService: Get.find<FirebaseService>(),
      ),
      permanent: true,
    );

    Get.put<SiteRepository>(
      SiteRepository(
        firebaseService: Get.find<FirebaseService>(),
      ),
      permanent: true,
    );

    Get.put<AuthController>(
      AuthController(
        authRepository: Get.find<AuthRepository>(),
      ),
      permanent: true,
    );

  }
}