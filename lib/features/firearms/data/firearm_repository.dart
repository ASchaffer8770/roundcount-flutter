import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../data/db/app_database.dart';

class FirearmRepository {
  FirearmRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  Stream<List<Firearm>> watchAll() {
    return (_db.select(_db.firearms)
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .watch();
  }

  Future<Firearm?> getById(String id) {
    return (_db.select(_db.firearms)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Stream<Firearm?> watchById(String id) {
    return (_db.select(_db.firearms)..where((t) => t.id.equals(id)))
        .watchSingleOrNull();
  }

  Future<void> add({
    required String brand,
    required String model,
    required String caliber,
    required String firearmClass,
    String? serialNumber,
  }) async {
    final now = DateTime.now();
    await _db.into(_db.firearms).insert(
          FirearmsCompanion.insert(
            id: _uuid.v4(),
            brand: brand,
            model: model,
            caliber: caliber,
            firearmClass: firearmClass,
            serialNumber: Value(serialNumber),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<void> update({
    required String id,
    required String brand,
    required String model,
    required String caliber,
    required String firearmClass,
    String? serialNumber,
  }) async {
    await (_db.update(_db.firearms)..where((t) => t.id.equals(id))).write(
      FirearmsCompanion(
        brand: Value(brand),
        model: Value(model),
        caliber: Value(caliber),
        firearmClass: Value(firearmClass),
        serialNumber: Value(serialNumber),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
