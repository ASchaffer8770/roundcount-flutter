import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../data/db/app_database.dart';

class AmmoRepository {
  AmmoRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  Stream<List<AmmoProduct>> watchAll() {
    return (_db.select(_db.ammoProducts)
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .watch();
  }

  Future<AmmoProduct?> getById(String id) {
    return (_db.select(_db.ammoProducts)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Stream<AmmoProduct?> watchById(String id) {
    return (_db.select(_db.ammoProducts)..where((t) => t.id.equals(id)))
        .watchSingleOrNull();
  }

  Future<void> add({
    required String brand,
    String? productLine,
    required String caliber,
    int? grain,
    required String bulletType,
    String? caseMaterial,
    int? quantityPerBox,
    double? costPerBox,
    int? roundsOnHand,
    String? notes,
  }) async {
    final now = DateTime.now();
    await _db.into(_db.ammoProducts).insert(
          AmmoProductsCompanion.insert(
            id: _uuid.v4(),
            brand: brand,
            productLine: Value(productLine),
            caliber: caliber,
            grain: Value(grain),
            bulletType: bulletType,
            caseMaterial: Value(caseMaterial),
            quantityPerBox: Value(quantityPerBox),
            costPerBox: Value(costPerBox),
            roundsOnHand: Value(roundsOnHand),
            notes: Value(notes),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<void> update({
    required String id,
    required String brand,
    String? productLine,
    required String caliber,
    int? grain,
    required String bulletType,
    String? caseMaterial,
    int? quantityPerBox,
    double? costPerBox,
    int? roundsOnHand,
    String? notes,
  }) async {
    await (_db.update(_db.ammoProducts)..where((t) => t.id.equals(id))).write(
      AmmoProductsCompanion(
        brand: Value(brand),
        productLine: Value(productLine),
        caliber: Value(caliber),
        grain: Value(grain),
        bulletType: Value(bulletType),
        caseMaterial: Value(caseMaterial),
        quantityPerBox: Value(quantityPerBox),
        costPerBox: Value(costPerBox),
        roundsOnHand: Value(roundsOnHand),
        notes: Value(notes),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
