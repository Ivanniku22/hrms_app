import 'package:get/get.dart';

import '../../modules/approver/dashboard/views/approver_dashboard_view.dart';
import '../../modules/auth/bindings/auth_binding.dart';
import '../../modules/auth/views/auth_gate_view.dart';
import '../../modules/auth/views/login_view.dart';
import '../../modules/employee/attendance/bindings/attendance_binding.dart';
import '../../modules/employee/attendance/views/attendance_history_view.dart';
import '../../modules/employee/attendance/views/attendance_view.dart';
import '../../modules/employee/attendance/views/selfie_view.dart';
import '../../modules/employee/dashboard/views/employee_dashboard_view.dart';
import '../../modules/employee/leave/bindings/leave_binding.dart';
import '../../modules/employee/leave/views/leave_view.dart';
import '../../modules/employee/profile/bindings/profile_binding.dart';
import '../../modules/employee/profile/views/profile_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage>[

    GetPage(
      name: '/',
      page: () => const AuthGateView(),
    ),


    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),

    GetPage(
      name: AppRoutes.employee,
      page: () => const EmployeeDashboardView(),
    ),

    GetPage(
      name: AppRoutes.attendance,
      page: () => const AttendanceView(),
      binding: AttendanceBinding(),
    ),

    GetPage(
      name: AppRoutes.selfie,
      page: () => const SelfieView(),
    ),

    GetPage(
      name: AppRoutes.attendanceHistory,
      page: () => const AttendanceHistoryView(),
      binding: AttendanceBinding(),
    ),

    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),

    GetPage(
      name: AppRoutes.leave,
      page: () => LeaveView(),
      binding: LeaveBinding(),
    ),

    GetPage(
      name: AppRoutes.approver,
      page: () => const ApproverDashboardView(),
    ),
  ];
}