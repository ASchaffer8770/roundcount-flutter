import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../data/db/app_database.dart';

class MaintenanceRepository {
  MaintenanceRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  Stream<List<MaintenanceEvent>> watchForFirearm(String firearmId) {
    return (_db.select(_db.maintenanceEvents)
          ..where((t) => t.firearmId.equals(firearmId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Stream<List<MaintenanceEvent>> watchAll() {
    return (_db.select(_db.maintenanceEvents)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<void> addMaintenanceEvent({
    required String firearmId,
    required String type,
    required int roundCountAtService,
    String? notes,
  }) async {
    final now = DateTime.now();
    final trimmedNotes =
        notes != null && notes.trim().isNotEmpty ? notes.trim() : null;
    await _db.into(_db.maintenanceEvents).insert(
          MaintenanceEventsCompanion.insert(
            id: _uuid.v4(),
            firearmId: firearmId,
            type: type,
            roundCountAtService: roundCountAtService,
            notes: Value(trimmedNotes),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }
}
