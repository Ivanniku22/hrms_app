import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static const String _databaseName = 'hrms.db';
  static const int _databaseVersion = 1;

  static const String attendanceTable = 'attendance';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(
      databasePath,
      _databaseName,
    );

    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $attendanceTable (
            id TEXT PRIMARY KEY,
            userId TEXT NOT NULL,
            date TEXT NOT NULL,
            checkInTime TEXT,
            checkOutTime TEXT,
            status TEXT NOT NULL,
            siteId TEXT,
            siteName TEXT,
            latitude REAL,
            longitude REAL,
            selfiePath TEXT,
            synced INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
  }

  Future<int> insertAttendance(
      Map<String, dynamic> data,
      ) async {
    final db = await database;

    return db.insert(
      attendanceTable,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAttendanceByUser(
      String userId,
      ) async {
    final db = await database;

    return db.query(
      attendanceTable,
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );
  }

  Future<Map<String, dynamic>?> getAttendanceByDate(
      String userId,
      String date,
      ) async {
    final db = await database;

    final result = await db.query(
      attendanceTable,
      where: 'userId = ? AND date = ?',
      whereArgs: [userId, date],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first;
  }

  Future<int> updateCheckOutTime(
      String id,
      String checkOutTime,
      ) async {
    final db = await database;

    return db.update(
      attendanceTable,
      {
        'checkOutTime': checkOutTime,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getUnsyncedAttendance() async {
    final db = await database;

    return db.query(
      attendanceTable,
      where: 'synced = ?',
      whereArgs: [0],
    );
  }

  Future<int> markAttendanceAsSynced(String id) async {
    final db = await database;

    return db.update(
      attendanceTable,
      {'synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}