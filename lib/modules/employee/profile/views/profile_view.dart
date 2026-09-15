import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  String _value(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'N/A';
    }

    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF2563EB)),
          );
        }

        final user = controller.user.value;

        if (user == null) {
          return const Center(
            child: Text(
              'Profile not found.',
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          children: [
            // Profile header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 38,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    user.name.isNotEmpty ? user.name : 'Employee',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _value(user.designation),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Employee Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Your employee information from the HR system.',
              style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),

            const SizedBox(height: 18),

            _profileItem(
              icon: Icons.person_outline_rounded,
              title: 'Name',
              value: _value(user.name),
            ),
            _profileItem(
              icon: Icons.work_outline_rounded,
              title: 'Designation',
              value: _value(user.designation),
            ),
            _profileItem(
              icon: Icons.business_outlined,
              title: 'Department',
              value: _value(user.department),
            ),
            _profileItem(
              icon: Icons.supervisor_account_outlined,
              title: 'Manager',
              value: _value(user.manager),
            ),
            _profileItem(
              icon: Icons.phone_outlined,
              title: 'Contact',
              value: _value(user.contact),
            ),
            _profileItem(
              icon: Icons.location_on_outlined,
              title: 'Site',
              value: _value(user.site),
            ),
          ],
        );
      }),
    );
  }

  Widget _profileItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: const Color(0xFF2563EB), size: 23),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
