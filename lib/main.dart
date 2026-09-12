import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const HRMSApp());
}

class HRMSApp extends StatelessWidget {
  const HRMSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HRMS',
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(
          child: Text('HRMS App'),
        ),
      ),
    );
  }
}