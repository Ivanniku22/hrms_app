import '../../core/services/database_service.dart';
import '../models/attendance_model.dart';

class AttendanceRepository {
  final DatabaseService _databaseService;

  AttendanceRepository(this._databaseService);

  Future<void> saveAttendance(AttendanceModel attendance) async {
    await _databaseService.insertAttendance(
      attendance.toMap(),
    );
  }

  Future<List<AttendanceModel>> getAttendanceByUser(
      String userId,
      ) async {
    final data = await _databaseService.getAttendanceByUser(userId);

    return data
        .map((item) => AttendanceModel.fromMap(item))
        .toList();
  }

  Future<List<AttendanceModel>> getUnsyncedAttendance() async {
    final data = await _databaseService.getUnsyncedAttendance();

    return data
        .map((item) => AttendanceModel.fromMap(item))
        .toList();
  }

  Future<void> markAsSynced(String id) async {
    await _databaseService.markAttendanceAsSynced(id);
  }
}