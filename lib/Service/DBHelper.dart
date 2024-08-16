import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'app_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY,
            username TEXT NOT NULL,
            password TEXT NOT NULL,
            email TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE employees (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            email TEXT NOT NULL,
            phone TEXT,
            designation TEXT,
            attendance TEXT
          )
        ''');

        // Insert demo data into the employees table
        await _insertDemoData(db);
      },
    );
  }

  Future<void> _insertDemoData(Database db) async {
    // Check if the employees table is empty before inserting demo data
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM employees'));
    if (count == 0) {
      await db.insert('employees', {
        'username': 'Alice',
        'email': 'alice@example.com',
        'phone': '1234567890',
        'designation': 'Developer',
        'attendance': 'Present'
      });

      await db.insert('employees', {
        'username': 'Bob',
        'email': 'bob@example.com',
        'phone': '0987654321',
        'designation': 'Developer',
        'attendance': 'Present'
      });

      await db.insert('employees', {
        'username': 'Charlie',
        'email': 'charlie@example.com',
        'phone': '1112223333',
        'designation': 'Manager',
        'attendance': 'Present'
      });

      await db.insert('employees', {
        'username': 'David',
        'email': 'david@example.com',
        'phone': '4445556666',
        'designation': 'Manager',
        'attendance': 'Absent'
      });

      await db.insert('employees', {
        'username': 'Eve',
        'email': 'eve@example.com',
        'phone': '7778889999',
        'designation': 'Business Analyst',
        'attendance': 'Present'
      });

      await db.insert('employees', {
        'username': 'Frank',
        'email': 'frank@example.com',
        'phone': '0001112222',
        'designation': 'Business Analyst',
        'attendance': 'Absent'
      });
    }
  }

  // Existing user-related methods

  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }

  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert(
      'users',
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // New employee-related methods

  Future<void> insertEmployee(Map<String, dynamic> employee) async {
    final db = await database;
    await db.insert(
      'employees',
      employee,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getEmployeesByDesignation(String designation) async {
    final db = await database;
    return await db.query(
      'employees',
      where: 'designation = ?',
      whereArgs: [designation],
    );
  }

  Future<List<Map<String, dynamic>>> getAllEmployees() async {
    final db = await database;
    return await db.query('employees');
  }
  Future<void> updateAttendance(int employeeId, String status) async {
    final db = await database;
    await db.update(
      'employees',
      {'attendance': status},
      where: 'id = ?',
      whereArgs: [employeeId],
    );
  }
}
