import 'package:get/get.dart';

import '../../modules/approver/dashboard/views/approver_dashboard_view.dart';
import '../../modules/auth/bindings/auth_binding.dart';
import '../../modules/auth/views/login_view.dart';
import '../../modules/employee/dashboard/views/employee_dashboard_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage>[
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
      name: AppRoutes.approver,
      page: () => const ApproverDashboardView(),
    ),
  ];
}