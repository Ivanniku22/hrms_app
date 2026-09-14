import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/attendance_controller.dart';

class SelfieView extends StatefulWidget {
  const SelfieView({super.key});

  @override
  State<SelfieView> createState() => _SelfieViewState();
}

class _SelfieViewState extends State<SelfieView> {
  final controller = Get.find<AttendanceController>();

  bool isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      await controller.initializeCamera();
    } catch (e) {
      Get.snackbar(
        'Camera Error',
        e.toString().replaceFirst('Exception: ', ''),
      );
      Get.back();
      return;
    }

    if (mounted) {
      setState(() {
        isInitializing = false;
      });
    }
  }

  @override
  void dispose() {
    controller.disposeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cameraController = controller.cameraController.value;

    if (isInitializing || cameraController == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Take Selfie'),
      ),
      body: Column(
        children: [
          Expanded(
            child: CameraPreview(cameraController),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: controller.captureSelfie,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Take Selfie'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}