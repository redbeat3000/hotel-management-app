import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import '../models/attendance_model.dart';

class DBService {
  static final DBService _instance = DBService._internal();
  factory DBService() => _instance;
  DBService._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'hotel_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            username TEXT,
            phone TEXT,
            email TEXT,
            photoPath TEXT,
            password TEXT,
            role TEXT,
            lastLogin TEXT,
            paymentType TEXT,         -- 'wage' or 'salary'
            dailyRate REAL,           -- daily wage (nullable)
            monthlySalary REAL        -- fixed salary (nullable)
          )
        ''');

        await db.execute('''
          CREATE TABLE attendance (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            staffId INTEGER,
            checkInTime TEXT,
            checkOutTime TEXT,
            duration TEXT,
            date TEXT
          )
        ''');
      },
    );
  }

  // -------------------- User Methods --------------------

  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserModel?> loginAdmin(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ? AND role = ?',
      whereArgs: [username, password, 'admin'],
    );

    if (result.isNotEmpty) {
      final updatedUser = UserModel.fromMap(
        result.first,
      ).copyWith(lastLogin: DateTime.now().toIso8601String());
      await updateUser(updatedUser);
      return updatedUser;
    }
    return null;
  }

  Future<int> updateUser(UserModel user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<UserModel?> getAdminUser() async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'role = ?',
      whereArgs: ['admin'],
    );
    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }

  Future<List<UserModel>> getAllStaff() async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'role = ?',
      whereArgs: ['staff'],
    );
    return result.map((e) => UserModel.fromMap(e)).toList();
  }

  // -------------------- Attendance Methods --------------------

  Future<int> insertAttendance(AttendanceModel att) async {
    final db = await database;
    return await db.insert('attendance', att.toMap());
  }

  Future<List<AttendanceModel>> getAttendanceByDate(String date) async {
    final db = await database;
    final result = await db.query(
      'attendance',
      where: 'date = ?',
      whereArgs: [date],
    );
    return result.map((e) => AttendanceModel.fromMap(e)).toList();
  }

  Future<List<AttendanceModel>> getAllAttendance() async {
    final db = await database;
    final result = await db.query('attendance');
    return result.map((e) => AttendanceModel.fromMap(e)).toList();
  }
}
