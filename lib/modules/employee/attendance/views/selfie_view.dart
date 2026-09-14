import 'dart:io';

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

    controller.clearCapturedSelfie();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      await controller.initializeCamera();

      if (mounted) {
        setState(() {
          isInitializing = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      Get.snackbar(
        'Camera Error',
        e.toString().replaceFirst('Exception: ', ''),
      );

      Get.back();
    }
  }

  @override
  void dispose() {
    controller.disposeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take Selfie'),
      ),
      body: Obx(
            () {
          final cameraController = controller.cameraController.value;
          final selfie = controller.capturedSelfie.value;

          if (isInitializing || cameraController == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              Expanded(
                child: selfie == null
                    ? CameraPreview(cameraController)
                    : Image.file(
                  File(selfie.path),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: selfie == null
                    ? SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: controller.captureSelfie,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take Selfie'),
                  ),
                )
                    : Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: controller.retakeSelfie,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retake'),
                      ),
                    ),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final isValid = await controller.validateSelfie();

                          if (!isValid || !mounted) return;

                          Get.offNamed('/employee/attendance');
                        },
                        child: const Text('Continue'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}