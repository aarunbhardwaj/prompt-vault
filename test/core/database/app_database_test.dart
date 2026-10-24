import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:prompt_vault/core/database/app_database.dart';
import 'package:prompt_vault/core/database/prompt_table.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('AppDatabase', () {
    tearDown(() async {
      await AppDatabase.close();
    });

    test('open twice returns same singleton database', () async {
      final dbPath = p.join(
        await getDatabasesPath(),
        'test_prompt_vault_${DateTime.now().microsecondsSinceEpoch}.db',
      );

      final db1 = await AppDatabase.open(databasePath: dbPath);
      final db2 = await AppDatabase.open(databasePath: dbPath);

      expect(identical(db1, db2), isTrue);

      await AppDatabase.close();
    });

    test('onCreate creates prompts table', () async {
      final db = await AppDatabase.openInMemory();
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
        [PromptTable.tableName],
      );
      expect(tables, isNotEmpty);
      await db.close();
    });
  });
}
