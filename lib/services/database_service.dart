import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;
  static const String _dbName = 'creditech_app.db';
  static const String _tableName = 'user_settings';

  // Singleton pattern
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  // Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  // Create tables
  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT UNIQUE NOT NULL,
        notification_enabled INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
  }

  // Insert or update notification setting
  Future<void> saveNotificationSetting({
    required String userId,
    required bool isEnabled,
  }) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    await db.insert(
      _tableName,
      {
        'user_id': userId,
        'notification_enabled': isEnabled ? 1 : 0,
        'created_at': now,
        'updated_at': now,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get notification setting for user
  Future<bool?> getNotificationSetting(String userId) async {
    final db = await database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'user_id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return maps.first['notification_enabled'] == 1;
    }
    return null; // No setting found, use default
  }

  // Update notification setting
  Future<void> updateNotificationSetting({
    required String userId,
    required bool isEnabled,
  }) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    await db.update(
      _tableName,
      {
        'notification_enabled': isEnabled ? 1 : 0,
        'updated_at': now,
      },
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  // Delete user settings (when user logs out permanently)
  Future<void> deleteUserSettings(String userId) async {
    final db = await database;
    
    await db.delete(
      _tableName,
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  // Close database
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  // Get all user settings (for debugging)
  Future<List<Map<String, dynamic>>> getAllSettings() async {
    final db = await database;
    return await db.query(_tableName);
  }
}