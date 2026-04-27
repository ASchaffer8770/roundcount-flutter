import 'dart:math' show max;

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../data/db/app_database.dart';

class SessionRepository {
  SessionRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  Stream<List<RangeSession>> watchAllSessions() {
    return (_db.select(_db.rangeSessions)
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .watch();
  }

  Stream<RangeSession?> watchSessionById(String id) {
    return (_db.select(_db.rangeSessions)..where((t) => t.id.equals(id)))
        .watchSingleOrNull();
  }

  Stream<List<FirearmRun>> watchRunsForSession(String sessionId) {
    return (_db.select(_db.firearmRuns)
          ..where((t) => t.sessionId.equals(sessionId))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .watch();
  }

  Stream<List<FirearmRun>> watchRunsForFirearm(String firearmId) {
    return (_db.select(_db.firearmRuns)
          ..where((t) => t.firearmId.equals(firearmId))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .watch();
  }

  Stream<List<FirearmRun>> watchAllRuns() {
    return _db.select(_db.firearmRuns).watch();
  }

  Future<String> startSession({String? notes}) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    await _db.into(_db.rangeSessions).insert(
          RangeSessionsCompanion.insert(
            id: id,
            startedAt: now,
            notes: Value(notes),
            createdAt: now,
            updatedAt: now,
          ),
        );
    return id;
  }

  Future<void> addFirearmRun({
    required String sessionId,
    required String firearmId,
    String? ammoProductId,
    required int roundsFired,
    int malfunctionCount = 0,
    String? notes,
  }) async {
    final now = DateTime.now();
    await _db.transaction(() async {
      await _db.into(_db.firearmRuns).insert(
            FirearmRunsCompanion.insert(
              id: _uuid.v4(),
              sessionId: sessionId,
              firearmId: firearmId,
              ammoProductId: Value(ammoProductId),
              roundsFired: roundsFired,
              malfunctionCount: Value(malfunctionCount),
              notes: Value(notes),
              createdAt: now,
              updatedAt: now,
            ),
          );

      final firearm = await (_db.select(_db.firearms)
            ..where((t) => t.id.equals(firearmId)))
          .getSingleOrNull();
      if (firearm != null) {
        await (_db.update(_db.firearms)..where((t) => t.id.equals(firearmId)))
            .write(FirearmsCompanion(
          totalRounds: Value(firearm.totalRounds + roundsFired),
          updatedAt: Value(now),
        ));
      }

      if (ammoProductId != null) {
        final ammo = await (_db.select(_db.ammoProducts)
              ..where((t) => t.id.equals(ammoProductId)))
            .getSingleOrNull();
        if (ammo != null && ammo.roundsOnHand != null) {
          final newCount = max(0, ammo.roundsOnHand! - roundsFired);
          await (_db.update(_db.ammoProducts)
                ..where((t) => t.id.equals(ammoProductId)))
              .write(AmmoProductsCompanion(
            roundsOnHand: Value(newCount),
            updatedAt: Value(now),
          ));
        }
      }
    });
  }

  Future<void> endSession(String sessionId) async {
    final now = DateTime.now();
    await (_db.update(_db.rangeSessions)
          ..where((t) => t.id.equals(sessionId)))
        .write(RangeSessionsCompanion(
      endedAt: Value<DateTime?>(now),
      updatedAt: Value(now),
    ));
  }
}
