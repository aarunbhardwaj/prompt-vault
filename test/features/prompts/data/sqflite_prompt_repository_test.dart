import 'package:flutter_test/flutter_test.dart';
import 'package:prompt_vault/core/database/app_database.dart';
import 'package:prompt_vault/core/database/prompt_table.dart';
import 'package:prompt_vault/features/prompts/data/sqflite_prompt_repository.dart';
import 'package:prompt_vault/features/prompts/domain/prompt.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late Database db;
  late SqflitePromptRepository repository;

  setUp(() async {
    db = await openDatabase(
      inMemoryDatabasePath,
      version: AppDatabase.version,
      onCreate: (database, version) async {
        await database.execute(PromptTable.createSql);
      },
      singleInstance: false,
    );
    repository = SqflitePromptRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  Prompt sample({String id = '1', String title = 'Hello', String body = 'World'}) {
    final now = DateTime.utc(2026, 1, 1);
    return Prompt(
      id: id,
      title: title,
      body: body,
      createdAt: now,
      updatedAt: now,
    );
  }

  test('create and getById', () async {
    final p = sample();
    await repository.create(p);
    expect(await repository.getById('1'), p);
  });

  test('getAll orders by updatedAt desc', () async {
    await repository.create(sample(id: '1', title: 'A'));
    await repository.create(
      sample(id: '2', title: 'B').copyWith(
        updatedAt: DateTime.utc(2026, 2, 1),
      ),
    );
    final all = await repository.getAll();
    expect(all.map((e) => e.id).toList(), ['2', '1']);
  });

  test('search matches title or body case-insensitively', () async {
    await repository.create(sample(title: 'Flutter', body: 'x'));
    await repository.create(sample(id: '2', title: 'x', body: 'Riverpod'));
    final results = await repository.search('river');
    expect(results.length, 1);
    expect(results.first.id, '2');
  });

  test('toggleFavorite and delete', () async {
    await repository.create(sample());
    final toggled = await repository.toggleFavorite('1');
    expect(toggled.isFavorite, isTrue);
    await repository.delete('1');
    expect(await repository.getById('1'), isNull);
  });
}
