import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
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
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: selfie == null
                      ? ElevatedButton.icon(
                    onPressed: controller.captureSelfie,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take Selfie'),
                  )
                      : ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('Continue'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}