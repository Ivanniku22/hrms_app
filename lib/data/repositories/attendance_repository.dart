import '../../core/services/database_service.dart';
import '../models/attendance_model.dart';

class AttendanceRepository {
  final DatabaseService _databaseService;

  AttendanceRepository({
    required DatabaseService databaseService,
  }) : _databaseService = databaseService;

  Future<void> saveAttendance(AttendanceModel attendance) async {
    await _databaseService.insertAttendance(
      attendance.toMap(),
    );
  }

  Future<List<AttendanceModel>> getAttendanceByUser(
      String userId,
      ) async {
    final records = await _databaseService.getAttendanceByUser(
      userId,
    );

    return records
        .map(AttendanceModel.fromMap)
        .toList();
  }

  Future<List<AttendanceModel>> getUnsyncedAttendance() async {
    final records =
    await _databaseService.getUnsyncedAttendance();

    return records
        .map(AttendanceModel.fromMap)
        .toList();
  }

  Future<void> markAsSynced(String id) async {
    await _databaseService.markAttendanceAsSynced(id);
  }
}