import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DataClassName('Firearm')
class Firearms extends Table {
  TextColumn get id => text()();
  TextColumn get brand => text()();
  TextColumn get model => text()();
  TextColumn get caliber => text()();
  TextColumn get firearmClass => text()();
  TextColumn get serialNumber => text().nullable()();
  IntColumn get totalRounds => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Firearms])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'roundcount.db'));
    return NativeDatabase.createInBackground(file);
  });
}
