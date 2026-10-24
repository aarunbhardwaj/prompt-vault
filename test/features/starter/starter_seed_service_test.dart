import 'package:flutter_test/flutter_test.dart';
import 'package:prompt_vault/core/database/app_database.dart';
import 'package:prompt_vault/core/database/prompt_table.dart';
import 'package:prompt_vault/features/prompts/data/sqflite_prompt_repository.dart';
import 'package:prompt_vault/features/prompts/domain/prompt.dart';
import 'package:prompt_vault/features/starter/data/starter_seed_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late Database db;
  late SqflitePromptRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
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

  final sampleStarters = [
    Prompt(
      id: 'starter-1',
      title: 'A',
      body: 'Body',
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    ),
  ];

  test('runFirstLaunchSeed inserts once and sets flag', () async {
    final prefs = await SharedPreferences.getInstance();

    await runFirstLaunchSeed(
      prefs: prefs,
      repository: repository,
      loadPrompts: () async => sampleStarters,
    );

    expect(await repository.getAll(), hasLength(1));
    expect(prefs.getBool(starterSeededPrefKey), isTrue);

    await runFirstLaunchSeed(
      prefs: prefs,
      repository: repository,
      loadPrompts: () async => [
        ...sampleStarters,
        Prompt(
          id: 'starter-2',
          title: 'B',
          body: 'b',
          createdAt: DateTime.utc(2026, 1, 1),
          updatedAt: DateTime.utc(2026, 1, 1),
        ),
      ],
    );

    expect(await repository.getAll(), hasLength(1));
  });

  test('restoreStarterPrompts adds only missing ids', () async {
    await repository.create(sampleStarters.first);

    final imported = await restoreStarterPrompts(
      repository: repository,
      loadPrompts: () async => [
        ...sampleStarters,
        Prompt(
          id: 'starter-2',
          title: 'B',
          body: 'b',
          createdAt: DateTime.utc(2026, 1, 1),
          updatedAt: DateTime.utc(2026, 1, 1),
        ),
      ],
    );

    expect(imported, 1);
    expect(await repository.getAll(), hasLength(2));
  });

  test('importStarterPrompts skips existing ids', () async {
    await repository.create(sampleStarters.first);
    await importStarterPrompts(repository, sampleStarters);
    expect(await repository.getAll(), hasLength(1));
  });
}
