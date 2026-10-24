import 'package:path/path.dart';
import 'package:prompt_vault/core/database/prompt_table.dart';
import 'package:sqflite/sqflite.dart';

/// Opens and versions the local SQLite database.
class AppDatabase {
  AppDatabase._();

  /// Increment when [onUpgrade] migrations are added.
  static const int version = 1;

  static const String databaseFileName = 'prompt_vault.db';

  static Database? _database;

  static Future<Database> open({String? databasePath}) async {
    if (_database != null && _database!.isOpen) {
      return _database!;
    }

    final path =
        databasePath ?? join(await getDatabasesPath(), databaseFileName);

    _database = await openDatabase(
      path,
      version: version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return _database!;
  }

  static Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  /// In-memory database for unit tests (does not use the app singleton).
  static Future<Database> openInMemory() {
    return openDatabase(
      inMemoryDatabasePath,
      version: version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute(PromptTable.createSql);
  }

  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // Add migrations here when [version] increases.
  }
}
