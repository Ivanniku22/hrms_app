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
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Obx(
            () {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final user = controller.user.value;

          if (user == null) {
            return const Center(
              child: Text('Profile not found.'),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _profileItem(
                'Name',
                user.name,
              ),
              _profileItem(
                'Designation',
                _value(user.designation),
              ),
              _profileItem(
                'Department',
                _value(user.department),
              ),
              _profileItem(
                'Manager',
                _value(user.manager),
              ),
              _profileItem(
                'Contact',
                _value(user.contact),
              ),
              _profileItem(
                'Site',
                _value(user.site),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _profileItem(String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}