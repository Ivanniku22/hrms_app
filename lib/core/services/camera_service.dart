import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class CameraService {
  CameraController? _controller;

  CameraController? get controller => _controller;

  Future<void> initialize() async {
    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        throw Exception('No camera is available on this device.');
      }

      final frontCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller!.initialize();
    } on CameraException catch (e) {
      _controller = null;

      if (e.code == 'CameraAccessDenied') {
        throw Exception(
          'Camera permission is denied. Please allow camera access in Settings.',
        );
      }

      throw Exception(
        'Unable to access the camera.',
      );
    } catch (e) {
      _controller = null;
      rethrow;
    }
  }

  Future<int> detectFaces(String imagePath) async {
    final inputImage = InputImage.fromFile(File(imagePath));

    final faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.accurate,
      ),
    );

    final faces = await faceDetector.processImage(inputImage);

    await faceDetector.close();

    return faces.length;
  }

  Future<String> saveSelfiePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();

    final fileName =
        'selfie_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final permanentPath = path.join(
      directory.path,
      fileName,
    );

    await File(imagePath).copy(permanentPath);

    return permanentPath;
  }

  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
  }
}