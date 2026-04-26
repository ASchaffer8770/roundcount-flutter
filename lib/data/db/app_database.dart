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

@DataClassName('AmmoProduct')
class AmmoProducts extends Table {
  TextColumn get id => text()();
  TextColumn get brand => text()();
  TextColumn get productLine => text().nullable()();
  TextColumn get caliber => text()();
  IntColumn get grain => integer().nullable()();
  TextColumn get bulletType => text()();
  TextColumn get caseMaterial => text().nullable()();
  IntColumn get quantityPerBox => integer().nullable()();
  RealColumn get costPerBox => real().nullable()();
  IntColumn get roundsOnHand => integer().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('RangeSession')
class RangeSessions extends Table {
  TextColumn get id => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('FirearmRun')
class FirearmRuns extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text()();
  TextColumn get firearmId => text()();
  TextColumn get ammoProductId => text().nullable()();
  IntColumn get roundsFired => integer()();
  IntColumn get malfunctionCount => integer().withDefault(const Constant(0))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MaintenanceEvent')
class MaintenanceEvents extends Table {
  TextColumn get id => text()();
  TextColumn get firearmId => text()();
  TextColumn get type => text()();
  IntColumn get roundCountAtService => integer()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
    tables: [Firearms, AmmoProducts, RangeSessions, FirearmRuns, MaintenanceEvents])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            await migrator.createTable(ammoProducts);
          }
          if (from < 3) {
            await migrator.createTable(rangeSessions);
            await migrator.createTable(firearmRuns);
          }
          if (from < 4) {
            await migrator.createTable(maintenanceEvents);
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'roundcount.db'));
    return NativeDatabase.createInBackground(file);
  });
}
