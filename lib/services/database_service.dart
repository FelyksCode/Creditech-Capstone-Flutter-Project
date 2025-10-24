import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/prediction_models.dart';

class DatabaseService {
  static Database? _database;
  static const String _dbName = 'creditech_app.db';
  static const String _tableName = 'user_settings';
  static const int _currentVersion = 2;  // Increment this when schema changes

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
    try {
      String path = join(await getDatabasesPath(), _dbName);
      
      return await openDatabase(
        path,
        version: _currentVersion,
        onCreate: _createTables,
        onUpgrade: _onUpgrade,
        onDowngrade: onDatabaseDowngradeDelete, // Handle downgrades safely
      );
    } catch (e) {
      // If database initialization fails, try to delete and recreate
      await _handleDatabaseError();
      rethrow;
    }
  }

  // Handle database errors by recreating the database
  Future<void> _handleDatabaseError() async {
    try {
      String path = join(await getDatabasesPath(), _dbName);
      await deleteDatabase(path);
      _database = null;
    } catch (e) {
      // If we can't delete the database, there's not much we can do
      print('Failed to delete corrupted database');
    }
  }

  // Create tables
  Future<void> _createTables(Database db, int version) async {
    // Create user settings table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT UNIQUE NOT NULL,
        notification_enabled INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Create predictions table
    await _createPredictionsTable(db);
  }

  Future<void> _createPredictionsTable(Database db) async {
    // Use CREATE TABLE IF NOT EXISTS to avoid conflicts
    await db.execute('''
      CREATE TABLE IF NOT EXISTS predictions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        transaction_amount REAL NOT NULL,
        account_balance REAL NOT NULL,
        age INTEGER NOT NULL,
        device_type_mobile INTEGER NOT NULL,
        is_fraud INTEGER NOT NULL,
        probability REAL NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');
  }

  // Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Create predictions table if upgrading from version 1
      await _createPredictionsTable(db);
    }
    // Add future version upgrades here
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

  // Store a prediction result
  Future<int> savePrediction(TransactionPrediction prediction) async {
    final db = await database;
    return await db.insert(
      'predictions',
      {
        'transaction_amount': prediction.transactionAmount,
        'account_balance': prediction.accountBalance,
        'age': prediction.age,
        'device_type_mobile': prediction.deviceTypeMobile,
        'is_fraud': prediction.isFraud,
        'probability': prediction.probability,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // Get all predictions
  Future<List<TransactionPrediction>> getAllPredictions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'predictions',
      orderBy: 'timestamp DESC',
    );

    return List.generate(maps.length, (i) {
      return TransactionPrediction(
        transactionAmount: maps[i]['transaction_amount'],
        accountBalance: maps[i]['account_balance'],
        age: maps[i]['age'],
        deviceTypeMobile: maps[i]['device_type_mobile'],
        isFraud: maps[i]['is_fraud'],
        probability: maps[i]['probability'],
        timestamp: maps[i]['timestamp'],
      );
    });
  }

  // Delete all predictions
  Future<int> clearPredictions() async {
    final db = await database;
    return await db.delete('predictions');
  }
}