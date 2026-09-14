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

  Future<AttendanceModel?> getAttendanceByDate(
      String userId,
      String date,
      ) async {
    final data = await _databaseService.getAttendanceByDate(
      userId,
      date,
    );

    if (data == null) {
      return null;
    }

    return AttendanceModel.fromMap(data);
  }

  Future<void> updateCheckOutTime(
      String id,
      String checkOutTime,
      ) async {
    await _databaseService.updateCheckOutTime(
      id,
      checkOutTime,
    );
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