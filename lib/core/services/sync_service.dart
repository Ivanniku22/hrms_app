import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'database_service.dart';
import 'firebase_service.dart';
import 'connectivity_service.dart';

class SyncService {
  final DatabaseService _databaseService;
  final FirebaseService _firebaseService;
  final ConnectivityService _connectivityService;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  SyncService(
      this._databaseService,
      this._firebaseService,
      this._connectivityService,
      );

  void startListening() {
    _connectivitySubscription =
        _connectivityService.onConnectivityChanged.listen(
              (results) {
            final isConnected = results.any(
                  (result) => result != ConnectivityResult.none,
            );

            if (isConnected) {
              syncAttendance();
            }
          },
        );

    // Check connectivity immediately when the app starts.
    _checkInitialConnection();
  }

  Future<void> _checkInitialConnection() async {
    final isConnected = await _connectivityService.isConnected;

    if (isConnected) {
      syncAttendance();
    }
  }

  Future<void> syncAttendance() async {
    final records = await _databaseService.getUnsyncedAttendance();

    print('SYNC: Unsynced records = ${records.length}');

    if (records.isEmpty) {
      return;
    }

    for (final record in records) {
      print('SYNC: Uploading attendance ${record['id']}');

      final userId = record['userId'] as String;
      final attendanceId = record['id'] as String;

      final firestoreData = Map<String, dynamic>.from(record);

      // These fields are only for local storage.
      firestoreData.remove('selfiePath');
      firestoreData.remove('synced');

      await _firebaseService.firestore
          .collection('users')
          .doc(userId)
          .collection('attendance')
          .doc(attendanceId)
          .set(firestoreData);

      print('SYNC: Firestore upload successful for $attendanceId');

      await _databaseService.markAttendanceAsSynced(
        attendanceId,
      );
    }
  }


  void dispose() {
    _connectivitySubscription?.cancel();
  }
}